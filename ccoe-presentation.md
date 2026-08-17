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

## What I Need From the CIO — Five Explicit Asks

| # | Ask | Why | Needed by |
|---|---|---|---|
| 1 | **Investment approval** — 4 hires + 0.4 FTE managers | Permanent reqs can't open without it | Week 1 |
| 2 | **Mandate email** — read-only access across internal/shared estate | Without it, baseline slips (Risk R1) | Before Wk 1 |
| 3 | **Commercial + account-CTO engagement** — classify estate, agree CAF essential function boundary | Scanning client subs may breach contract | Week 1 |
| 4 | **CFO delegated authority** — commitment spend threshold in writing | Commitments are 1–3 year balance-sheet items | Week 4 |
| 5 | **Deputies' time formally allocated** — Alan & Peter at ~20% | Verbal = Risk R4 (2nd most likely stall) | Week 1 |

*Security & Compliance Lead: dotted line to Group CISO (not solely into cloud delivery — ISO27001 A.5.3 separation of duties).*

---

## First 30 Days — "Land and Win"

**Sequencing: reversible before irreversible.** Rightsizing, scheduling, Hybrid Benefit, waste removal in Weeks 1–4; commitment purchases no earlier than Week 8.

**Week 1 — Access, Scope, Baseline**
- Estate classification with Commercial (internal / client-contracted / shared-service)
- Three access tracks opened: RBAC Reader, EA/MCA Billing Reader, RI/SP purchase auth
- AWS Cost Explorer enabled + cost allocation tags activated (Day 1)
- **Data residency — Deny from Day 1:** Allowed Locations (uksouth, ukwest) at root MG
- Security baseline: MCSB + UK OFFICIAL/UK NHS in Defender for Cloud (assessment mode)
- AWS SCP restricting to `eu-west-2`

**Week 2 — Guardrails, Methodology, Intake**
- Savings methodology signed by Finance *before* first £ published
- Cost Management anomaly detection + budget alerts (80/100 actual, 100% forecast)
- UK Log Analytics workspace with contractual retention + immutable archive
- Intake v1 live on Forms + Power Automate + SharePoint (IS-signed)

**Week 3 — Reversible Wins**
- Non-prod auto-shutdown, AHB gaps, orphaned resources, Log Analytics tuning
- Rightsizing gated on P95 CPU + business-hours profile (not mean)

---

## 90-Day Milestone Table

| Week | Milestone | Deliverable | Owner |
|---|---|---|---|
| 1 | Estate scope classified | Cleared-scope subscription list | Vince + Commercial |
| 1 | Residency Deny live | Allowed-locations at root MG | Vince |
| 2 | Savings methodology signed | Finance-agreed definitions | Andrew + Finance |
| 2 | Logging + evidence pipeline | LA workspace, continuous export | Vince |
| 2 | Intake v1 live (IS-signed) | 3 requests processed | Alan, Peter |
| 4 | First exec report | 1-pager | Vince |
| 4 | Reversible savings realised | Finance-confirmed run-rate delta | Andrew |
| 8 | CAF self-assessment | Outcome ratings + improvement plan | Security Lead |
| 8 | First commitment purchase | 1yr Compute Savings Plan | Andrew |
| 12 | Phase 0 → Phase 1 transition | Guardrails operational | Vince |
| 12 | 90-day exec report | Full report | Vince |
| ~20 | Cloud Architect + Security Lead start | Roles filled | Vince |

*Start dates are ~16 weeks from req open, not 6.*

---

## Quick Wins — Evidence-Backed

Every row carries an evidence artefact — auditor-ready (ISO27001 cl. 9.1).

| Owner | Quick Win | Target | Evidence Artefact |
|---|---|---|---|
| Andrew | Commitment inventory | 100% RIs/SPs catalogued | Commitment register, dated |
| Andrew | Cost baseline (Actual + Amortised) | Cleared-scope covered | Cost query export, dated |
| Andrew | Tag inheritance enabled | Allocation coverage delta | Before/after allocation % |
| Andrew | Anomaly detection live | Both clouds alerting | Alert rule config export |
| Andrew | **Reversible savings realised** | **£ confirmed by Finance** | Finance-signed run-rate delta |
| Security | Allowed-locations Deny live | 100% cleared scope | Assignment ID, scope, date |
| Security | MCSB + UK OFFICIAL/UK NHS | Defender dashboard populated | Assignment ID + compliance |
| Security | High-severity findings closed | n closed / n accepted w/ expiry | Compliance export before/after |
| Compliance | CAF essential function boundary | Written, signed by Commercial | Scope statement, dated |
| Compliance | Provider assurance (CSP) | 14 principles assessed | Assessment doc with sources |
| Bare Metal | Inventory + risk register, ISMS-bound | Asset baseline defined | Register with owners, mappings |

**"Savings identified" renamed "savings pipeline (unvalidated)" everywhere.** The Board hears "£2m identified" and asks where it went every month.

---

## Compliance Architecture — NCSC CAF

**CAF is outcome-based, not control-based.** 4 objectives, 14 principles, ~39 contributing outcomes — assessed Achieved / Partially Achieved / Not Achieved. **No percentage. Any "% CAF compliant" is a category error.**

**Three artefacts, deliberately separate:**

- **(a) CAF outcome assessment** — essential function scoped first, then current-state assessment. Owned by Security & Compliance Lead, dotted line to CISO. First assessment: Weeks 4–8 (self-assessed).
- **(b) Provider assurance (CSP)** — per-principle assessment against Microsoft/AWS published responses. Under CAF: *the evidence for A4 (supply chain).* Document review, refreshed annually.
- **(c) Tenant configuration posture** — MCSB control-domain scores from Defender. Under CAF: *evidence contributing to specific outcomes* (B2, B3, B4, C1) — never a CAF rating itself.

**Where we will be weakest — and it won't be the technology:** A1 (governance), A4 (supply chain), B6 (staff awareness), and **D1 (response/recovery — requires a *tested* plan, not a documented one).** The Defender score will look fine long before the assessment does.

---

## Operating Model

**Weekly Rhythm**

| Day | Meeting | Attendees | Duration |
|---|---|---|---|
| Mon | CCoE Standup | Vince, Andrew, Alan, Peter | 15 min |
| Tue | Cost Review | Andrew leads; Vince attends | 30 min |
| Wed | Architecture Review | Alan leads; requesting team | 45 min |
| Thu | Developer Office Hours | Peter (open drop-in) | 60 min |
| Fri | Planning & Reflection | Vince + core team | 30 min |

**Decision Framework**
- CCoE decides: platform guardrails, cross-sub architecture patterns, FinOps commitments
- Workload teams decide: application architecture within guardrails, sizing within budget
- Exceptions: time-boxed with mandatory expiry (enforced by Policy Exemptions), reviewed every Friday
- Escalation: workload → review → 5 days → Vince → 5 more days → CIO

**Phase Transition Triggers**

| Phase | Triggers |
|---|---|
| Advisory → Defined | ≥95% high-severity MCSB compliance (fixed denom, sustained 4 wks); 4 consecutive weekly rhythms held; spend-allocation improved; Commercial-signed impact assessment for any Deny |
| Defined → Mandatory | Ring-based Deny rollout complete (zero unplanned incidents, 4 wks); intake ≥20 requests within SLA; Security Lead in seat *or* accountable deputy agreed |

---

## Top Risks

| # | Risk | L | I | Mitigation |
|---|---|---|---|---|
| R1 | Access requests stall | High | High | CIO mandate email before Week 1 |
| R3 | Scanning client sub breaches contract | Medium | **Critical** | Estate classified Week 1 Mon; cleared-scope list is operating boundary |
| R4 | Deputies pulled to day jobs | High | Medium | Written time allocation from line managers |
| R5 | Commitment against churned workload | Medium | High | First purchase Week 8+; 1yr SP sized to P25; exclude <24mo contracts |
| R9 | Billing-scope access blocks cost story | Medium | **High** | Escalate to CFO/Finance directly |
| R15 | Deny breaks client deployment | Low | **Critical** | Commercial-signed impact assessment; ring-based rollout |
| R17 | CAF fails on organisational grounds | **High** | High | Non-tech outcomes assigned owners outside CCoE at Week 4 |
| R18 | "% CAF compliant" enters a report | Medium | High | CAF has no percentage — no field for one in report template |

---

## Executive Report — Structure

```
CCoE Executive Report — [Month]
Prepared for: Ciaran Barr (CIO) | Security section cc: Group CISO

METHODOLOGY NOTE (standing)
All cost figures amortised. AWS at [rate], source [x].
Savings in four separate lines, never combined:
  - Realised: verified against invoice (Finance-confirmed)
  - Avoided: growth suppressed (NON-CASHABLE)
  - Pipeline (unvalidated): modelled, not actioned
  - Forecast: projected from current run rate

1. Headline (3 bullets max)
2. Estate Summary (cleared scope)
3. FinOps (realised / avoided / pipeline / forecast)
4. Security & Compliance
   - NCSC CAF outcomes: Achieved / PA / NA (SELF-ASSESSED)
   - Tenant posture (MCSB): evidence toward CAF B2/B3/B4/C1
   - Provider assurance (CSP): evidence for CAF A4
5. Bare Metal
6. Intake / Delivery
7. Next Period Priorities (3 bullets)
```

**Key principle: CAF outcomes are Achieved / Partially Achieved / Not Achieved — never a percentage.**

---

## Summary

- **Week 1:** Five CIO asks, estate classification, access tracks, residency Deny
- **Week 4:** First exec report with realised savings, provider assurance, bare-metal risk
- **Week 8:** CAF self-assessment, first commitment purchase, ServiceNow cutover (Scenario A)
- **Week 12:** Phase 0 → Phase 1 transition, 90-day full report
- **Week ~20:** Cloud Architect + Security Lead in seat

**Principle: reversible before irreversible. Advisory before Mandatory. Evidence before percentage.**
