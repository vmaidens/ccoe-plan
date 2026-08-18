# RA-01 — Modern Web Application on Azure

**Status:** Draft v1 · **Owner:** Cloud Architect · **Last updated:** 2026-08-18

## When to use this pattern

New or re-platformed web workloads (APIs, portals, internal tools) that can run as containers or managed PaaS. Not for legacy apps with OS-level dependencies — see RA-02.

## Topology

```
Internet ──► Front Door (WAF + TLS termination)
                │
        Hub VNet (10.10.0.0/20)
                │  peered
        Spoke: prod (10.22.0.0/23)
          ├── App subnet ──► AKS cluster / App Service (private endpoint)
          └── Data subnet ──► Azure SQL / Cosmos DB (private endpoint)

Key Vault + Log Analytics in mgmt RG, accessed via private endpoints
```

## Components

| Component | Choice | Notes |
|-----------|--------|-------|
| Ingress | Front Door Standard/Premium | WAF ruleset from CCoE baseline; TLS 1.2+ enforced by deny-non-HTTPS policy |
| Compute (default) | App Service on Linux, isolated plan | Cheapest compliant path for <50% CPU workloads |
| Compute (scale-out) | AKS with Virtual Nodes | Use when >3 services or GPU/batch needs; node pools per env |
| Data | Azure SQL DB / Cosmos DB | Private endpoints only; no public access flag ever |
| Secrets | Key Vault + managed identity | No secrets in code, env vars, or config repos |
| CI/CD | GitHub Actions → ACR → deploy via pipeline | Pipeline template in `landing-zone` repo (Phase 2.1) |
| Logging | Log Analytics workspace per env | Retention: prod 90d hot + archive; dev/test 30d |
| Monitoring | Application Insights on every service | Auto-instrumentation for .NET/Java/Node |

## Security requirements (non-negotiable)

1. No public IPs on workloads — private endpoints only, routed via hub.
2. Managed identities everywhere; no service principals with static secrets in prod.
3. Container images scanned (ACR task + Defender for Containers); vulnerable images blocked at deploy gate.
4. AKS: RBAC enabled, network policies (Calico/Azure CNI), pod security standards `restricted` in prod.
5. All resources tagged per CCoE tag policy (`environment`, `workload`, `client`, `contract`).

## Cost notes

- App Service isolated D1 ≈ £0.35/hr/instance; AKS node pool (D4s v5) ≈ £0.62/hr/node — right-size in week 1 of any new workload.
- Front Door Premium only if you need advanced WAF + global load balancing; Standard covers most Capita cases.
- Log Analytics is the #1 cost creep: enforce ingestion limits per workspace (see Phase 1.11).

## Deployment checklist

- [ ] Spoke subnet exists in target env VNet (from landing zone)
- [ ] Private endpoint group created for data tier
- [ ] Pipeline wired to CCoE deploy template with policy gate
- [ ] App Insights + Log Analytics linked, retention set
- [ ] WAF ruleset applied; test with OWASP ZAP baseline scan
- [ ] Runbook in wiki: scale events, incident response, rollback steps

## Variations

| Variation | Change | When |
|-----------|--------|------|
| Multi-region active-active | Second Front Door region + geo-routing | Client SLA requires <50ms globally |
| Serverless front door | Functions instead of App Service for thin APIs | Spiky, low-volume endpoints |
| Hybrid data access | ExpressRoute to on-prem DB via hub gateway | Data can't leave the estate yet (see RA-03) |
