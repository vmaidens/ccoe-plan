# Migration Playbook — [WORKLOAD NAME]

> **Template version:** 1.0 · Copy this file per workload: `playbooks/[workload]-migration.md`
> **Reference patterns:** RA-01 (web app) · RA-02 (lift-and-shift) · RA-03 (Oracle DB)

## 1. Summary

| Field | Value |
|-------|-------|
| Workload name | [name] |
| Business owner | [name, role] |
| Technical owner | [name, team] |
| Pattern used | RA-0[1/2/3] + variations: [list] |
| Source environment | [on-prem / Azure legacy / AWS] |
| Target environment | [spoke env, region] |
| Data classification | [public / internal / client data — schemas named if DB] |
| Cutover window (proposed) | [date range + duration] |
| Rollback strategy | [re-point to source / restore from backup / parallel run] |

## 2. RACI

| Activity | Business owner | Tech owner | CCoE Platform | Security | Finance/FinOps |
|----------|:---:|:---:|:---:|:---:|:---:|
| Scope & business case | A/R | C | I | C | C |
| Architecture design | C | R/A | C (review) | C | I |
| Build & IaC | I | A | R | C | I |
| Testing & validation | A | R | C | C | I |
| Cost sign-off | C | I | C | I | R/A |
| Security sign-off | I | C | C | R/A | I |
| Cutover decision | A/R | R | C | C | I |
| Decommission of source | A | R | C | C (data wipe) | I |

## 3. Discovery & Assessment (Gate 1)

- [ ] Full inventory: servers, services, data stores, middleware versions
- [ ] Dependency map (inbound/outbound calls, ports, protocols) — **app team sign-off required**
- [ ] OS/middleware EOL check; upgrade decisions recorded per component
- [ ] 30-day performance baseline captured (CPU, RAM, I/O, top queries if DB)
- [ ] Data classification complete for every data store
- [ ] Licensing check: Hybrid Benefit eligibility, vendor license portability rules

**Gate 1 sign-off:** Business owner + Security Lead · Date: ______

## 4. Design & Build (Gate 2)

- [ ] Architecture doc references the correct RA pattern; deviations justified in writing
- [ ] IaC written and reviewed (PR in CCoE repo); no manual portal changes for prod
- [ ] Network: private endpoints only, NSG rules mirror source firewall matrix
- [ ] Identity: managed identities / hybrid join configured; break-glass documented
- [ ] Backup strategy agreed: vault, RPO/RTO, retention — **before** cutover
- [ ] Monitoring wired: App Insights/Defender active in target before first deploy

**Gate 2 sign-off:** Cloud Architect + Security Lead · Date: ______

## 5. Testing & Validation (Gate 3)

- [ ] App team test suite run against staging copy — results recorded
- [ ] Performance re-run vs baseline; any >10% regression on critical paths investigated and closed
- [ ] Failover/restore test performed from Azure Backup — result recorded
- [ ] Security scan: Defender findings triaged, high-severity items closed or accepted with expiry (signed outside CCoE)

**Gate 3 sign-off:** Business owner + Tech owner · Date: ______

## 6. Cutover Runbook (Gate 4)

> Rehearse this runbook once in staging with real data volumes before the live window.

| Step | Action | Owner | Duration | Rollback trigger |
|------|--------|-------|----------|------------------|
| 1 | Announce start, freeze changes on source | Tech owner | 5 min | — |
| 2 | Stop source services / begin final delta sync | Tech owner | [min] | Sync >[X] min → abort |
| 3 | Final delta complete; verify checksums/diff report | Tech owner | [min] | Diff non-empty → abort |
| 4 | Start target services, smoke tests pass | Tech owner | [min] | Smoke fail → re-point to source |
| 5 | Swap DNS/routing (TTL pre-lowered 24h prior) | Platform eng | [min] | Error rate >[X]% for [Y] min → rollback |
| 6 | Monitor window: dashboards, error rates, business KPIs | Tech owner + Business | [hours] | Any critical alert → rollback decision by Business owner |

**Gate 4 (cutover) sign-off:** Business owner · Date/time: ______

## 7. Post-Cutover & Decommission

- [ ] 7-day stability window: error rates ≤ source baseline, no P1/P2 incidents
- [ ] Source environment retained cold for 30 days with expiry date recorded
- [ ] Data wipe of source per data policy (Security sign-off)
- [ ] Cost review at day 30 vs estimate; right-sizing actions logged in FinOps backlog
- [ ] Lessons learned retro held; top friction items added to CCoE improvement backlog

## 8. Risk Register

| # | Risk | Likelihood | Impact | Mitigation | Owner | Status |
|---|------|:---:|:---:|------------|-------|--------|
| R1 | Hidden dependency discovered at cutover | M | H | Dependency map sign-off is Gate 1; app team attests completeness | Tech owner | Open |
| R2 | Cutover window overrun | M | H | Rehearsed runbook; delta sync target <[X] min; abort criteria defined per step | Tech owner | Open |
| R3 | Performance regression post-migration | M | M | Baseline re-run at Gate 3; >10% blocks sign-off | Cloud Architect | Open |
| R4 | Licensing cost surprise | L | H | Hybrid Benefit check in discovery; Finance sign-off at Gate 2 | FinOps | Open |

## 9. Sign-offs

| Role | Name | Date | Signature/Email confirmation |
|------|------|------|------------------------------|
| Business owner | | | |
| Technical owner | | | |
| Security Lead | | | |
| CCoE Lead (Vince Maidens) | | | |
