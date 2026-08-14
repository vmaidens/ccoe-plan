# Cloud Centre of Excellence (CCoE) — Charter & Execution Plan

> **Organisation:** Capita
> **Author:** Vince Maidens, Peter Main
> **Date:** 2026-08-14
> **Version:** 1.0 — Merged Charter + Execution Plan
> **Status:** Draft for Executive Review

---

## 1. Mission Statement

The Cloud Centre of Excellence exists to accelerate cloud adoption, establish governance standards, and enable teams across the organization to use cloud services securely, efficiently, and cost-effectively on behalf of their customers.

---

## 2. Scope

- Cloud strategy and roadmap
- Architecture standards and reference patterns
- Security and compliance guardrails
- Cost management and optimization
- Skills development and enablement
- Vendor/provider relationship management
- Innovation for new products
- **Bare metal governance and modernisation** *(added from execution plan)*

---

## 3. Tenets

1. **Security is non-negotiable** — Every cloud workload must meet security and compliance baselines before going to production.
2. **Enable over enforce** — We empower teams with self-service tooling and guardrails rather than acting as gatekeepers. We recognise this requires a level of maturity.
3. **Cost-awareness is a shared responsibility** — Every team owns the cost of what they build and run in the cloud.
4. **Automate by default** — Manual processes are technical debt; we codify policies, infrastructure, and operations wherever possible.
5. **Speed through standards** — Opinionated defaults and reference architectures accelerate delivery without sacrificing quality.
6. **Transparency builds trust** — Decisions, trade-offs, and exceptions are documented and discoverable by all stakeholders.
7. **Continuous improvement over perfection** — We iterate on our standards and practices based on real-world feedback and evolving best practices.
8. **Fail-fast** — We will celebrate failures as much as we celebrate our successes.

---

## 4. Team Structure

| Role | Count | Responsibility |
|------|-------|----------------|
| Executive Sponsor | 1 | Strategic alignment, funding, escalation path (Ciaran Barr, CIO) |
| CCoE Leads | 2 | Day-to-day leadership, roadmap ownership (Vince Maidens, Peter Main) |
| Cloud Architect(s) | 1-2 | Reference architectures, design reviews |
| Security Representative | 1 | Security policies, threat modeling, compliance (NCSC CSP alignment) |
| FinOps Representative | 1 | Cost visibility, budgeting, optimization |
| Platform Engineering | 1-2 | Tooling, automation, CI/CD, IaC standards |
| Application Team Reps | 1-2 | Feedback loop, adoption champions *(from charter)* |

**Total:** ~8-10 FTEs (some roles part-time initially)

---

## 5. Decision Rights

| Decision | Authority |
|----------|-----------|
| Cloud provider selection | Executive Sponsor + CCoE Lead |
| Architecture standards | Cloud Architect + CCoE Lead |
| Security policies | Security Rep (with CISO alignment) |
| Budget allocation | FinOps Rep + Executive Sponsor |
| Tooling selection | Platform Engineering + CCoE Lead |
| Exception requests | Steering Committee |

---

## 6. Governance Model

- **Bi-weekly steering committee meetings** — CCoE leads + executive sponsor + app team reps
- **Monthly architecture review board** — Cloud architects + CCoE leads
- **Quarterly business review** — With executive sponsors (progress vs. KPIs, budget, risks)
- **Decision log** — Maintained in shared repository (Git)
- **RFC process** — Request for Comments for major architectural decisions; 5-day response SLA
- **Operating principles:**
  - Enable, don't gate — provide guardrails, not gatekeepers
  - Automate policy enforcement where possible (Azure Policy, OPA, Config Rules)
  - Prefer self-service over ticket-based workflows
  - Measure outcomes, not activity
  - Document decisions and make them discoverable
  - Enable innovation at all stages enabling customer impact

---

## 7. Communication Plan

- **Teams channel** — Async collaboration, announcements, Q&A
- **Internal wiki** — Standards, patterns, FAQs, decision log
- **Monthly newsletter** — Changes, wins, upcoming initiatives
- **Office hours** — Ad-hoc consultations (weekly, 1-hour slots)
- **Executive dashboard** — Real-time KPI visibility for leadership

---

## 8. 24-Week Execution Roadmap

### Phase 0: Foundation (Weeks 1-4) — "See Everything, Win Fast"

**Objective:** Establish the CCoE, gain visibility, deliver quick wins to prove value.

**Quick Wins (First 30 Days):**

| # | Action | Effort | Impact |
|---|--------|--------|--------|
| 1 | Tag compliance report + auto-tag policy | 1 day | Visibility |
| 2 | Identify and rightsize idle VMs (Azure Cost Management) | 2 days | Immediate cost savings |
| 3 | Enable Azure Policy baseline (NCSC CSP aligned) | 1 day | Security posture |
| 4 | Publish first "Cloud Playbook" — how to deploy a web app | 2 days | Developer enablement |
| 5 | Set up cost alerts at subscription level | 1 day | Cost governance |
| 6 | Document bare metal → Azure connectivity options | 2 days | Hybrid foundation |

**Deliverables:**
- CCoE charter signed off by executive sponsor
- Single-page estate summary (resources, subscriptions, cost by BU, top 5 risks)
- Bare metal risk register (top 10 highest-risk servers)

---

### Phase 1: Guardrails (Weeks 5-10) — "Safe Self-Service"

**Objective:** Establish the guardrails that make self-service safe.

**Azure Landing Zone (Management Group Architecture):**

```
Management Group: CCoE (root)
├── Management Group: Landing-Zone (policy + blueprint)
│   ├── Subscription: Identity (Entra ID)
│   ├── Subscription: Networking (hub VNets, ExpressRoute, DNS)
│   ├── Subscription: Security (Log Analytics, Sentinel, Defender)
│   ├── Subscription: Policy (Azure Policy, Blueprints)
│   │
│   ├── Subscription: Sandbox (dev/test, limited)
│   ├── Subscription: Sandbox (dev/test, limited)
│   │
│   ├── Subscription: Prod-Workload-1
│   ├── Subscription: Prod-Workload-2
│   ├── Subscription: Prod-Workload-N
│   │
│   └── Subscription: Management (monitoring, backup, log analytics)
│
├── Management Group: AWS-Connectors
│   └── Azure subscriptions for AWS Service Catalog/Connector
│
└── Management Group: Legacy
    └── Subscriptions under migration review
```

**Security:**
- PIM + Conditional Access baseline (massive win, zero dev friction)
- Managed Identities replacing service accounts
- NCSC CSP aligned Azure Policy initiatives
- RBAC model: built-in roles → custom roles → avoid Contributor/Owner

**Bare Metal Governance:**
- Asset registry — every server registered in CMDB with owner, location, purpose
- Patch management — baseline OS patch levels, SLA for critical patches (within 14 days)
- Monitoring — must integrate with central monitoring (Log Analytics)
- Access control — no shared accounts, SSH key management, BMC access logging
- Capacity planning — quarterly reviews of compute/storage/power/cooling
- Decommission process — documented procedure for retiring bare metal

**Deliverables:**
- Landing zone deployed via Azure Blueprints
- Azure Policy initiatives deployed (10 baseline policies)
- PIM enabled on all privileged roles
- Bare metal governance framework published

---

### Phase 2: Enablement (Weeks 11-16) — "Accelerate Adoption"

**Objective:** Make it easy for teams to do the right thing.

**IaC Standards:**
- Bicep (Azure), Terraform (AWS), Ansible (bare metal)
- Template library: pre-approved patterns for common workloads
- PR reviews for all infrastructure changes
- State management: Terraform state in remote backends

**Self-Service Catalogue:**
- "Deploy a web app" (App Service + SQL DB + WAF)
- "Deploy containers" (AKS + ACR + Application Gateway)
- "Dev/test environment" (sandbox subscription, limited resources)
- "Create a data pipeline" (Data Factory + Synapse/Databricks)
- "Connect on-premises to cloud" (ExpressRoute + private endpoints)

**CI/CD Standards:**
- GitHub Actions or Azure DevOps for CI/CD pipelines
- Template pipelines for common patterns
- Environments with approval gates for production deployments
- Deployments via IaC — never manual portal changes

**Monitoring & Observability:**
- One Log Analytics workspace per environment (dev/test/prod)
- Central management workspace for cross-cloud/cross-environment dashboards
- Azure Monitor Agent (AMA) or Telegraf on all bare metal servers
- Alerting: CPU > 80% for 5 min, disk > 90%, memory > 90%, service down

**Training:**
- "Cloud 101" workshop — hands-on, free sandbox
- Certification targets: AZ-900 (80% staff), AZ-104 (50%), AZ-305 (architects)
- Role-based training paths (developers, architects, ops, management)

**Deliverables:**
- IaC template library published
- Self-service catalogue live (5 patterns)
- Monitoring stack deployed across all environments
- First "Cloud 101" workshop delivered

---

### Phase 3: Optimisation (Weeks 17-24) — "Continuous Improvement"

**Objective:** Shift from building to optimising — FinOps maturity, security hardening, innovation.

**FinOps:**
- Cost allocation tags enforced across all subscriptions
- Reserved instances / savings plans (1-year and 3-year)
- Auto-shutdown for dev/test environments
- Cost-per-workload dashboard per business unit
- Establish FinOps working group with finance partners

**Security Hardening:**
- Zero Trust architecture principles
- Defender for Cloud on all subscriptions
- Container scanning, VM vulnerability assessment
- Key Vault migration — eliminate hardcoded secrets
- Automated compliance reporting (NCSC CSP, ISO 27001)
- Incident response playbooks for cloud-specific scenarios
- Tabletop exercises

**Bare Metal Modernisation:**
- Wave 1 (Weeks 17-20): Monitoring, patching, access control (stabilise)
- Wave 2 (Weeks 21-24): Automation (Ansible), configuration management
- Wave 3 (Months 7-9): Workload migration assessment (lift-and-shift vs. refactor vs. retire)
- Wave 4 (Months 9-12): Execute migrations based on Wave 3 assessment

**Governance Maturity Model:**

| Level | Description | Target |
|-------|-------------|--------|
| 1 — Reactive | Issues found in audits, cost overruns discovered after | Current state |
| 2 — Defined | Policies documented, enforced via Azure Policy | Weeks 10 |
| 3 — Measured | KPIs tracked, cost/security reports automated | Weeks 16 |
| 4 — Proactive | Predictive cost modelling, automated remediation | Weeks 24 |
| 5 — Optimising | Continuous improvement, innovation-focused | Ongoing |

**Deliverables:**
- FinOps maturity Level 3 achieved
- Security hardening complete (Zero Trust, Defender, Key Vault)
- Bare metal modernisation Waves 1-2 complete
- Governance maturity Level 4 achieved

---

## 9. Key Deliverables

- Cloud landing zone with baseline security controls
- Reference architecture catalog
- Cost allocation and tagging strategy
- Cloud skills training curriculum
- Approved service catalog (vetted services/configurations)
- Incident response playbooks for cloud-specific scenarios
- Working with vendors to achieve Partner Competences
- Bare metal governance framework
- Monitoring and observability stack

---

## 10. Success Metrics

### Targets

| Category | Metric | Month 6 | Month 12 |
|----------|--------|---------|----------|
| **Cost** | Monthly Azure spend vs. budget | ±10% variance | ±5% variance |
| **Cost** | Reserved instance coverage | 40% | 70% |
| **Cost** | Cloud waste reduction | 10% YoY | 20% YoY |
| **Security** | % workloads meeting compliance baselines | 80% | 95% |
| **Security** | Privileged access via PIM | 100% | 100% |
| **Security** | Mean time to detect security incidents | <4 hours | <1 hour |
| **Security** | Security finding remediation SLA adherence | 80% | 95% |
| **Security** | Patching compliance | 60% | 95% |
| **Security** | Backup compliance | 60% | 95% |
| **Adoption** | % of new deployments via IaC | 50% | 90% |
| **Adoption** | Mean time to provision new environments | <1 week | <1 hour |
| **Adoption** | Number of teams self-serving vs. requiring CCoE intervention | 30% | 70% |
| **Adoption** | Developer satisfaction score (internal survey) | Baseline | +20% |
| **Adoption** | Staff certified (AZ-900+) | 30% | 80% |
| **Bare Metal** | % servers with monitoring | 50% | 100% |

---

## 11. Risks & Mitigations

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| CCoE perceived as "police" | High | High | Lead with enablement, showcase quick wins, measure team satisfaction |
| Lack of executive sponsorship | Medium | Critical | Secure C-level sponsor in Week 1, monthly executive reporting |
| Bare metal resistance to governance | High | Medium | Frame as risk reduction, not bureaucracy; involve bare metal owners in design |
| Skills gap across teams | High | Medium | Training program from Week 11, certification incentives, office hours |
| Cost overruns during build-out | Medium | High | FinOps from Day 1, budget alerts, monthly reviews |
| Tool sprawl | Medium | Medium | Standardise on Azure-native where possible, evaluate before adopting new tools |
| Slow exception process | Medium | High | Define 5-day SLA for RFCs, empower steering committee to delegate |

---

## 12. Immediate Next Steps (This Week)

1. ✅ **Executive sponsorship secured** — Ciaran Barr (CIO)
2. **Draft CCoE charter** — scope, authority, KPIs, team structure *(in progress)*
3. **Run Azure resource graph** — produce estate summary
4. **Schedule CCoE kickoff** — with all potential team members
5. **Identify bare metal inventory owner** — who knows what's on-premises?
6. **Set up cost alerts** — Azure Cost Management on all subscriptions
7. **Identify Application Team Reps** — who will represent app teams on the CCoE?
8. **Define RFC process** — template, SLA, review panel

---

## Appendix A: Azure Policy Quick-Deploy List

Deploy these as a baseline, then customise:

1. `Allowed resource types` — restrict to approved services
2. `Require tags` — costCentre, environment, project, dataClassification
3. `Restrict locations` — UK South (and DR region)
4. `Require NSGs on all subnets` — network segmentation
5. `Disable public endpoints for storage accounts` — data protection
6. `Require encryption at rest` — all storage, databases, disks
7. `Restrict inbound IPs for SSH/RDP` — jump boxes only
8. `Enable Defender for Cloud` — workload protection
9. `Require private endpoints for PaaS` — network isolation
10. `Deny resource deletion without approval` — change control

---

## Appendix B: Bare Metal Inventory Template

```csv
Hostname,IP Address,Location,OS,Owner,Department,Criticality,Purpose,Power (W),
ExpressRoute Circuit,Monitoring Agent Installed,Last Patched,Notes
```

---

## Appendix C: Tool Stack Recommendations

| Function | Tool | Rationale |
|----------|------|-----------|
| IaC | Bicep (Azure), Terraform (AWS), Ansible (bare metal) | Native for Azure, industry standard for AWS |
| CI/CD | GitHub Actions | Cross-platform, native Azure integration |
| Governance | Azure Policy + Blueprints | Native, version-controlled |
| Monitoring | Azure Monitor + Sentinel | Unified platform |
| Cost | Azure Cost Management + DORA | Native, FinOps aligned |
| Secret Mgmt | Azure Key Vault | Native, managed identity integration |
| Documentation | Internal wiki (Confluence/SharePoint) | Team-friendly |
| CMDB | ServiceNow or Azure Arc | Single source of truth |
| Developer Portal | Custom Azure Developer Portal | Self-service catalogue |

---

## Appendix D: Communication & Collaboration

| Channel | Purpose | Frequency |
|---------|---------|-----------|
| Teams channel | Async collaboration, announcements, Q&A | Continuous |
| Internal wiki | Standards, patterns, FAQs, decision log | Updated as needed |
| Monthly newsletter | Changes, wins, upcoming initiatives | Monthly |
| Office hours | Ad-hoc consultations | Weekly, 1-hour slots |
| Executive dashboard | Real-time KPI visibility for leadership | Real-time |

---

## Appendix E: Vendor & Partner Competences

| Provider | Target Competence | Status | Investment Required |
|----------|-------------------|--------|---------------------|
| Microsoft | Cloud Platform | To be assessed | Training + certification costs |
| Microsoft | DevOps | To be assessed | Training + certification costs |
| AWS | Well-Architected | To be assessed | Training + certification costs |

*Note: Partner competences unlock Azure/AWS benefits, support credits, and co-sell opportunities. Assess in Month 3.*
