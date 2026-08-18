# CCoE Landing Zone — Deployment Guide

Hub-spoke networking + security baseline + cost governance for the Capita Azure estate (UK South primary, UK West DR).

## Layout

```
landing-zone/bicep/
├── main.bicep                  # top-level: RGs, deploys all modules
└── modules/
    ├── networking.bicep        # hub + dev/test/prod spokes, NSGs, UDRs, peering
    ├── security.bicep          # Defender plans, deny-non-HTTPS, NCSC CSP (optional)
    └── cost.bicep              # subscription budget + threshold alerts
```

## Prerequisites

1. **Management group** `ccoe-landing-zone` exists (or update the param).
2. **Entra group** for CCoE platform admins — you need its object ID:
   ```bash
   az ad group list --query "[?displayName=='CCoE Platform Admins'].id" -o tsv
   ```
3. Contributor on the target subscription (or Owner if creating budgets).

## Deploy

```bash
az login
cd landing-zone/bicep

# 1. Validate without deploying
az deployment sub validate \
  --location uksouth \
  --template-file main.bicep \
  --parameters adminGroupObjectId=<object-id> monthlyBudgetUsd=50000

# 2. Deploy (subscription scope — creates RGs, VNets, Defender, budget)
az deployment sub create \
  --location uksouth \
  --template-file main.bicep \
  --parameters adminGroupObjectId=<object-id> monthlyBudgetUsd=50000

# 3. Record outputs in the delivery log (see CCoE Delivery Action Plan.md)
az deployment sub list -o table
```

## What gets created

| Resource | Scope | Notes |
|----------|-------|-------|
| `ccoe-lz-uksouth` / `ccoe-lz-ukwest` RGs | subscription | primary + DR |
| Hub VNet `10.10.0.0/20` (Bastion, Gateway, Mgmt subnets) | uksouth | admin access via Bastion only |
| Spoke VNets dev/test/prod (`10.2x.x.0/23`) | uksouth | App + Data subnets, NSG-protected |
| Hub↔spoke peering (bidirectional) | uksouth | — |
| UDRs for ExpressRoute routing | uksouth | **disabled** until ER circuit lands (`enableErRouting=true` to flip) |
| Defender for Cloud plans | subscription | Storage, KeyVault, AppServices, Containers, SqlServers |
| Deny non-HTTPS policy assignment | subscription | built-in stable GUID |
| NCSC CSP baseline assignment | mgmt group | only if `ncscBaselinePolicySetId` supplied |
| Subscription budget + alerts at 80/95/100% | subscription | recipients via `alertRecipients` param |

## Post-deploy checklist (Phase 1 exit criteria)

- [ ] Bastion session works from corporate network into a spoke VM
- [ ] New resource group creatable in <30 min using IaC (test with a throwaway RG)
- [ ] Defender posture visible in portal, no unassigned plans
- [ ] Budget alert email received on test threshold
- [ ] ExpressRoute circuit ordered → flip `enableErRouting=true` and re-deploy

## Known limitations / next steps

- **PIM** (privileged identity management) is configured via the Entra portal or Graph API — not in Bicep. Add to Phase 1 week 3 tasks.
- **Log Analytics workspace + retention** belongs with the first workload, not the landing zone shell.
- **DR region networking** is a stub RG only; build it when DR requirements are signed off (COPII plan phase).
