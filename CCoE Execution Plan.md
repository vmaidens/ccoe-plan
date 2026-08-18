# Capita CCoE — Execution Plan

> **Version:** 2.1
> **Author:** Vince Maidens, Azure Cloud Director
> **Date:** 2026-08-17
> **Sponsor:** Ciaran Barr, CIO
> **Status:** DRAFT — Ready for Executive Review
> **Technical commands:** see separate annex `CCoE Execution Plan — Technical Annex.md` — this document is the approval artefact.

---

## 0. What I Need From the CIO

Five explicit asks. Each is a decision point, not an assumption.

| # | Ask | Why | Needed by |
|---|---|---|---|
| 1 | **Investment approval** — CCoE run-rate cost at Week 12 and Month 12, covering 4 hires plus ~0.4 FTE of two managers' people. Funding source to be confirmed: your cost centre, group, or client-recovered. | Four permanent reqs cannot open without it; the Week 4 req-open date is the critical path to the Week 20 starts. | Week 1 |
| 2 | **Mandate email** authorising CCoE read-only access across the *internal and shared-service* estate. | Without it, subscription-owner access requests stall and the Week 1 baseline slips — this is Risk R1 and it is the highest-likelihood failure in the plan. | Before Week 1 Monday |
| 3 | **Commercial + account-CTO engagement** to classify the estate into internal / client-contracted / shared-service, confirm which subscriptions the CCoE may touch without client consent, and **agree the essential function boundary for NCSC CAF**. | Scanning, tagging, or policy-assigning inside a client-contracted tenant may be a contractual notification event. Separately, CAF is assessed against a defined essential function — without that boundary agreed, the compliance workstream cannot start at all. | Week 1 |
| 4 | **CFO delegated authority in writing** for commitment spend (RI/Savings Plan), with a stated £ threshold. | Commitments are 1–3 year balance-sheet items. First purchase is Week 8+, but the authority must exist before Adam builds the recommendation pack. | Week 4 |
| 5 | **Deputies' time formally allocated** by their line managers — George Alan and Peter Main at ~20%, in writing not verbally. | Verbal agreement is Risk R4; it is the second-most-likely reason this plan stalls. | Week 1 |

**Governance interlock:** the Security & Compliance Lead role is proposed as a **dotted line to the Group CISO**, not solely into cloud delivery. Compliance scores report through the CISO's channel; the CCoE reports delivery and cost through yours. This is deliberate — a security assurance role reporting only into the delivery function it assures is an ISO27001 A.5.3 separation-of-duties nonconformity and internal audit would raise it.

**Financial target:** to be set jointly by Adam Britton and Finance in Week 2, expressed as annualised run-rate reduction by Month 12 against total invested, with a stated payback period. This plan does not invent a number before the baseline is trustworthy (see §1 Week 2, Savings Methodology).

---

## 1. First 30 Days — "Land and Win"

**Sequencing principle:** every *reversible* optimisation lands before any *irreversible* commitment. Rightsizing, scheduling, Hybrid Benefit and waste removal in Weeks 1–4; commitment purchases no earlier than Week 8. This costs nothing in the Week 4 report and removes the only unrecoverable financial risk in the document.

### Week 1: Access, Scope, and Baseline

**Monday**
- **Vince:** kick-off with Ciaran Barr — walk §0, confirm all five asks, agree Week 4 report date.
- **Vince:** estate scoping session with Commercial and account CTOs — classify subscriptions into internal / client-contracted / shared-service. **Nothing in this plan touches a client-contracted subscription until that client's contract position is confirmed.** Output: a cleared-scope subscription list that every subsequent task operates against.
- **Vince:** open three *separate* access tracks — they have three different approvers and only one is on the subscription owners' desk:
  - (a) Azure RBAC **Reader + Cost Management Reader** at root MG — approver: Global Admin, requires elevating "Access management for Azure resources".
  - (b) **EA/MCA Billing Account Reader** — approver: Finance/EA admin. *This is the one that slips and everything in the exec report depends on it.* Azure RBAC alone gives no invoices, no price sheet, no reservation utilisation, no amortised export.
  - (c) **RI/SP purchase authorisation** policy change — approver: EA admin. Needed by Week 6, not Week 3.
- **Adam:** AWS Day-1 checklist — enable Cost Explorer in the payer account (takes up to 24h to populate), **activate cost allocation tags** (not retroactive — every day this is delayed is a day of unallocatable history), configure a CUR 2.0 / FOCUS 1.0 export to S3, inventory the AWS Organizations tree.
- **Vince:** stand up Teams channels (`#ccoe-general`, `#ccoe-alerts`, `#ccoe-intake`, `#ccoe-office-hours`); pin Charter, Build Plan, this document.
- **CCoE service principal:** created with **workload identity federation** (no client secret), time-bound, Reader-only, logged.

**Tuesday**
- **Adam:** cost baseline via ad-hoc `costmanagement query` over an explicit 30-day custom period — **run twice, ActualCost and AmortizedCost**. Scheduled blob exports get provisioned properly in Week 2, not rushed on Day 2.
- **Adam:** **existing commitment inventory** — what RIs/SPs Capita already holds, utilisation, expiry calendar, any stranded on decommissioned workloads. This routinely surfaces savings on its own and it is the precondition for any future purchase.
- **Adam:** tag compliance scan — case-normalised (`bag_keys()`/`tolower()`), with an explicit denominator, joined to subscription names, paginated. Verify the subscription count returned matches `az account list` before publishing any percentage.
- **Vince:** resource inventory by type and subscription across cleared scope.

**Wednesday**
- **Data residency — Deny from Day 1.** Assign built-in **Allowed locations** and **Allowed locations for resource groups** scoped to UK South / UK West at root MG, in **Deny**. AWS equivalent: SCP restricting to `eu-west-2`. This is the deliberate exception to the audit-first rule — these policies only block *new* out-of-region deployments and residency is an explicit contractual term on public-sector work.
- **Security baseline — assessment, not scoring.** Enable **Microsoft Cloud Security Benchmark** (auto-assigned in Defender for Cloud) as the technical baseline, plus the **UK OFFICIAL** and **UK NHS** standards in the **Defender for Cloud regulatory compliance dashboard**. Verify in-tenant availability first — Microsoft has been retiring the Azure Policy initiative versions of regulatory standards in favour of the Defender dashboard. Assignments use `--enforcement-mode DoNotEnforce` with `--mi-system-assigned` (not a `--params effect` override, which these initiatives do not expose).
- **Tag taxonomy extended** beyond FinOps: mandatory set is now `CostCentre`, `Environment`, `Owner`, **`DataClassification`** (OFFICIAL / OFFICIAL-SENSITIVE), **`Client`**, **`Contract`**. Without the last three you cannot answer "which resources hold client X's OFFICIAL-SENSITIVE data and are they all in-region" — which is the first question any accreditor asks.
- **Adam:** reversible waste scan via **Azure Advisor** cost recommendations (Advisor already computes idle-VM analysis; Resource Graph holds no metrics data and cannot). Scope: non-production auto-shutdown gaps, **Azure Hybrid Benefit** coverage gaps, orphaned public IPs/NICs/disks, old snapshots, Log Analytics ingestion and retention settings, idle PaaS SKUs.
- **Vince:** open the bare-metal engagement **personally** — framed as resourcing and support, not compliance policing (Risk R8). Issue Appendix C inventory template to infra leads, due Friday Week 2.

**Thursday**
- **Vince:** confirm ServiceNow delivery timeline with the platform team — locks Scenario A vs B (§2).
- **Vince:** draft the single-page estate summary from Tuesday's inventory.
- **Adam + Vince:** initiate the **control-to-contract matrix** with Commercial — which client requires which control, at what assurance level, with what reporting cadence and notification SLA. Three things must come out of this session, because the whole compliance workstream is shaped by them:
  1. **Which assurance instrument each contract cites** — CAF (assumed), CSP, or both — and **which CAF version**.
  2. **Whether assurance runs through GovAssure** (and at Baseline or Enhanced profile), a NIS-regulator route, or client-direct.
  3. **The essential function(s) in scope.** CAF is assessed against a defined essential function, not against a platform. Until that boundary is agreed in writing with Commercial and the client, a CAF assessment cannot start — and the boundary determines whether specific bare-metal sites are inside or outside it. This is the single highest-leverage output of Week 1.

**Friday**
- Vince + Adam: 30-min readout, set Week 2 priorities.
- Vince: Week 1 note to Ciaran — what shipped, headline numbers, blockers.
- Vince: brief Alan and Peter with the pack and their Week 2 ownership (Alan: architecture review cadence; Peter: intake dry run).

### Week 2: Guardrails, Methodology, and Intake

- **Adam + Finance: agree and sign the Savings Methodology** *before the first number is published*. Four separate lines, never conflated: **identified** (modelled, not actioned), **realised** (verified against invoice as run-rate delta), **avoided** (growth suppressed — explicitly labelled non-cashable), **forecast**. Plus: FX rate and source for AWS figures (Cost Explorer returns USD, the report is in £), and a standing statement that all figures are **amortised**. Cheap now, impossible later.
- **Adam:** enable **Cost Management anomaly detection** (Azure) and **Cost Anomaly Detection** (AWS) — free, under an hour, and catches the runaway that budget alerts structurally cannot.
- **Adam:** budget alerts — **actual at 80% and 100%, forecast at 100%. Drop 120%** (a 120% actual alert fires after you have already overspent by 20%; it has no preventive value). Re-baseline subscriptions with known planned growth before go-live, or `#ccoe-alerts` gets trained to be ignored in week three.
- **Adam:** enable **Cost Management tag inheritance** (EA/MCA) — applies subscription and RG tags to child cost records without touching a single resource. This delivers more allocation coverage in an afternoon than a fortnight of remediation chasing.
- **Logging architecture:** deploy a **UK-region Log Analytics workspace** via DeployIfNotExists at root MG for Activity Log and resource diagnostic settings. Retention set to the **contractual figure — read it from the contracts, do not guess**. Immutable/WORM archive with legal hold for the evidence set. Entra sign-in and audit log export enabled. This is the evidence base for **CAF C1 (security monitoring)** and **C2 (proactive event discovery)** — the outcomes most often rated Not Achieved, because "we have logs" is not the outcome. C1 requires monitoring that is *scoped to the essential function*, with defined coverage, alert triage, and someone accountable for acting on it. Log Analytics is necessary and nowhere near sufficient; the gap between the two is the SOC interlock, which belongs to the CISO and must be raised in Week 2, not discovered at assessment.
- **Evidence pipeline:** enable Defender for Cloud **continuous export**; schedule monthly Policy compliance state export (Resource Graph `PolicyResources` → immutable dated storage) and monthly Defender regulatory compliance report. Index by control ID. This makes the audit story automatic rather than reconstructed from memory.
- **Alan + Peter:** intake v1 live on Forms + Power Automate + SharePoint — **with written sign-off from Information Security and the ServiceNow owner**, a hard retirement date, and a defined retention/export path. This store will hold security exception records; it cannot be an ungoverned shadow ITSM.
- **Peter:** dry-run intake against 2–3 real in-flight requests; log friction.
- **Bare-metal register** closed out and bound to the ISMS (see below).

### Week 3: Reversible Wins and Remediation

- **Adam:** action reversible savings only — non-production auto-shutdown schedules (typically the single largest fast win, ~65% on dev/test compute), Azure Hybrid Benefit coverage gaps (frequently larger than the RI opportunity and reversible in minutes), orphaned resource cleanup, Log Analytics retention tuning.
- **Adam:** rightsizing recommendations issued — gated on **P95 CPU and a business-hours profile**, not mean CPU (a <5% average will flag a batch host that runs flat out for two hours nightly). Memory pressure is invisible without the guest agent, so every CPU-only recommendation is flagged provisional to the app team.
- **Adam:** tag remediation sprint, targeting **% of monthly spend attributable to a cost centre** — not % of resource count (10,000 untagged NICs move a count metric a long way and represent almost no spend). Note tags do not inherit at resource level; Cost Management groups by resource tag. Activity Log retains 90 days, so owner inference fails on older resources and often resolves to a pipeline service principal rather than a person.
- **Security:** remediate top findings by **severity-weighted** priority from the Defender regulatory compliance dashboard, not by raw count.
- **Bare metal:** remediate top 3 risks with named risk-owner sign-off and a recorded treatment decision.

### Week 4: First Executive Report

- **Vince:** deliver the Executive Report (Appendix B) to Ciaran Barr, with the Security section copied to the Group CISO.
- **Vince:** Weeks 1–4 retro; confirm hiring timelines against actual workload evidence; name internal secondment fallback candidates.

#### Quick Wins with Measurable Outcomes

Every row carries an evidence artefact — an auditor needs a documented measurement method, source, frequency, responsible person, and a retained record (ISO27001 cl. 9.1).

| Owner | Quick Win | Target | Evidence Artefact | By |
|---|---|---|---|---|
| Adam | Existing commitment inventory | 100% of RIs/SPs catalogued with utilisation | Commitment register, dated | Day 2 |
| Adam | Cost baseline (Actual + Amortised) | Cleared-scope subscriptions covered | Cost query export, dated | Day 2 |
| Adam | Tag compliance baseline | Baseline % of spend allocated, denominator stated | ARG export + subscription reconciliation | Day 2 |
| Adam | Tag inheritance enabled | Allocation coverage delta measured | Before/after allocation % | Week 2 |
| Adam | Anomaly detection live | Both clouds, alerting to `#ccoe-alerts` | Alert rule config export | Week 2 |
| Adam | Budget alerts live (actual 80/100, forecast 100) | 100% cleared-scope subs | Budget config export | Week 2 |
| Adam | **Reversible savings realised** | **£ confirmed by Finance against invoice** | Finance-signed run-rate delta | Week 4 |
| Security | Allowed-locations Deny live | 100% cleared-scope subs, UK-only | Assignment ID, scope, date | Day 3 |
| Security | MCSB + UK OFFICIAL/UK NHS enabled | Defender dashboard populated | Assignment ID + compliance export | Day 3 |
| Security | Log Analytics + retention live | Contractual retention met, immutable archive | Workspace config + retention setting | Week 2 |
| Security | High-severity findings **closed** | n closed / n accepted-with-expiry (reported separately — a raised ticket is not remediation) | Compliance export before/after | Week 3 |
| Compliance | CAF essential function boundary agreed | Written, signed by Commercial + client | Scope statement, dated | Week 1 |
| Compliance | CAF current-state self-assessment | Contributing outcomes rated A / PA / NA, gaps named | Assessment record + improvement plan | Week 8 |
| Compliance | Provider assurance (CSP) — evidence for CAF A4 | 14 CSP principles assessed against Microsoft/AWS published responses | Assessment doc with source + date + residual risk | Week 4 |
| Bare Metal | Inventory + risk register, ISMS-bound | Asset baseline defined, then 100% reviewed against it | Register with owners, classifications, A-control mapping | Week 2 |
| Bare Metal | Top 3 risks treated | 3 treatment decisions signed by named risk owners | Signed treatment records | Week 4 |
| Intake | Process v1 trialled, IS-signed-off | 3 real requests processed | Intake log + IS sign-off | Week 2 |

**Note on "savings identified":** it is renamed **savings pipeline (unvalidated)** everywhere it appears. The Board hears "£2m identified" once and asks where it went every month for a year.

#### Compliance Architecture — NCSC CAF as the Primary Instrument

**Working assumption: client contracts invoke the NCSC Cyber Assessment Framework (CAF), not the Cloud Security Principles.** Confirmed in the Week 1 Thursday control-to-contract session, including the CAF version cited and whether assurance runs through **GovAssure** (Baseline or Enhanced profile) or a NIS-regulator route. If any contract turns out to cite CSP instead, artefact (b) below covers it — nothing is wasted either way.

This changes the compliance model materially, and in our favour:

- **CAF is outcome-based, not control-based.** 4 objectives, 14 principles, ~39 contributing outcomes, each assessed **Achieved / Partially Achieved / Not Achieved** against Indicators of Good Practice. There is no percentage. Any "% CAF compliant" figure is a category error — do not let one enter a report.
- **CAF is scoped to an essential function, not to a platform.** It is assessed across everything supporting that function. Azure, AWS and bare metal fall inside one assessment boundary by construction — the bare-metal workstream stops being a matter of goodwill.
- **CAF assesses us, not Microsoft.** Unlike CSP, most outcomes are genuinely ours to own and evidence, which makes the CCoE the natural home for them.

Three artefacts, deliberately separate:

- **(a) CAF outcome assessment — the primary instrument.** Essential function(s) scoped first (nothing else can start until that is agreed with Commercial and the client), then a current-state assessment of the contributing outcomes the CCoE can influence, with a target profile and a **targeted improvement plan**. Owned by the Security & Compliance Lead, dotted line to the CISO. Objectives B (protecting), C (detecting) and D (minimising impact) are largely in CCoE scope; A1 (governance) and A4 (supply chain) need the CISO and Commercial. First assessment is Weeks 4–8, self-assessed and explicitly labelled as such — an independent validated assessment is a separate commissioned exercise.
- **(b) Provider assurance (CSP).** Per-principle assessment against Microsoft's and AWS's published responses to the Cloud Security Principles. Under CAF this is not a parallel exercise — it is **the evidence for A4 (supply chain)**, which is exactly where a self-assessment gets challenged. Recorded with assertion source, date, and residual risk. Document review, refreshed annually. Not a dashboard.
- **(c) Tenant configuration posture.** MCSB control-domain scores from the Defender for Cloud regulatory compliance dashboard, plus UK OFFICIAL / UK NHS standards. Under CAF this is **evidence contributing to specific outcomes** — B2 identity and access, B3 data security, B4 system security, C1 security monitoring — never a CAF score in itself. That framing is legitimate and survives scrutiny; a claimed crosswalk percentage does not. There is no official MCSB→CAF mapping and we will not invent one; the mapping we maintain is an internal evidence index, labelled as such.

**Where we will be weakest, and it will not be the technology.** The CAF objectives most likely to come back Partially Achieved are A1 (governance — clear accountability for the essential function), A4 (supply chain), B6 (staff awareness), and **D1 (response and recovery planning), where the binding evidence is a tested plan, not a documented one**. Every one of those is organisational. Budget effort accordingly: the Defender score will look fine long before the assessment does.

#### Bare Metal — Bound to the ISMS and Inside the CAF Boundary

**CAF settles the "is bare metal first-class" question structurally.** The framework is scoped to an essential function and assessed across everything supporting it. If a bare-metal site supports the essential function, its asset management (A3), system security (B4), resilience (B5), monitoring (C1) and recovery (D1) outcomes are assessed on exactly the same footing as Azure's — and a gap there caps the outcome rating for the whole function regardless of how good the cloud estate looks. That is a stronger argument for infra engagement than anything in the Charter, and it is the framing to use in the Week 1 Wednesday conversation.

Appendix C is an ISMS artefact, not a spreadsheet. Each asset carries an owner (A.5.9), a data classification, and a mapping to Annex A controls: physical and environmental (A.7.1–A.7.14 — perimeter, access records, cabling, equipment siting, secure media disposal), vulnerability and patch management with a defined **SLA** (A.8.8 — "behind, by how much" is descriptive, not a control), backup and restore **testing** (A.8.13), and secure decommissioning with certificates of destruction for EOL kit holding government data. Each risk carries a treatment decision (treat / tolerate / transfer / terminate) signed by a named risk owner with a review date. Confirm whether these sites are in the certified ISO27001 scope and Statement of Applicability, and whether Cyber Essentials Plus scope is a contract condition.

#### Executive Deliverables

- **First executive report** (Week 4 → Ciaran Barr; Security section → Group CISO): 1 page. Estate size, spend baseline, **realised** savings, tenant posture score, provider assurance status, bare-metal risk status, intake volume, next-30-day priorities. Template at Appendix B, including the savings methodology note.
- **Single-page estate summary:** subscription/account count, resource count by type, monthly spend by cloud (amortised, £, FX stated), spend-allocation %, MCSB posture %, residency exceptions. Sourced from scheduled exports — no manual spreadsheet maintenance beyond Week 1.

#### Team Onboarding

- **Alan / Peter:** Week 1 pack = Charter, Build Plan, this plan, read-only dashboards. Alan owns architecture review cadence; Peter owns intake dry-run. They decide within their workstream; anything touching commitment spend, Deny-mode policy changes, security exceptions above the risk threshold, or client-contracted scope goes to Vince.
- **New hires:** Week 1 = shadow the relevant weekly rhythm session, read the risk register and compliance posture, get **scoped least-privilege RBAC behind PIM** — not root Reader. All human privileged roles require just-in-time elevation with approval and justification.

#### First 30-Day Risks

R1 (access delays — especially billing-scope access, track (b)), R2 (residency Deny blocks a legitimate deployment), R3 (client-contract breach through premature scanning), R4 (deputies pulled to day jobs), R6 (data quality undermines the exec report), R9 (billing-scope access blocks the whole cost story). See §4.

---

## 2. 90-Day Sprint Plan

### Milestone Table

| Week | Milestone | Deliverable | Owner | Success Criteria | Dependencies |
|---|---|---|---|---|---|
| 1 | Estate scope classification | Cleared-scope subscription list | Vince + Commercial | Every sub classified | Account CTO engagement |
| 1 | Access tracks (a)(b)(c) opened | RBAC + billing + purchase authority | Vince, Adam | Track (a) and (b) granted | Global Admin, EA admin |
| 1 | Commitment inventory + cost baseline | Registers, Actual + Amortised | Adam | Cleared scope covered | Track (b) access |
| 1 | Residency Deny live | Allowed-locations at root MG | Vince | 100% cleared scope, UK-only | Track (a) access |
| 2 | Savings methodology signed | Finance-agreed definitions | Adam + Finance | Signed before first £ published | Finance engagement |
| 2 | Logging + evidence pipeline | LA workspace, continuous export | Vince | Contractual retention met | Contract retention terms |
| 2 | Anomaly detection + budgets | Both clouds alerting | Adam | 100% cleared scope | Baseline complete |
| 2 | Intake v1 live (IS-signed) | Forms + Power Automate | Alan, Peter | 3 requests processed + IS sign-off | M365 licensing, IS review |
| 2 | Bare-metal register, ISMS-bound | Ranked, owned, A-control mapped | Vince + infra leads | Asset baseline defined first | Infra engagement |
| 4 | First exec report | 1-pager | Vince | Delivered; realised £ stated | Weeks 1–3 data |
| 4 | Reversible savings realised | Auto-shutdown, AHB, waste | Adam | Finance-confirmed run-rate delta | Workload team cooperation |
| 4 | Provider assurance (CSP) → CAF A4 evidence | 14 principles assessed | Vince (pre-hire) | Documented with sources | Microsoft/AWS published responses |
| 4 | Control-to-contract matrix | Per-client control map | Vince + Commercial | Instrument, version, assurance route and essential function confirmed per contract | Commercial engagement |
| 8 | **CAF current-state self-assessment** | Outcome ratings + targeted improvement plan | Security Lead / Vince | Every in-scope outcome rated with evidence; labelled self-assessed | Essential function boundary (Wk 1), evidence pipeline (Wk 2) |
| 12 | CAF improvement plan underway | Named owners + dates per Partially/Not Achieved outcome | Vince + CISO | Organisational outcomes (A1/A4/B6/D1) resourced, not just technical ones | CAF assessment |
| 6 | Deny ring-rollout starts | Sandbox MG → dev MG | Vince | Zero unplanned breakage per ring | Commercial impact assessment signed |
| 8 | **First commitment purchase** | 1yr Compute Savings Plan | Adam | Sized to P25 of hourly baseline | CFO authority, rightsizing complete, track (c) |
| 8 | ServiceNow cutover (Scenario A) | Catalog item live | Vince, Platform Eng | 1-week parallel run completed | ServiceNow build |
| 8 | DPIA + supplier assurance | ServiceNow assessed, DPIAs filed | Security Lead / Vince | Before ServiceNow build kickoff | DPO engagement |
| 12 | Phase 0 → Phase 1 transition | Guardrails operational | Vince | See triggers below | Ring rollout complete |
| 12 | 90-day exec report | Full report | Vince | Delivered | All above |
| 16 | ServiceNow cutover (Scenario B) | Catalog item live | Vince, Platform Eng | 1-week parallel run completed | ServiceNow build |
| ~20 | Cloud Architect + Security Lead start | Roles filled | Vince | Hires in seat | Reqs open Week 4 |

### Phase Transition Triggers

Evidence-based, with defined denominators. A raw "80% of resources compliant" figure is dominated by high-count, low-risk resource types (NICs, disks, NSG rules) — you can hit 80% while every internet-facing control fails.

- **Phase 0 (Advisory) → Phase 1 (Defined Guardrails):** all four must hold —
  (a) **≥95% compliance on a named list of high-severity MCSB controls**, over a fixed denominator of in-scope production resources with exemptions enumerated, sustained 4 weeks;
  (b) 4 consecutive weeks of the weekly rhythm held without cancellation;
  (c) spend-allocation coverage improved by an agreed margin off a published baseline;
  (d) Commercial-signed impact assessment in place for any Deny beyond residency.
- **Phase 1 → Phase 2 (Mandatory):** all three must hold —
  (a) ring-based Deny rollout completed through all rings (sandbox → dev → one prod sub → all) with zero unplanned incidents under a **defined attribution process**, sustained 4 weeks;
  (b) intake has processed ≥20 requests within the Charter's tiered-gate SLA;
  (c) Security & Compliance Lead in seat **or** an accountable named deputy agreed with the CISO. *Hiring is no longer a hard gate* — see Resource Plan.

**Deny safety does not come from Audit data.** Audit tells you about resources that already exist; Deny fails *future* deployments — CI/CD runs, Bicep/Terraform applies, autoscale events — none of which appear in existing-resource compliance. Safety comes from ring-based rollout, policy evaluation in CI against IaC pre-merge, Activity Log `PolicyViolation` monitoring per ring, a named break-glass rollback owner, and a documented emergency-bypass path. Carve-outs use **Azure Policy Exemptions**, which carry mandatory expiry — this also makes the §3 exception-expiry control automatic rather than an honour system.

### Resource Plan

| Role | Req Open | Realistic Start | Rationale |
|---|---|---|---|
| Vince Maidens (Lead) | — | Active | In seat |
| Adam Britton (FinOps) | — | Active | In seat; cost work starts Week 1 |
| George Alan (Deputy) | — | Week 1, ~20% | Formal time allocation from line manager (§0 ask 5) |
| Peter Main (Deputy) | — | Week 1, ~20% | As above |
| Cloud Architect | Week 4 | **~Week 20** | Design decisions from ring rollout land Week 6+; Vince covers the gap |
| Security & Compliance Lead | Week 4 | **~Week 20** | Dotted line to CISO. NCSC/ISO evidence work exceeds Vince's capacity by Week 8 |
| Platform/DevOps Engineer | Week 8 | ~Week 24 | Needed when ServiceNow build or policy-as-code exceeds Adam/Vince capacity |
| Developer Advocate (part-time) | Week 10 | ~Week 26 | Lowest urgency — nothing to evangelise until Phase 1 guardrails are stable |

**Start dates are ~16 weeks from req open, not 6.** Between reserved-headcount approval, resourcing, market, offer and three-month notice periods, six weeks to a senior security hire is not something this organisation has achieved. **Named internal secondment fallback candidates are identified in Week 4**, and the Phase 1→2 gate no longer hard-blocks on the hires (see triggers above) — otherwise the model stalls at Week 12 by design.

### ServiceNow Integration Scenarios

**Scenario A — ready Week 8**
- Weeks 1–7: Forms + Power Automate + SharePoint (built Week 2, IS-signed-off).
- Week 6: build ServiceNow catalog item and approval workflow in parallel, using the Forms process as the functional spec.
- Week 8: **1-week parallel run**, then cut over, migrate open requests, retire the flow, redirect the intake channel link. No big-bang cutover — in-flight requests break.

**Scenario B — ready Week 16**
- Weeks 1–15: Forms is the **system of record**, not a stopgap. Invest accordingly: approval SLAs, Power Automate timeout escalations, a Power BI dashboard over the SharePoint list (Week 6) feeding the Week 12 exec report.
- Week 10: ServiceNow catalog build starts once the Cloud Architect / Security Lead are close enough to input requirements.
- Week 16: same 1-week parallel run.

**Both scenarios:** ServiceNow is a new system holding intake and security-exception data. It requires **supplier assurance assessment and DPIA screening before build kickoff** (Week 6 / Week 10 respectively). The interim Forms system needs a documented **retention schedule** — without one it is a UK GDPR Art 5(1)(e) finding on its own.

**Scenario C — slips past Week 16:** treat Forms/Power Automate as permanent infrastructure. Build the Power BI layer regardless of ETA.

---

## 3. Operating Model — How the CCoE Works Day-to-Day

### Weekly Rhythm

| Day | Meeting | Attendees | Duration | Agenda / Output |
|---|---|---|---|---|
| Monday | CCoE Standup | Vince, Adam, George Alan, Peter Main (+ hires) | 15 min | What shipped, what's blocking, what's next. Blockers only get airtime — no status theatre. |
| Tuesday | Cost Review | **Adam leads**; Vince attends; subscription owners when flagged | 30 min | Amortised spend vs budget, anomalies triggered, allocation-coverage delta, commitment utilisation, **AWS line item every week without exception**. Output: action list with owners → `#ccoe-alerts`. |
| Wednesday | Architecture Review | Alan leads (Cloud Architect when hired); requesting team | 45 min, **only when the queue has items** | Tier 2/3 intake requests per RACI. Output: approve / reject / conditions, logged in intake system. |
| Thursday | Developer Office Hours | Peter (or Developer Advocate); open drop-in | 60 min | Why did Policy block my deployment, what's the tagging standard, how do I request. Output: FAQ additions. |
| Friday | Planning & Reflection | Vince + core team | 30 min | Review against the milestone table, adjust, **review expiring policy exemptions and security exceptions**, capture risks. |

### Decision Framework

- **CCoE decides:** platform guardrails (policy definitions, tagging taxonomy, naming), cross-subscription architecture patterns, FinOps commitments above team authority. **Security exceptions above a defined risk threshold require risk-owner sign-off outside the CCoE** — Vince does not author, assign, exempt, and report on the same control.
- **Workload teams decide:** application architecture within guardrails, sizing within budget, deployment timing.
- **Escalation:** workload team → weekly review → unresolved in 5 business days → Vince (**with written delegated authority to decide**) → unresolved in 5 more → Ciaran Barr. **Anything reaching the CIO more than once a month is a design failure and gets reviewed at the retro** — if the CCoE needs the CIO to unblock routine intake disputes, its mandate is too weak to work.
- **Exceptions:** logged in the intake system, time-boxed with a mandatory expiry (enforced by Azure Policy Exemptions where technical, by the intake form where procedural), reviewed every Friday. No silent renewals.
- **Security incidents:** Defender for Cloud alerts and Entra/Activity log feeds route to a defined incident process with **named notification SLAs** — ICO 72 hours, plus contractual client notification windows which are frequently 24 hours. An ad-hoc note to the CIO is not an incident process.

### Communication Plan

- **Executive report** → Ciaran Barr, monthly (first Week 4). **Security section → Group CISO** through the CISO's channel.
- **Client security reporting** → per the control-to-contract matrix cadence, owned by the Security & Compliance Lead.
- **Cost review output** → `#ccoe-alerts`, weekly, posted from the Tuesday review.
- **Tenant posture (MCSB) + provider assurance status** → `#ccoe-general` monthly.
- **Channels:** `#ccoe-general`, `#ccoe-alerts`, `#ccoe-intake`, `#ccoe-office-hours`.

### Knowledge Management

- Playbooks versioned in git (or SharePoint version history where git access is unavailable) — that covers **document control**. Control-operation evidence is separate and automated (§1 Week 2 evidence pipeline): dated compliance exports into immutable storage, indexed by control ID.
- Whoever runs a weekly rhythm session owns updating its playbook page that week. No separate documentation backlog.
- Monthly brown bag, last Friday, folded into Planning & Reflection — one deep dive (e.g. "this month's Deny ring rollout: what broke and why").

---

## 4. Risk Register

| # | Risk | L | I | Early Warning Signal | Mitigation | Owner |
|---|---|---|---|---|---|---|
| R1 | Access requests stall, blocking the Week 1 baseline | High | High | Any of the three access tracks unactioned >48h | CIO mandate email sent before Week 1 (§0 ask 2); three tracks opened separately with three named approvers | Vince |
| R2 | Residency Deny blocks a legitimate deployment | Medium | Medium | Activity Log `PolicyViolation` events on allowed-locations | Deny scoped to new deployments only; named break-glass owner; Policy Exemption path with expiry documented before go-live | Vince |
| R3 | Scanning/tagging a client-contracted subscription breaches contract | Medium | **Critical** | Any task executing outside the cleared-scope list | Estate classified Week 1 Monday with Commercial and account CTOs; cleared-scope list is the operating boundary for every task in this plan | Vince |
| R4 | Deputies' day jobs deprioritise CCoE work | High | Medium | Alan/Peter miss 2+ consecutive rhythm sessions | Written time allocation from line managers at Week 1 (§0 ask 5), not verbal | Vince |
| R5 | Commitment purchased against a workload that churns or migrates | Medium | High | RI/SP proposal covering a contract with <24 months to run | First purchase Week 8+, after rightsizing; 1yr Compute SP sized to **P25 of hourly baseline** (~50–60% coverage), ratcheted quarterly; exclude workloads with <24 months remaining or termination-for-convenience clauses. **Savings Plans cannot be cancelled, refunded or exchanged — ever**; RI refunds are capped and carry a termination fee. Exchange is not a safety net. | Adam + CFO |
| R6 | Data quality undermines exec report credibility | Medium | High | Cost figures don't reconcile week to week | Baseline provisional until spend-allocation coverage is credible; savings methodology signed by Finance in Week 2; every published figure carries denominator, FX, and amortisation basis | Adam |
| R7 | Interim Forms/SharePoint intake becomes an ungoverned store of security exception records | Medium | High | Any exception logged before IS sign-off | IS + ServiceNow-owner sign-off before go-live, hard retirement date, documented retention schedule and export path | Vince |
| R8 | Bare-metal team treats CCoE as an audit threat | Medium | High | Infra leads slow-walk register population | Vince opens the engagement personally in Week 1 — not delegated — framed as resourcing and support | Vince |
| R9 | Billing-scope (EA/MCA) access never lands, killing the cost story | Medium | **High** | Track (b) unresolved by end of Week 1 | Escalate to CFO/Finance directly, not through subscription owners; Azure RBAC alone gives no invoices, price sheet, reservation utilisation or amortised data | Adam |
| R10 | CCoE perceived as a bottleneck; teams route around it | Medium | High | Shadow resource creation detected in Resource Graph scans | Advisory-only through Phase 0 except residency; publicise realised (not pipeline) wins before any Deny gate | Vince |
| R11 | AWS coverage remains tokenistic | Medium | Medium | No AWS-specific action in cost or security reviews by Week 4 | AWS Day-1 checklist equal to Azure's; mandatory AWS line item in every Tuesday review; if AWS is genuinely <10% of spend, state that explicitly and scope it down honestly | Adam |
| R12 | Hiring slips well past Week 20 | Medium | Medium | No candidates in pipeline by Week 10 | Reqs open Week 4; named internal secondment fallbacks identified Week 4; hiring removed as a hard phase gate | Vince |
| R13 | Compliance figures discounted by client accreditor for separation-of-duties failure | Medium | High | Any exception approved solely within the CCoE | Security & Compliance Lead dotted line to CISO; CISO named as approver of the security baseline and recipient of posture reporting; exceptions above threshold signed outside the CCoE | Vince / CISO |
| R14 | No DPIA / processor-chain evidence when a client audit lands | Medium | High | ServiceNow build kickoff approaching with no supplier assurance record | DPIA screening for intake system and for approved workloads; sub-processor register with Art 28 terms; TRA for any non-UK support path; DPO and SIRO named as consulted | Security Lead / Vince |
| R16 | CAF essential function boundary never agreed, or agreed too broadly | Medium | High | No written scope statement by end of Week 2 | Boundary is the Week 1 Thursday priority output (§0 ask 3); escalate to Ciaran if unresolved by Week 2. A boundary drawn too wide makes every outcome unachievable; too narrow and the client rejects the assessment | Vince + Commercial |
| R17 | CAF outcomes fail on organisational grounds while the technical estate looks healthy | **High** | High | Defender/MCSB posture improving while A1, A4, B6 and D1 have no named owner | Non-technical outcomes assigned owners outside the CCoE at Week 4, with the CISO. **D1 requires a *tested* recovery plan** — schedule the test, don't document the intent | Vince / CISO |
| R18 | A "% CAF compliant" figure enters a client or board report | Medium | High | Any deck citing a CAF percentage | CAF has no percentage — outcomes are Achieved / Partially / Not Achieved. Reporting template (Appendix B) has no field for one; every CAF figure is labelled self-assessed until independently validated | Vince |
| R15 | Deny rollout breaks a client deployment, triggering service credits | Low | **Critical** | Any Deny promoted without a signed impact assessment | Written impact assessment signed by Commercial and affected account leads before any Deny beyond residency; ring-based rollout; CI policy evaluation pre-merge; named rollback owner | Vince |

---

## Appendix A: Technical Command Reference

Moved to the separate technical annex — `CCoE Execution Plan — Technical Annex.md`. An approval document should not contain `az` commands, and every command in v1.0 required correction (missing required arguments, unsupported scopes, case-sensitive tag matching, missing denominators, and a Resource Graph query that cannot return the metrics data it was supposed to).

## Appendix B: Executive Report Template

```
CCoE Executive Report — [Month]
Prepared for: Ciaran Barr (CIO) | Security section cc: Group CISO
Prepared by: Vince Maidens

METHODOLOGY NOTE (standing)
All cost figures amortised. AWS converted at [rate], source [x], as at [date].
Savings reported in four separate lines, never combined:
  - Realised: verified against invoice as run-rate delta. Finance-confirmed.
  - Avoided: growth suppressed. NON-CASHABLE.
  - Pipeline (unvalidated): modelled, not actioned.
  - Forecast: projected from current run rate.

1. Headline (3 bullets max)
   - What shipped
   - Realised £ / posture movement / risks closed
   - Any decision needed from the CIO

2. Estate Summary (cleared scope)
   - Subscriptions/accounts: Azure [n], AWS [n], bare-metal sites [n]
   - Monthly spend (amortised): Azure £[x], AWS £[x], bare metal £[x]
   - Spend allocated to a cost centre: [x]% (baseline [y]%)
   - MCSB posture: [x]% (baseline [y]%) | Residency exceptions: [n]

3. FinOps (Adam Britton)
   - Realised this period: £[x]  (Finance-confirmed [Y/N])
   - Avoided this period: £[x]   (non-cashable)
   - Pipeline (unvalidated): £[x]
   - Commitment coverage: [x]% | Commitment utilisation: [x]%

4. Security & Compliance  [cc: Group CISO]
   - NCSC CAF [version], essential function: [name]
     Outcomes: Achieved [n] | Partially Achieved [n] | Not Achieved [n]  (of [total] in scope)
     Basis: SELF-ASSESSED / independently validated [date]
     NOTE: CAF has no percentage score. Do not add one to this report.
     Movement since last period: [outcome ref] PA -> A, etc.
     Top 3 gaps and owners: [outcome ref, owner, target date]
   - Tenant posture (MCSB / UK OFFICIAL / UK NHS): [x]%
     (evidence toward CAF B2/B3/B4/C1 — not a CAF rating)
   - Provider assurance (CSP, evidence for CAF A4): [n]/14 assessed, refreshed [date]
   - High-severity findings: [n] closed | [n] accepted with expiry
   - Open Sev1/Sev2: [n] | Client notifications made: [n]

5. Bare Metal
   - Assets in ISMS scope: [n] | Risks treated: [n] | Open top risk: [description]

6. Intake / Delivery
   - Requests processed: [n] | Median approval time: [x] vs SLA [y]
   - Exceptions open: [n] | Expiring next period: [n]

7. Next Period Priorities (3 bullets)
```

## Appendix C: Bare Metal Inventory & ISMS Binding Template

```
Site/DC: [name]                    In ISO27001 certified scope? [Y/N]
Supports CAF essential function? [Y/N — which]   In CAF assessment boundary? [Y/N]
Asset class: [server/storage/network/other]     Count: [n]
Asset owner (A.5.9): [name]        Data classification: [OFFICIAL / OFFICIAL-SENSITIVE]
Client / Contract: [name]          Cyber Essentials Plus in scope? [Y/N]

Age / EOL status: [in support / EOL date / EOL passed]
Patch status vs SLA (A.8.8): [compliant / n days beyond SLA of m days]
Backup & restore TESTED (A.8.13): [date last successful restore test]
Physical & environmental (A.7.x): [perimeter / access records / siting — findings]
Media sanitisation on decom (A.7.14): [process / certificate of destruction ref]

CAF outcomes touched (A3 asset mgmt / B4 system sec / B5 resilience /
                      C1 monitoring / D1 recovery): [refs + current rating]
Risk rating: [likelihood x impact]
Treatment decision: [treat / tolerate / transfer / terminate]
Risk owner (named, outside CCoE where material): [name]   Signed: [date]
Review date: [date]
Remediation plan: [action, target date]
```

---

## Appendix D: Changes from v1.0

v1.0 was reviewed by three independent expert critiques (executive sponsor, senior FinOps practitioner, UK public-sector security and compliance lead). Material changes:

1. **Added §0 "What I Need From the CIO"** — investment case, mandate, Commercial engagement, CFO delegation, deputy time allocation made explicit asks rather than buried assumptions.
2. **Client-contracted estate scoping added as a Week 1 Monday gate** — v1.0 would have scanned and policy-assigned inside client tenants without contractual clearance.
3. **Commitment purchases moved from Week 3 to Week 8+**, behind rightsizing. Reversible optimisations (auto-shutdown, Hybrid Benefit, waste) promoted into Weeks 1–4. v1.0 committed irreversible 1–3 year spend against data it separately declared provisional.
4. **Compliance model rebuilt around NCSC CAF** (v2.1) — CAF assumed as the contractual instrument, with the essential function boundary as a Week 1 output and a Week 8 self-assessment. CSP demoted to provider assurance feeding CAF A4; MCSB/Defender demoted to evidence toward specific outcomes. v1.0's NIST 800-53 → CSP scoring had no valid crosswalk, and no percentage of any kind is now reported for CAF.
5. **Data residency, data classification tags, and DPIA/processor-chain workstream added** — absent entirely from v1.0 despite being the most-audited controls on public-sector work.
6. **Logging architecture, retention, and an automated evidence pipeline added** — v1.0 could not evidence NCSC P13 at all.
7. **Identity/PIM, service principal federation, and separation of duties added**; Security & Compliance Lead given a dotted line to the CISO.
8. **Phase triggers redefined** with stated denominators and severity weighting; Deny safety moved from "4 weeks of clean Audit data" to ring-based rollout with CI policy evaluation.
9. **Hiring timelines corrected** from ~6 weeks to ~16 weeks req-to-seat; hiring removed as a hard phase gate.
10. **Savings methodology** (realised / avoided / pipeline / forecast, amortised, FX-stated) signed by Finance in Week 2 before any figure is published.
11. **Quick wins given evidence artefacts** and rewritten so they measure remediation rather than observation.
12. **All CLI commands corrected** and moved to a separate technical annex.
13. **(v2.1) Bare metal brought inside the CAF assessment boundary** — under an outcome-based, service-scoped framework it is assessed on the same footing as Azure, and a gap there caps the rating for the whole essential function. This replaces goodwill with structural necessity as the argument for infra engagement.
14. **(v2.1) Organisational CAF risk called out explicitly** (R17) — the outcomes most likely to fail are A1 governance, A4 supply chain, B6 awareness and D1 tested recovery. None are fixed by the cloud platform, and the Defender score will look healthy long before the assessment does.
