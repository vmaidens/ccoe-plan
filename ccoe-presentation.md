---
marp: true
theme: default
style: |
  section {
    font-size: 0.9em !important;
    line-height: 1.6 !important;
  }
  section h1 {
    font-size: 2.2em !important;
    line-height: 1.2 !important;
  }
  section h2 {
    font-size: 1.6em !important;
    line-height: 1.3 !important;
  }
  section h3 {
    font-size: 1.3em !important;
    line-height: 1.4 !important;
  }
  section ul, section ol {
    font-size: 0.85em !important;
    margin-top: 0.5em !important;
  }
  section li {
    margin-bottom: 0.3em !important;
  }
  section table {
    font-size: 0.7em !important;
    width: 100% !important;
  }
  section table th {
    font-size: 0.75em !important;
  }
  section table td {
    font-size: 0.65em !important;
  }
---

# Capita CCoE — Execution Plan

## Cloud Centre of Excellence: Land, Win, Scale

Vince Maidens, Azure Cloud Director — 2026-08-17

---

# Why This Plan Is Different

The CCoE isn't a policing function. It's a **service and governance layer** that helps teams ship faster while staying compliant.

We're building three things:

1. **Cost visibility** — so we know what we're spending and why
2. **Security guardrails** — so teams can't accidentally break compliance
3. **Delivery intake** — so requests don't get lost in email chains

The guiding principle is simple: **reversible before irreversible**. We fix the easy wins first (auto-shutdown, tagging, orphaned resources) before committing to any long-term contracts.

---

# What I Need From You, Ciaran

Five decisions. Not assumptions. Each one unblocks a specific risk.

| # | Decision | Why It Matters | Timeline |
|---|---|---|---|
| 1 | **Investment approval** — budget for 4 hires + 0.4 FTE from two managers | We can't open requisitions without it | Week 1 |
| 2 | **Mandate email** — CCoE gets read-only access across internal/shared estate | Without it, the Week 1 baseline slips (our biggest risk) | Before Week 1 |
| 3 | **Commercial + account-CTO engagement** — classify the estate | We can't scan client-contracted subscriptions without contractual clearance | Week 1 |
| 4 | **CFO delegated authority** — approval threshold for commitment spend | Commitments are 1-3 year balance-sheet items; this can't be ad-hoc | Week 4 |
| 5 | **Deputies' time formally allocated** — George Alan (Hosting & Hybrid Cloud Director) & Peter Main (Director AWS Services) at ~20% | Verbal agreements don't survive day-job pressure | Week 1 |

**One structural note:** the Security & Compliance Lead will report on a dotted line to the Group CISO, not just into cloud delivery. This is intentional — it's an ISO27001 requirement that the person assuring security isn't the same function delivering it.

---

# First 30 Days: "Land and Win"

**Week 1 — Access, Scope, and Baseline**

We start by understanding what we have and getting permission to look at it.

- **Estate classification** with Commercial: which subscriptions are internal, which are client-contracted, which are shared service? Nothing touches a client subscription until we have that answer.
- **Three access tracks** opened in parallel (they have different approvers):
  - Azure RBAC Reader + Cost Management Reader at root MG
  - EA/MCA Billing Account Reader (this one's critical — without it we see no invoices or reservation data)
  - RI/SP purchase authorisation
- **Data residency enforcement** — Deny policy for non-UK regions, live from Day 1
- **Security baseline** — MCSB + UK OFFICIAL/UK NHS standards enabled in Defender for Cloud (assessment mode only, not blocking yet)
- **AWS Day-1** — Cost Explorer enabled, cost allocation tags activated, CUR export configured

**Week 2 — Guardrails and Methodology**

- **Savings methodology signed by Finance** before we publish a single number. We define four separate categories: realised (verified), avoided (growth suppressed), pipeline (unvalidated), and forecast.
- **Cost anomaly detection** — catches the runaway spend that budget alerts structurally miss
- **Logging architecture** — UK-region Log Analytics workspace with contractual retention and immutable archive
- **Intake process v1** — Forms + Power Automate + SharePoint, signed off by Information Security

**Week 3 — Reversible Wins**

Now we start saving money without locking anything in:
- Non-production auto-shutdown schedules
- Azure Hybrid Benefit coverage gaps
- Orphaned resource cleanup
- Log Analytics retention tuning

---

# 90-Day Milestones

| Week | What We're Delivering | Who Owns It |
|---|---|---|
| 1 | Estate scope classified, access tracks opened, residency Deny live | Vince + Commercial |
| 2 | Savings methodology signed, logging pipeline live, intake v1 | Adam + Finance + George Alan + Peter Main |
| 4 | First executive report with realised savings, provider assurance status | Vince |
| 8 | CAF self-assessment, first commitment purchase (if rightsizing complete) | Security Lead + Adam |
| 12 | Phase 0 → Phase 1 transition (guardrails operational) | Vince |
| ~20 | Cloud Architect + Security Lead in seat | Vince |

**Important context on hiring:** start dates are ~16 weeks from requisition open, not 6. Between reserved-headcount approval, resourcing, market, offer and three-month notice periods, that's the realistic timeline. We've removed hiring from being a hard phase gate — the plan proceeds even if roles slip.

---

# Quick Wins — Evidence-Backed

Every quick win carries an evidence artefact. An auditor needs to see: measurement method, source, frequency, responsible person, and a retained record (ISO27001 cl. 9.1).

| Owner | Quick Win | Target | Evidence Artefact |
|---|---|---|---|
| Adam | Commitment inventory | 100% of RIs/SPs catalogued | Commitment register, dated |
| Adam | Cost baseline (Actual + Amortised) | Cleared-scope subscriptions covered | Cost query export, dated |
| Adam | Tag inheritance enabled | Allocation coverage delta measured | Before/after allocation % |
| Adam | Anomaly detection live | Both clouds alerting to `#ccoe-alerts` | Alert rule config export |
| Adam | **Reversible savings realised** | **£ confirmed by Finance** | Finance-signed run-rate delta |
| Security | Allowed-locations Deny live | 100% cleared scope, UK-only | Assignment ID, scope, date |
| Security | MCSB + UK OFFICIAL/UK NHS | Defender dashboard populated | Assignment ID + compliance export |
| Security | High-severity findings closed | n closed / n accepted with expiry | Compliance export before/after |
| Compliance | CAF essential function boundary | Written, signed by Commercial | Scope statement, dated |
| Compliance | Provider assurance (CSP) | 14 principles assessed | Assessment doc with sources |
| Bare Metal | Inventory + risk register, ISMS-bound | Asset baseline defined | Register with owners, mappings |

**One naming change:** we've renamed "savings identified" to **"savings pipeline (unvalidated)"** everywhere. The Board hears "£2m identified" once and asks where it went every month for a year. Being precise protects our credibility.

---

# Compliance Architecture — NCSC CAF

**CAF is outcome-based, not control-based.** It has 4 objectives, 14 principles, and around 39 contributing outcomes. Each is assessed as **Achieved / Partially Achieved / Not Achieved**. There is no percentage. Any "% CAF compliant" figure is a category error — don't let one enter a report.

**CAF is scoped to an essential function, not to a platform.** Azure, AWS and bare metal all fall inside one assessment boundary. A gap in bare metal caps the rating for the whole function regardless of how good the cloud estate looks.

**Three artefacts, deliberately separate:**

1. **CAF outcome assessment (a)** — essential function scoped first, then current-state assessment. Owned by Security & Compliance Lead, dotted line to CISO. First assessment: Weeks 4-8, self-assessed and explicitly labelled as such.

2. **Provider assurance (CSP) (b)** — per-principle assessment against Microsoft's and AWS's published responses. Under CAF, this is **the evidence for A4 (supply chain)**. Document review, refreshed annually.

3. **Tenant configuration posture (c)** — MCSB control-domain scores from Defender. Under CAF, this is **evidence contributing to specific outcomes** (B2 identity, B3 data security, B4 system security, C1 security monitoring) — never a CAF rating itself.

**Where we'll be weakest — and it won't be the technology.** The outcomes most likely to come back Partially Achieved are A1 (governance), A4 (supply chain), B6 (staff awareness), and **D1 (response and recovery — requires a *tested* plan, not a documented one)**. The Defender score will look healthy long before the assessment does.

---

# How We Work — Operating Model

**Weekly rhythm** keeps us aligned without status theatre:

| Day | Meeting | Attendees | Duration |
|---|---|---|---|
| Monday | CCoE Standup | Vince, Adam, George Alan, Peter Main | 15 min |
| Tuesday | Cost Review | Adam leads; Vince attends | 30 min |
| Wednesday | Architecture Review | George Alan leads; requesting team | 45 min |
| Thursday | Developer Office Hours | Peter Main (open drop-in) | 60 min |
| Friday | Planning & Reflection | Vince + core team | 30 min |

**Decision framework:**
- CCoE decides: platform guardrails, cross-subscription architecture patterns, FinOps commitments
- Workload teams decide: application architecture within guardrails, sizing within budget, deployment timing
- Escalation: workload team → weekly review → unresolved in 5 business days → Vince → unresolved in 5 more → Ciaran
- Exceptions: time-boxed with mandatory expiry, reviewed every Friday. No silent renewals.

**Security incidents** route to a defined incident process with named notification SLAs — ICO 72 hours, plus contractual client notification windows which are frequently 24 hours. An ad-hoc note to the CIO is not an incident process.

---

# Phase Transition Triggers

We don't move from Advisory to Defined Guardrails (Phase 0 → Phase 1) based on gut feel. Four conditions must all be met:

1. **≥95% compliance on high-severity MCSB controls** over a fixed denominator of in-scope production resources, sustained for 4 weeks
2. **4 consecutive weeks** of the weekly rhythm held without cancellation
3. **Spend-allocation coverage** improved by an agreed margin off a published baseline
4. **Commercial-signed impact assessment** in place for any Deny policy beyond residency

Moving from Defined to Mandatory (Phase 1 → Phase 2) requires:
1. **Ring-based Deny rollout complete** (sandbox → dev → one prod sub → all) with zero unplanned incidents, sustained 4 weeks
2. **Intake has processed ≥20 requests** within the Charter's tiered-gate SLA
3. **Security & Compliance Lead in seat** *or* an accountable named deputy agreed with the CISO

**Safety note:** Deny safety doesn't come from Audit data (which only shows what already exists). It comes from ring-based rollout, CI policy evaluation pre-merge, Activity Log monitoring, a named break-glass owner, and documented emergency-bypass paths.

---

# Top Risks — And How We're Managing Them

| Risk | Likelihood | Impact | Our Mitigation |
|---|---|---|---|
| Access requests stall, blocking baseline | High | High | CIO mandate email before Week 1; three separate access tracks with named approvers |
| Scanning client sub breaches contract | Medium | Critical | Estate classified Week 1 Monday; cleared-scope list is the operating boundary for every task |
| Deputies pulled to day jobs | High | Medium | Written time allocation from line managers, not verbal agreement |
| Commitment against churned workload | Medium | High | First purchase Week 8+; 1-year SP sized to P25 of hourly baseline; exclude workloads with <24 months remaining |
| Billing-scope access blocks cost story | Medium | High | Escalate to CFO/Finance directly if track (b) unresolved by end of Week 1 |
| Deny breaks client deployment | Low | Critical | Commercial-signed impact assessment before any Deny beyond residency; ring-based rollout |
| CAF fails on organisational grounds | High | High | Non-technical outcomes assigned owners outside CCoE at Week 4 |
| "% CAF compliant" enters a report | Medium | High | CAF has no percentage — our report template has no field for one |

---

# Executive Report — What It Looks Like

```
CCoE Executive Report — [Month]
Prepared for: Ciaran Barr (CIO) | Security section cc: Group CISO

METHODOLOGY NOTE (standing)
All cost figures amortised. AWS converted at [rate], source [x].
Savings reported in four separate lines, never combined:
  - Realised: verified against invoice (Finance-confirmed)
  - Avoided: growth suppressed (NON-CASHABLE)
  - Pipeline (unvalidated): modelled, not actioned
  - Forecast: projected from current run rate

1. Headline (3 bullets max)
   - What shipped
   - Realised £ / posture movement / risks closed
   - Any decision needed from the CIO

2. Estate Summary (cleared scope)
   - Subscriptions/accounts: Azure [n], AWS [n], bare-metal sites [n]
   - Monthly spend (amortised): Azure £[x], AWS £[x], bare metal £[x]
   - Spend allocated to cost centre: [x]% (baseline [y]%)
   - MCSB posture: [x]% | Residency exceptions: [n]

3. FinOps
   - Realised this period: £[x]
   - Avoided this period: £[x]
   - Pipeline (unvalidated): £[x]
   - Commitment coverage: [x]%

4. Security & Compliance
   - NCSC CAF outcomes: Achieved [n] | Partially Achieved [n] | Not Achieved [n]
   - Tenant posture (MCSB): [x]% (evidence toward CAF B2/B3/B4/C1)
   - Provider assurance (CSP): [n]/14 assessed
   - High-severity findings: [n] closed | [n] accepted with expiry

5. Bare Metal
   - Assets in ISMS scope: [n] | Risks treated: [n]

6. Intake / Delivery
   - Requests processed: [n] | Median approval time: [x] vs SLA [y]

7. Next Period Priorities (3 bullets)
```

**Key principle:** CAF outcomes are Achieved / Partially Achieved / Not Achieved. Never a percentage.

---

# Summary — The Story in Three Acts

**Act 1: Land (Weeks 1-4)**
- Five CIO asks confirmed
- Estate classified, access granted, residency Deny live
- First executive report with realised savings

**Act 2: Win (Weeks 5-12)**
- CAF self-assessment complete
- First commitment purchase (if rightsizing confirms savings)
- Phase 0 → Phase 1 transition

**Act 3: Scale (Weeks 13-20+)**
- Phase 1 → Phase 2 (mandatory guardrails)
- Cloud Architect + Security Lead in seat
- Full operating model running

**The principles that guide us:**
- Reversible before irreversible
- Advisory before mandatory
- Evidence before percentage

---

# Questions?

**Contact:** Vince Maidens, Azure Cloud Director
**Email:** vince.maidens@capita.com
**Teams:** @Vince Maidens

**Next steps:**
1. CIO confirms five asks (Week 1)
2. Estate classification with Commercial (Week 1)
3. First executive report (Week 4)
