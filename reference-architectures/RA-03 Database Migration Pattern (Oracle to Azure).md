# RA-03: Database Migration Pattern (Oracle → Azure)

**Status:** Draft v1 · **Owner:** Cloud Architect + DBA lead · **Date:** 2026-08-18
**Reference workload:** COPII (SCTS) — see `COPII_Azure_Migration_Project_Plan.md` for the full 12-phase plan.

## When to use this pattern

Oracle workloads moving off Solaris SPARC / on-prem x86 onto Azure. This is the highest-risk migration class in the estate: data integrity, licensing, and cutover windows all matter more than anywhere else.

## Target options (decision recorded per workload)

| Option | When | Notes |
|--------|------|-------|
| **Oracle on AKS/VMs + Azure Hybrid Benefit** | Must stay Oracle for now (COPII's path) | License portability rules apply — confirm with Microsoft licensing before sizing |
| **Azure Database for PostgreSQL / SQL DB** | App can be re-platformed within programme window | Cheapest long-term; requires app changes, test effort, and sign-off from the business owner |
| **Oracle Exadata on Azure (dedicated HPC)** | Very large OLTP with strict latency SLAs | Cost only justified above ~$50k/month equivalent spend |

## COPII reference path (lift-and-shift first)

```
Phase 1-3   Discovery + Oracle upgrade (on-prem, to supported version)
Phase 4     Target: AKS cluster in prod spoke, Data subnet
            - Oracle DB on VMs with Premium SSD v2 (data), separate disk for redo/undo
            - Private endpoint access from app tier; no public exposure ever
Phase 5-6   Migration: logical replication / RMAN + data pump per schema
            - Full load → delta syncs nightly → final cutover delta <30 min
Phase 7     Parallel run: shadow reads against Azure copy, diff reports daily
Phase 8     Cutover in agreed window; rollback = re-point to on-prem (kept warm 2 weeks)
```

## Non-negotiable requirements

1. **Data classification first.** Every schema classified before it moves — client data schemas land only in the correct spoke with `client`/`contract` tags. This is what any accreditor asks about first.
2. **Encryption at rest + in transit** (TDE equivalent / disk encryption; TLS for all app connections).
3. **Backup strategy agreed before cutover:** Azure Backup vault, RPO ≤ 15 min for prod, restore test performed and recorded.
4. **Performance baseline captured pre-migration** (top 20 queries by latency/throughput) — re-run post-cutover; regression >10% on any critical query blocks sign-off.
5. **Rollback plan is a tested procedure**, not a paragraph in the runbook.

## Cost notes

- Oracle licensing dominates: Hybrid Benefit eligibility check saves ~40% where applicable.
- Premium SSD v2 for data disks; redo/undo on separate disks to avoid I/O contention (this is where most Oracle-on-Azure performance issues come from).
- Log Analytics ingestion of DB audit logs can be 5–10x the app tier — set retention deliberately.

## Cutover gate checklist

- [ ] Parallel run complete: ≥7 days, diff reports clean
- [ ] Performance baseline re-run: no >10% regression on critical queries
- [ ] Restore test from Azure Backup passed (recorded)
- [ ] Rollback rehearsed in staging with real data volumes
- [ ] Business owner + security sign-off recorded in the migration plan
