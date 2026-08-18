# CCoE Execution Plan — Technical Annex

> **Version:** 1.0 | **Date:** 2026-08-17 | **Owner:** Vince Maidens
> Companion to `CCoE Execution Plan.md`. Not for executive circulation.

**Placeholders to resolve before first run:**
- `<root-mg>` — root management group ID (usually the tenant GUID). Confirm with `az account management-group list -o table`.
- `<sub-id>` — a cleared-scope subscription ID.
- Every command below runs against the **cleared-scope subscription list** produced in Week 1 Monday. Nothing runs against a client-contracted subscription until that contract position is confirmed.

**Prerequisites**

```bash
az extension add --name resource-graph
az extension add --name costmanagement
az account clear && az login          # refresh the local subscription cache first
az account list --query "length(@)"   # note this number; reconcile every ARG result against it
```

---

## A1. Access verification

```bash
# Track (a) — Azure RBAC. Elevate as Global Admin first if root MG is not visible.
az role assignment list --scope "/providers/Microsoft.Management/managementGroups/<root-mg>" -o table

# Track (b) — billing scope. If this returns nothing, RBAC alone is not enough:
# no invoices, no price sheet, no reservation utilisation, no amortised export.
az billing account list -o table
```

---

## A2. Cost baseline — run for BOTH cost types

```bash
# ActualCost
az costmanagement query \
  --scope "/subscriptions/<sub-id>" \
  --type ActualCost --timeframe Custom \
  --time-period from=2026-07-18 to=2026-08-17 \
  --dataset-granularity Daily \
  --dataset-grouping name=ResourceGroupName type=Dimension

# AmortizedCost — the one the exec report uses. Spreads commitment cost
# across the term instead of showing an upfront purchase as a spike.
az costmanagement query \
  --scope "/subscriptions/<sub-id>" \
  --type AmortizedCost --timeframe Custom \
  --time-period from=2026-07-18 to=2026-08-17 \
  --dataset-granularity Daily \
  --dataset-grouping name=ResourceGroupName type=Dimension
```

Scheduled blob export (Week 2, not Day 2 — needs a storage account provisioned first):

```bash
az costmanagement export create \
  --name ccoe-amortized-daily --scope "/subscriptions/<sub-id>" \
  --type AmortizedCost --dataset-granularity Daily \
  --timeframe MonthToDate \
  --storage-account-id "/subscriptions/<sub-id>/resourceGroups/<rg>/providers/Microsoft.Storage/storageAccounts/<sa>" \
  --storage-container ccoe-exports --storage-directory amortized \
  --recurrence Daily --recurrence-period from=2026-08-24T00:00:00Z to=2027-08-24T00:00:00Z \
  --schedule-status Active
```

Note: management group is **not** a supported export scope. Loop over subscriptions, or use billing-account scope with track (b) access.

---

## A3. Existing commitment inventory

```bash
az reservations reservation-order list -o table
az reservations reservation list --reservation-order-id <order-id> -o table
# Utilisation and Savings Plan data: Cost Management > Reservations, or the
# billing-scope REST API. Record expiry dates — the renewal calendar is the
# single highest-value output of Day 2.
```

---

## A4. Tag compliance — with a denominator

The v1.0 query had no denominator, missed empty-string tags, and was case-sensitive. All three understated non-compliance.

```bash
az graph query --first 1000 -q "
Resources
| extend keys = bag_keys(tags)
| extend lk = set_union(iff(isnull(keys), dynamic([]), keys), dynamic([]))
| extend hasCostCentre = tostring(lk) matches regex '(?i)\"cost ?cent(re|er)\"'
| extend hasEnv   = tostring(lk) matches regex '(?i)\"environment\"'
| extend hasOwner = tostring(lk) matches regex '(?i)\"owner\"'
| extend compliant = hasCostCentre and hasEnv and hasOwner
| summarize NonCompliant = countif(not(compliant)), Total = count() by subscriptionId
| extend PctNonCompliant = round(100.0 * NonCompliant / Total, 1)
| join kind=leftouter (
    ResourceContainers
    | where type == 'microsoft.resources/subscriptions'
    | project subscriptionId, subName = name
  ) on subscriptionId
| project subName, subscriptionId, NonCompliant, Total, PctNonCompliant
| order by PctNonCompliant desc
" -o table
```

**Before publishing any percentage:** confirm the row count equals `az account list --query "length(@)"`. If ARG returns fewer subscriptions than the CLI, access is incomplete and the figure is wrong — not low.

**Report the spend-weighted figure, not this one.** Resource-count compliance is dominated by NICs and disks. The number that matters is % of monthly spend attributable to a cost centre, which comes from A2 grouped by tag — and improves fastest by enabling **Cost Management tag inheritance** (EA/MCA, Cost Management > Settings > Manage tag inheritance), which applies subscription and RG tags to child cost records without touching a single resource.

---

## A5. Resource inventory and orphaned resources

```bash
az graph query --first 1000 -q "
Resources | summarize Count = count() by type, subscriptionId | order by Count desc
" -o table

# Unattached disks — projected (unprojected queries get truncated by ARG paging)
# and with the case-insensitive operator. Note: returns NO cost data.
az graph query --first 1000 -q "
Resources
| where type =~ 'microsoft.compute/disks'
| where tostring(properties.diskState) =~ 'Unattached'
| project name, resourceGroup, subscriptionId, location,
          sizeGB = toint(properties.diskSizeGB), sku = tostring(sku.name)
| order by sizeGB desc
" -o table
```

To turn disk inventory into a £ figure you need the retail price sheet (`https://prices.azure.com/api/retail/prices`) or the amortised export from A2 filtered to the disk resource IDs. The quick-wins table promises £, so do this step — don't publish a count and call it savings.

---

## A6. Idle / rightsizing candidates

Resource Graph holds **no metrics data**. Use Advisor for the Day-3 pass:

```bash
az advisor recommendation list --category Cost -o table
```

Week 2 script — per-VM, P95 not mean, business-hours-aware:

```bash
az vm list --query "[].id" -o tsv | while read -r id; do
  az monitor metrics list --resource "$id" \
    --metric "Percentage CPU" --aggregation Maximum Average \
    --interval PT1H --start-time 2026-07-18T00:00:00Z --end-time 2026-08-17T00:00:00Z \
    --query "value[0].timeseries[0].data" -o json > "cpu_$(basename "$id").json"
done
```

Gate on P95 with a business-hours profile. A <5% *mean* flags a batch host that runs flat out for two hours nightly. Memory pressure is invisible without the guest agent — flag every CPU-only recommendation as provisional to the app team.

---

## A7. Security baseline assignment

The v1.0 command would have failed: regulatory-compliance initiatives expose no single global `effect` parameter, and `effect` is not the audit-mode dial in any case. `--enforcement-mode DoNotEnforce` is.

```bash
# 1. Data residency — Deny from Day 1 (the deliberate exception to audit-first)
az policy assignment create \
  --name ccoe-allowed-locations \
  --display-name "CCoE — UK Data Residency" \
  --policy "e56962a6-4747-49cd-b67b-bf8b01975c4c" \
  --scope "/providers/Microsoft.Management/managementGroups/<root-mg>" \
  --params '{"listOfAllowedLocations":{"value":["uksouth","ukwest"]}}'

az policy assignment create \
  --name ccoe-allowed-locations-rg \
  --display-name "CCoE — UK Data Residency (RGs)" \
  --policy "e765b5de-1225-4ba3-bd56-1ac6695af988" \
  --scope "/providers/Microsoft.Management/managementGroups/<root-mg>" \
  --params '{"listOfAllowedLocations":{"value":["uksouth","ukwest"]}}'

# 2. Security baseline — assessment mode, with the managed identity that
# deployIfNotExists/modify effects require.
az policy assignment create \
  --name ccoe-security-baseline \
  --display-name "CCoE Security Baseline" \
  --policy-set-definition "<initiative-id>" \
  --scope "/providers/Microsoft.Management/managementGroups/<root-mg>" \
  --enforcement-mode DoNotEnforce \
  --mi-system-assigned --location uksouth \
  --not-scopes "/subscriptions/<excluded-sub-id>"

az policy state trigger-scan --resource-group <rg>   # don't wait ~24h for natural evaluation
```

**Choosing `<initiative-id>`:** use **Microsoft Cloud Security Benchmark** (auto-assigned by Defender for Cloud), plus **UK OFFICIAL** and **UK NHS** enabled in the Defender for Cloud regulatory compliance dashboard. Verify in-tenant availability first — Microsoft has been retiring the Azure Policy initiative versions of regulatory standards in favour of the dashboard. Do **not** use a NIST 800-53 initiative as a proxy for NCSC CSP: no published crosswalk exists.

**There is no CAF initiative, and there should not be one.** CAF is outcome-based; Azure Policy is control-based. What these assignments produce is *evidence contributing to* CAF outcomes — principally B2 (identity and access), B3 (data security), B4 (system security) and C1 (security monitoring). Maintain that mapping as an internal evidence index in the compliance workspace, clearly labelled as our own mapping and not an NCSC-published one. Never emit a percentage against a CAF outcome.

Carve-outs use exemptions, not scope holes — exemptions carry mandatory expiry, which makes the Friday exception review automatic:

```bash
az policy exemption create \
  --name "exempt-<reason>" --policy-assignment <assignment-id> \
  --scope "/subscriptions/<sub-id>/resourceGroups/<rg>" \
  --exemption-category Waiver \
  --expires-on 2026-11-17 \
  --description "Approved by <risk owner>, ticket <ref>"
```

---

## A8. Logging and evidence pipeline

```bash
az monitor log-analytics workspace create \
  -g <rg> -n ccoe-logs-uks -l uksouth --retention-time <CONTRACTUAL_DAYS>
```

`<CONTRACTUAL_DAYS>` is read from the client contracts — do not default to 90. Then:
- Activity Log + resource diagnostic settings pushed via `deployIfNotExists` at root MG.
- Entra sign-in and audit logs exported to the same workspace.
- Immutable/WORM storage with legal hold for the retained evidence set.
- Defender for Cloud **continuous export** enabled to Log Analytics/Event Hub.

Monthly evidence snapshot, dated and written to immutable storage:

```bash
az graph query --first 1000 -q "
PolicyResources
| where type == 'microsoft.policyinsights/policystates'
| project subscriptionId, policyAssignmentName = tostring(properties.policyAssignmentName),
          policyDefinitionName = tostring(properties.policyDefinitionName),
          complianceState = tostring(properties.complianceState),
          resourceId = tostring(properties.resourceId)
" -o json > "evidence/policy-state-$(date +%Y-%m).json"
```

---

## A9. AWS Day-1 checklist

```bash
# Cost Explorer must be enabled in the payer account first; up to 24h to populate.
# UnblendedCost ignores RI/SP amortisation — use amortised, matching Azure.
aws ce get-cost-and-usage \
  --time-period Start=2026-07-18,End=2026-08-17 \
  --granularity MONTHLY \
  --metrics "AmortizedCost" "NetAmortizedCost" \
  --group-by Type=DIMENSION,Key=SERVICE Type=DIMENSION,Key=LINKED_ACCOUNT

# Organizations tree
aws organizations list-accounts --output table

# Cost allocation tags — NOT retroactive, no backfill. Every day of delay is a
# day of permanently unallocatable history. Do this on Day 1.
aws ce list-cost-allocation-tags --status Inactive
aws ce update-cost-allocation-tags-status \
  --cost-allocation-tags-status TagKey=CostCentre,Status=Active \
     TagKey=Environment,Status=Active TagKey=Owner,Status=Active

# Existing commitments
aws ce get-reservation-utilization --time-period Start=2026-07-18,End=2026-08-17
aws ce get-savings-plans-utilization --time-period Start=2026-07-18,End=2026-08-17

# Anomaly detection — free, sub-hour setup
aws ce get-anomaly-monitors
```

Also: CUR 2.0 / FOCUS 1.0 export to S3 (Billing console), Compute Optimizer enabled, Trusted Advisor cost checks, SCP restricting to `eu-west-2`. Cost Explorer returns **USD** — state the FX rate and source on every £ figure in the exec report.

---

## A10. Commitment purchase — Week 8, not Week 3

Nothing here runs before rightsizing is complete and CFO delegated authority is in writing.

```bash
az consumption reservation recommendation list \
  --scope Shared --lookback-period Last30Days --reservation-type VirtualMachines
```

Sizing rules:
- **1-year Compute Savings Plan** first (flexible across VM family and region), not 3-year instance-flexible RIs.
- Size to the **P25 of the hourly baseline** over the lookback window — the floor you are confident persists, not the mean.
- Target 50–60% coverage. Ratchet up quarterly once utilisation holds >95%.
- Exclude any workload on a contract with <24 months remaining or a termination-for-convenience clause.

**Savings Plans cannot be cancelled, refunded, or exchanged.** RI refunds are capped ($50k per rolling 12 months) and carry a 12% early-termination fee. Exchange is not a safety net.
