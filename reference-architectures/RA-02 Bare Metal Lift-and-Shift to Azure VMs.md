# RA-02: Bare Metal Lift-and-Shift to Azure VMs

**Status:** Draft v1 · **Owner:** Cloud Architect + Hosting & Hybrid Cloud (George Alan) · **Date:** 2026-08-18

## When to use this pattern

Legacy applications that cannot be re-platformed in the current programme window: Windows Server / Linux apps with OS-level dependencies, custom middleware, or vendor lock-in. Goal is a like-for-like move that preserves behaviour while landing on compliant Azure infrastructure — not optimisation (that comes later).

## Topology

```
On-prem data centre                    Azure UK South
┌─────────────────────┐                ┌──────────────────────────────────┐
│ App servers         │   ExpressRoute │  Hub VNet (10.10.0.0/20)         │
│ (bare metal)        │◄══════════════►    ├── GatewaySubnet              │
│                     │   (VPN fallback)    └── peered to spoke: prod     │
│ Domain controllers  │                │      ├── App subnet             │
└─────────────────────┘                │      │    └── VMs (D-series)    │
                                       │      └── Data subnet            │
                                       │           └── disks, storage acct│
                                       └──────────────────────────────────┘
```

## Components

| Component | Choice | Notes |
|-----------|--------|-------|
| Connectivity | ExpressRoute (primary) + Site-to-Site VPN (fallback) | ER via hub GatewaySubnet; UDRs flip on when circuit lands (`enableErRouting=true`) |
| Compute | Azure VMs, D-series v5/v6 | Right-size from 30-day CPU/RAM baseline of the source server; start one size down and watch |
| OS images | Custom image via Azure Import (VHD) or Migrate for Azure | Windows Server 2019+ only — 2012/2016 must be upgraded first (EOL risk) |
| Identity | Hybrid Entra ID join (Azure AD Connect) | Keep on-prem DCs during transition; break-glass local admin documented |
| Storage | Managed disks (Premium SSD v2 for I/O-heavy), Storage Account for file shares | SMB shares → Azure Files with private endpoint |
| Licensing | Windows Server via Azure Hybrid Benefit where eligible | Check entitlements before sizing — often 40% cheaper |
| Backup | Azure Backup vault, daily + weekly retention per policy | RPO/RTO agreed in the migration plan before cutover |

## Migration approach (per server)

1. **Assess** — Migrate for Azure assessment: size, dependencies, network calls, EOL status.
2. **Replicate** — continuous replication to staging VM; delta syncs nightly.
3. **Validate** — app team runs their test suite against the replicated copy in staging.
4. **Cutover window** — stop source, final delta sync (target <15 min), start Azure VM, swap DNS/routing.
5. **Decommission** — source server retained cold for 30 days, then wiped per data policy.

## Security requirements

- No public IPs on migrated servers; all access via Bastion or ER from the estate.
- NSG rules mirror the original firewall matrix (capture it during assessment — do not guess).
- Defender for Servers plan active before cutover (landing zone covers this).
- Any server holding client data must be tagged `client` + `contract` and land in the correct spoke.

## Cost notes

- Hybrid Benefit: verify Windows Server / SQL Server licenses before sizing.
- ExpressRoute port cost is fixed — amortise across all migrated workloads; don't buy a second circuit for one app.
- Idle VMs are the #1 post-migration waste: auto-shutdown policy on dev/test copies from day 1 (Advisor scan, Phase 2).

## Risks specific to this pattern

| Risk | Mitigation |
|------|------------|
| Hidden dependencies discovered at cutover | Full dependency map in assessment; app team sign-off is a gate, not a formality |
| EOL OS versions (Win 2012/2016) | Upgrade-in-place on-prem before migration, or re-platform — decision recorded per server |
| Performance regression from disk type change | I/O benchmark in staging; Premium SSD v2 for anything >500 IOPS |
| Cutover window overrun | Rehearse the cutover runbook once in staging with real data volumes |

## Exit criteria (per workload)

- [ ] 7 days stable on Azure, error rates ≤ source baseline
- [ ] Backup restore tested successfully from Azure vault
- [ ] Source server decommissioned or formally retained with expiry date
- [ ] Runbook + break-glass access documented in wiki
