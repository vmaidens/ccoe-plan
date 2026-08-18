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

# CCoE Delivery — Steering Update

**From plan to delivery.** What we're doing in the next 90 days, and what we need from this committee.

Vince Maidens, Azure Cloud Director · 2026-08-18

---

## Where we are

| Item | Status |
|------|--------|
| CCoE charter & governance model | ✅ Drafted — needs sign-off (this meeting) |
| Build plan (4 phases / 24 weeks) | ✅ Approved in principle |
| Policy baseline (NCSC CSP aligned) | ✅ Defined in code, ready to assign |
| Landing zone IaC (hub-spoke + security + cost) | ✅ Built — deploy scheduled Week 1 |
| Reference architectures (web app, lift-and-shift, Oracle DB) | ✅ Drafted for review |
| Migration playbook template | ✅ Ready — first workload to use it: COPII |

**The plan exists. The delivery machinery is built. What's missing is the go decision and protected time.**

---

## 90-day delivery plan

| Phase | Weeks | Outcome we can show you |
|-------|-------|--------------------------|
| **Mobilise** | 1–2 | Charter signed, team named, governance running |
| **Foundation** | 2–6 | Landing zone live: hub-spoke networking, Defender active, cost alerts firing. New resource group in <30 min via IaC |
| **Enablement** | 4–10 | 3 reference architectures proven, CI/CD pipeline working, first training delivered |
| **Prove it** | 8–14 | First real workload (COPII) through the full CCoE pipeline — with measured results |

Each phase has written exit criteria. We report against them at every steering meeting — no narrative, just evidence.

---

## What we need from steering

| # | Ask | Why it matters |
|---|-----|----------------|
| 1 | **Sign the charter** (today) | Defines decision rights; without it every policy conversation restarts from zero |
| 2 | **Protect team time:** ≥50% allocation for core CCoE members, first 3 months | The #1 risk to this programme is the team being pulled back into delivery |
| 3 | **Name the COPII cutover window** with the business owner | It's on the critical path; everything else can slip around it |
| 4 | **Confirm budget ceiling + alert recipients** for cost governance | Budgets deploy in Week 1; we need real numbers, not placeholders |

---

## KPIs — how you'll know it's working

| Metric | Target | First report |
|--------|--------|--------------|
| Request → dev environment time | < 1 hour | Month 2 |
| Policy compliance rate | > 95% | Month 2 |
| Cost variance vs budget | ±10% | Month 3 |
| Workloads delivered via CCoE pipeline | ≥ 1 (COPII) | Month 4 |
| Critical security finding remediation | < 48 hours | Month 3 |

---

## Top risks and how we're managing them

| Risk | Mitigation in place |
|------|---------------------|
| Core team pulled back to delivery work | Charter protects allocation; steering reviews monthly |
| Teams bypass CCoE, build ad-hoc | Self-service onboarding makes the compliant path the *easy* path; policy enforcement as backstop |
| Landing zone scope creep | Phase 1 scoped to what COPII needs — expand on demand, not ambition |
| Security ownership disputes | Co-owned baseline from day one: security approves, CCoE implements and operates |

---

## Decisions requested today

1. **Charter sign-off** — mandate, decision rights, KPIs (as presented)
2. **Team allocation protection** for the first 3 months
3. **COPII as the proof-of-concept workload**, cutover window to be named within 2 weeks
4. **Budget ceiling confirmation** for subscription cost governance

*Next steering: [date] — Foundation phase exit criteria review.*
