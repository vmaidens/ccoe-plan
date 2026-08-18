# CCoE Delivery Action Plan

> **Status:** Ready for mobilisation — Week 1 starts Monday 25 Aug 2026
> **Author:** Vince Maidens, Azure Cloud Director
> **Date:** 2026-08-18
> **Companion docs:** `CCoE Charter & Execution Plan.md` (mandate + governance), `CCoE Build Plan.md` (strategy), this doc (execution)

---

## Purpose

The charter defines *what* the CCoE is and *who decides what*. The build plan defines *why* and the 24-week strategy. This document answers **how we actually deliver it** — concrete actions, owners, dates, exit criteria, and the operating rhythm that keeps it running after the launch phase ends.

Delivery principle: **every phase has an exit criterion that is a working artefact, not a meeting.** If a phase "completes" with only slides produced, it hasn't completed.

---

## Operating Rhythm (starts Week 1)

| Cadence | Forum | Chair | Duration | Output |
|---------|-------|-------|----------|--------|
| Weekly | Working group (`#ccoe-platform`, `#ccoe-security`, `#ccoe-cost`) | CCoE Lead on rotation | 60 min | Updated backlog, blockers logged |
| Bi-weekly | Steering committee (exec sponsor + leads) | Exec Sponsor | 30 min max | Decisions recorded in decision log |
| Monthly | FinOps review (Finance partner + Adam) | Adam (FinOps) | 45 min | Cost report to steering |
| Quarterly | Architecture review board | Cloud Architect | 90 min | RA updates, policy changes |

**Decision log:** lives in this repo (`decisions/`), one file per decision, RFC process for anything architectural (5-day response SLA).

---

## Phase 0: Mobilise (Weeks 1–2) — "Get the machine running"

| # | Action | Owner | Deliverable | Due |
|---|--------|-------|-------------|-----|
| 0.1 | Charter sign-off by executive sponsor (charter is drafted in `CCoE Charter & Execution Plan.md`) | Vince | Signed charter committed to repo + shared with steering | Day 3 |
| 0.2 | Lock core team roster: CCoE Leads (Vince, Peter Main), Cloud Architect, Security Rep, FinOps (Adam), Platform Eng ×1–2, Developer Advocate (part-time) | Vince + HR | Named roster in `#ccoe-core`, FTE allocation confirmed in writing | Day 5 |
| 0.3 | Working environment live: Teams channels (`#ccoe-announcements`, `-platform`, `-security`, `-cost`), this git repo as system of record, wiki space for standards | Platform Eng | Channels + repo access working | Day 7 |
| 0.4 | Governance calendar recurring (weekly WG, bi-weekly steering) with standing agenda templates | Vince | Calendar invites live, RACI published in repo | Day 10 |
| 0.5 | Pick the **first workload** — one real project that will be the CCoE's proof-of-concept (candidate: COPII Azure migration, or a smaller greenfield app) | Vince + workload owner | Named project with scope doc in `playbooks/` | Day 14 |
| 0.6 | Estate baseline snapshot: Resource Graph export of all subscriptions, cost by BU, top-5 risks (feeds Phase 1 scoping) | Adam + Platform Eng | `estate-baseline.md` committed to repo | Day 14 |

**Exit criteria:** Charter signed, team named and protected, channels live, first workload chosen, estate baseline in hand.

---

## Phase 1: Foundation (Weeks 2–6) — "Deploy the landing zone"

The landing zone is the physical substrate everything else builds on. IaC for it lives in `landing-zone/` (Bicep). Deploy to a dedicated management group + subscription pair per environment.

### 1A — Networking
| # | Action | Owner | Deliverable | Due |
|---|--------|-------|-------------|-----|
| 1.1 | Deploy hub-spoke topology via `landing-zone/bicep` (hub VNet, dev/test/prod spokes, NSGs, peering) in UK South | Platform Eng | Landing zone live in `ccoe-lz-prod` subscription; deployment output committed | Week 3 |
| 1.2 | Bastion access working end-to-end from corporate network (no public RDP/SSH anywhere) | Platform Eng | Tested jump path, documented in wiki | Week 4 |
| 1.3 | Private DNS zones + private endpoints for key SaaS (Entra ID, DevOps/GitHub, storage) | Platform Eng | No data-plane traffic egressing publicly; verified with NSG flow logs | Week 5 |

### 1B — Identity & Access
| # | Action | Owner | Deliverable | Due |
|---|--------|-------|-------------|-----|
| 1.4 | RBAC model deployed: CCoE roles (Platform Admin, Security Reviewer, Cost Analyst) + workload team roles; PIM enabled for all admin roles — **no permanent admins** | Security Rep | Role matrix doc + assignments verified in portal | Week 3 |
| 1.5 | Convert Entra groups from Assigned → Dynamic Membership for CCoE core and first workload teams | Vince | Working dynamic groups, rule logic documented | Week 4 |

### 1C — Security Baseline
| # | Action | Owner | Deliverable | Due |
|---|--------|-------|-------------|-----|
| 1.6 | Defender for Cloud plans enabled (storage, Key Vault, ARM, App Services, containers) via `landing-zone/bicep/modules/security.bicep` | Security Rep | Plan status = On in portal; export committed | Week 3 |
| 1.7 | Policy initiative assigned at management group: allowed locations (UK South/UK West), required tags (`costCenter`, `environment`, `project`, `dataClassification`), deny public storage endpoints | Security Rep + Vince | Assignment IDs recorded; drift test passes (non-compliant deploy is blocked) | Week 4 |
| 1.8 | Tag taxonomy published: adds `client`, `contract` for client-data traceability (first question any accreditor asks) | Adam | One-page tag standard in wiki | Week 5 |

### 1D — Cost Governance
| # | Action | Owner | Deliverable | Due |
|---|--------|-------|-------------|-----|
| 1.9 | Subscription budgets live (80/100% actual, 100% forecast) via `landing-zone/bicep/modules/cost.bicep` | Adam | Budget config export committed; test alert received | Week 4 |
| 1.10 | Cost baseline report: Actual + Amortised for cleared-scope subscriptions, denominator stated | Adam | Dated cost query export in repo | Week 6 |

**Exit criteria:** A developer can reach a dev VM via Bastion without any public IP; a non-compliant deployment is blocked by policy; a budget alert fires. All three verified and recorded.

---

## Phase 2: Enablement (Weeks 4–10) — "Make the CCoE path the easy path"

| # | Action | Owner | Deliverable | Due |
|---|--------|-------|-------------|-----|
| 2.1 | Reference architecture RA-01 (modern web app) documented + deployed as a reference instance in dev | Cloud Architect | `reference-architectures/RA-01*.md` + live demo | Week 6 |
| 2.2 | Reference architecture RA-02 (bare-metal lift-and-shift) documented with hybrid connectivity design | George Alan + Platform Eng | `reference-architectures/RA-02*.md` | Week 7 |
| 2.3 | Reference architecture RA-03 (Oracle DB migration, COPII pattern) documented — upgrade path, replication options, cutover structure | Vince + workload owner | `reference-architectures/RA-03*.md` | Week 8 |
| 2.4 | IaC template library: parameterised Bicep modules for each RA published in repo with README per module | Platform Eng | Templates deployable from clean subscription in <1 hour | Week 9 |
| 2.5 | CI/CD pipeline pattern: GitHub Actions → Bicep/Terraform → Azure, with policy gate and cost estimate step | Platform Eng | One working pipeline for RA-01 reference instance | Week 8 |
| 2.6 | "CCoE 101" session for all engineering leads (what we provide, how to request, where docs live) — recorded | Developer Advocate | Recording + slides in wiki; attendance log | Week 6 |
| 2.7 | Self-service onboarding: new team gets RG + baseline policies + cost budget via pipeline trigger from a simple form | Platform Eng | <1 hour request-to-access, demonstrated end-to-end | Week 9 |
| 2.8 | Migration playbook template adopted for the first workload (see `playbooks/migration-playbook-template.md`) | Vince | First workload's playbook instantiated and in flight | Week 7 |

**Exit criteria:** A team that has never touched Azure can spin up a compliant dev environment using CCoE tooling in under an hour. Three RAs documented and at least one proven live. Training delivered to ≥1 cohort.

---

## Phase 3: Prove It (Weeks 8–14) — "Run the first workload through the machine"

| # | Action | Owner | Deliverable | Due |
|---|--------|-------|-------------|-----|
| 3.1 | Execute first workload via CCoE pipeline end-to-end using its migration playbook (gates enforced, no exceptions) | Workload owner + CCoE support | Workload live in prod/staging per plan | Week 12 |
| 3.2 | Lessons-learned retro with the team that used the CCOE — friction points logged to improvement backlog | Vince | Retro notes + top-5 friction items triaged | Week 13 |
| 3.3 | Steering presentation: timeline vs plan, cost vs estimate, security posture, user feedback (use `ccoe-steering-deck.md` as template) | Vince | Deck presented; decisions recorded | Week 14 |
| 3.4 | Fix top-5 friction points in a focused sprint | Platform Eng + Security Rep | Updated modules/pipelines/docs committed | Week 14 |

**Exit criteria:** One real workload delivered through the CCoE framework with gates enforced. The team that used it can articulate what worked and what didn't. Steering sees evidence, not intent.

---

## Phase 4: Scale & Operate (Months 4–6+) — "Run the CCoE"

The work becomes continuous improvement, not a project with an end date.

- **Weekly WG:** pipeline health, policy drift, cost anomalies, support tickets
- **Bi-weekly steering (30 min max):** delivery status, cost trend vs budget, security findings, one decision needed
- **Monthly FinOps:** right-sizing opportunities, reserved capacity purchases, waste identification
- **Quarterly architecture review:** RAs still fit? New Azure services worth adopting? NCSC policy changes?

### KPIs (reported monthly to steering)

| Metric | Target | Why it matters |
|--------|--------|----------------|
| Request → dev environment time | < 1 hour | Self-service works |
| Policy compliance rate | > 95% | Security baseline holds |
| Cost variance vs budget | ±10% | FinOps maturity |
| Workloads delivered via CCoE pipeline | Increasing QoQ | Adoption is real |
| MTTR security finding (critical / high) | < 48h / < 7d | Security ops works |
| Training sessions / attendees | Quarterly cadence | Enablement ongoing |

### Improvement backlog categories
`platform` · `security` · `cost` · `enablement` — public in repo, triaged weekly.

---

## Key Risks & Mitigations

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| Core team pulled back to delivery; CCoE stalls | High | Critical | Exec sponsor protects ≥50% allocation for first 3 months — written into charter sign-off (action 0.1) |
| Teams bypass CCoE, build ad-hoc | Medium | High | Make the CCoE path *easier* than the alternative; policy enforcement as backstop |
| Landing zone scope creep | High | Medium | Phase 1 scoped to what the first workload needs; expand on demand, not ambition |
| Security team resists shared ownership of policies | Medium | Medium | Co-own baseline from day one: they review/approve, we implement/operate |
| Cost governance becomes a blame game | Medium | Low | Frame as optimisation opportunities; FinOps dashboard is neutral and data-driven |
| First workload slips past Week 14 | Medium | High | Playbook gates surface slippage early; steering sees weekly status from Week 8 |

---

## Definition of Done (per phase)

- **Phase 0:** charter signed, team protected, first workload named — *all in writing*
- **Phase 1:** landing zone live with Bastion-only access, policy blocks non-compliant deploys, budget alerts fire — *verified and recorded*
- **Phase 2:** <1-hour self-service onboarding demonstrated; 3 RAs documented, ≥1 proven live
- **Phase 3:** first workload delivered through the pipeline with gates enforced; retro done; top-5 fixes shipped
- **Phase 4 (ongoing):** KPIs reported monthly for 3 consecutive months without a missed cycle

---

## Immediate Next Steps (this week)

1. Send charter to exec sponsor for sign-off (0.1) — *Vince, today*
2. Confirm team roster + FTE protection in writing (0.2) — *Vince + HR, by Thu*
3. Stand up Teams channels and repo access (0.3) — *Platform Eng, by Fri*
4. Shortlist first workload candidates for steering decision (0.5) — *Vince, before next steering*
