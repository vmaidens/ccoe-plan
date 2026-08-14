# Cloud Center of Excellence (CCoE) — Build Plan

> **Context:** Large Azure estate, smaller AWS footprint, significant bare metal infrastructure.
> **Goal:** Build a CCoE from scratch with achievable milestones and quick wins.
> **Author:** Vince Maidens
> **Date:** 2026-08-14

---

## Executive Summary

A CCoE is not a gatekeeping body — it's an **enabler** that accelerates cloud adoption while reducing risk and cost. This plan is structured in **4 phases over 24 weeks**, with quick wins in the first 30 days to build credibility and momentum.

### Core Principles
1. **Enable, don't block** — self-service by default, guardrails not gates
2. **Measure everything** — FinOps, security posture, adoption velocity
3. **Start small, scale fast** — pilot, prove, then expand
4. **Hybrid-aware** — bare metal is not an afterthought; it's a first-class citizen

---

## Phase 0: Foundation (Weeks 1-4) — "See Everything, Win Fast"

*Objective: Establish the CCoE, gain visibility, deliver quick wins to prove value.*

### 1.1 CCoE Team Structure & Charter

| Role | Count | Responsibility |
|------|-------|----------------|
| CCoE Lead (you) | 1 | Strategy, executive reporting, stakeholder management |
| Cloud Architect | 1-2 | Azure/AWS architecture standards, design reviews |
| FinOps Analyst | 1 | Cost visibility, optimisation, reporting |
| Security & Compliance Lead | 1 | NCSC CSP alignment, IAM, policy enforcement |
| Platform/DevOps Engineer | 1-2 | Landing zones, IaC, automation, bare metal |
| Developer Advocate | 1 (can be part-time) | Training, documentation, internal evangelism |

**Charter document** must define:
- Scope (Azure primary, AWS, bare metal, future clouds?)
- Authority level (advisory → mandatory)
- KPIs (see Section 6)
- Reporting cadence (weekly internal, monthly executive)

**Quick Win #1:** Draft and socialise the CCoE charter with executive sponsor in Week 1-2. Get sign-off by Week 3.

### 1.2 Estate Discovery & Inventory

Before governing anything, you need to know what exists.

**Azure:**
- Run `az graph query` across all subscriptions for a full resource inventory
- Export resource graph to CSV/Log Analytics workspace
- Identify: resource groups, managed identities, RBAC assignments, policy assignments, cost centres
- Map business units to subscriptions/resource groups
- Document: networking topology (VNets, ExpressRoute, VPN, Front Door)
- Identify: orphaned/unused resources, untagged resources, public IPs

**AWS:**
- Use AWS Config + Resource Groups Tag Editor for inventory
- Export account structure, IAM users/roles, regions in use
- Map to Azure equivalents for unified view

**Bare Metal:**
- Physical asset inventory (servers, switches, storage)
- OS versions, patch levels, virtualisation layer (VMware/KVM/proxmox)
- Network topology and connectivity to cloud (ExpressRoute/Direct Connect)
- BMC/IPMI access documentation
- Power/cooling capacity in data centres

**Quick Win #2:** Produce a **single-page estate summary** within 2 weeks — total resources, subscriptions, cost by BU, top 5 risk items. This becomes your first executive update.

### 1.3 Quick Wins (First 30 Days)

| # | Action | Effort | Impact |
|---|--------|--------|--------|
| 1 | Tag compliance report + auto-tag policy | 1 day | Visibility |
| 2 | Identify and rightsize idle VMs (Azure Cost Management) | 2 days | Immediate cost savings |
| 3 | Enable Azure Policy baseline (NCSC CSP aligned) | 1 day | Security posture |
| 4 | Publish first "Cloud Playbook" — how to deploy a web app | 2 days | Developer enablement |
| 5 | Set up cost alerts at subscription level | 1 day | Cost governance |
| 6 | Document bare metal → Azure connectivity options | 2 days | Hybrid foundation |

---

## Phase 1: Guardrails & Governance (Weeks 5-10) — "Safe Self-Service"

*Objective: Establish the guardrails that make self-service safe.*

### 2.1 Azure Landing Zone (Management Group Architecture)

```
Management Group: CCoE (root)
├── Management Group: Landing-Zone (policy + blueprint)
│   ├── Subscription: Identity (Azure AD Connect, Entra ID)
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

**Key decisions:**
- Use **Azure Blueprints** for repeatable, version-controlled landing zone deployment
- Policy as code using **Bicep/ARM** — version controlled in Git
- Management group hierarchy aligned to **business units, not technology**
- Separate subscriptions for **cost isolation** and **blast radius control**

### 2.2 Azure Policy & Initiatives (NCSC CSP Aligned)

Deploy these policy initiatives immediately:

| Initiative | Key Policies | NCSC CSP Ref |
|------------|-------------|---------------|
| **Security Baseline** | Enforce encryption at rest, disable public endpoints, require NSGs, MFA for privileged roles | CSP 4.x |
| **Tagging & Cost** | Require cost centre tags, environment tags, project tags | CSP 1.x (governance) |
| **Networking** | Restrict subnets, enforce private endpoints, require DNS | CSP 3.x |
| **Data Protection** | DLP policies, sensitivity labels, retention policies | CSP 5.x |
| **Bare Metal** | (Separate policy set — see Section 2.5) | — |

### 2.3 Identity & Access Management

**Azure:**
- Implement **Privileged Identity Management (PIM)** for just-in-time access
- Enforce **Entra ID Conditional Access** policies
- Migrate from service accounts to **Managed Identities** where possible
- Document and enforce **RBAC model** (built-in roles → custom roles → avoid Contributor/Owner)
- Set up **Azure AD Identity Protection** for anomaly detection

**AWS:**
- Align with Azure IAM model using **IAM Access Analyzer**
- Cross-account role trust relationships where Azure needs AWS access
- **Consolidate AWS accounts** — reduce sprawl

**Quick Win #3:** Implement PIM and Conditional Access baseline in Weeks 5-6. This is a massive security improvement with zero developer friction.

### 2.4 Networking Foundation

| Component | Azure | AWS | Bare Metal |
|-----------|-------|-----|------------|
| Hub | Virtual WAN or hub-and-spoke VNets | Transit Gateway | — |
| Connectivity | ExpressRoute (primary), VPN (DR) | Direct Connect | ExpressRoute/Direct Connect peers |
| DNS | Azure Private DNS | Route 53 private zones | Internal DNS servers (synced) |
| Firewall | Azure Firewall Manager | Network Firewall | Hardware firewalls (document) |
| Private Endpoints | Enable for PaaS services | VPC Endpoints | — |

**Bare metal networking:**
- Document all cross-connects to Azure ExpressRoute and AWS Direct Connect
- Plan for **ExpressRoute Global Reach** if multiple ExpressRoute circuits
- Implement **Azure Firewall** as central egress for on-premises workloads
- DNS: Consider **Azure Private DNS Zones** replicating to on-premises via conditional forwarders

### 2.5 Bare Metal Governance Framework

Bare metal is not "legacy" — it's infrastructure that needs the same governance.

**Bare Metal Policy Set:**
- **Asset registry** — every server must be registered in CMDB with owner, location, purpose
- **Patch management** — baseline OS patch levels, SLA for critical patches (e.g., within 14 days)
- **Monitoring** — must integrate with central monitoring (Log Analytics workspace or equivalent)
- **Access control** — no shared accounts, SSH key management, BMC access logging
- **Capacity planning** — quarterly reviews of compute/storage/power/cooling
- **Decommission process** — documented procedure for retiring bare metal (data sanitisation, asset disposal)

**Quick Win #4:** Produce a **bare metal risk register** in Weeks 7-8. Identify the top 10 highest-risk servers (unpatched, no monitoring, no documented owner) and remediate them.

---

## Phase 2: Enablement & Automation (Weeks 11-16) — "Accelerate Adoption"

*Objective: Make it easy for teams to do the right thing.*

### 3.1 Infrastructure as Code (IaC) Standards

| Layer | Tool | Repository |
|-------|------|------------|
| Azure | Bicep (preferred) / ARM | Git repo with PR reviews |
| AWS | Terraform (preferred) | Git repo with PR reviews |
| Bare Metal | Ansible / Packer | Git repo with PR reviews |
| Policy | Azure Policy definitions (Bicep) | Same repo as IaC |
| Pipelines | GitHub Actions / Azure DevOps | — |

**IaC standards:**
- All infrastructure provisioned through code — no portal clicks in production
- Template library: pre-approved patterns for common workloads (web app, API, database, AKS cluster)
- **Pull request reviews** required for all infrastructure changes
- **State management**: Terraform state in remote backends, Bicep parameterised deployments
- **Drift detection**: weekly scans for unmanaged resources

### 3.2 Service Catalog & Self-Service Portal

Build a **self-service catalogue** of approved patterns. Teams request, not build from scratch.

**Catalogue items (initial):**
1. "Deploy a web application" (App Service + SQL DB + WAF)
2. "Deploy a containerised workload" (AKS + ACR + Application Gateway)
3. "Set up a dev/test environment" (sandbox subscription, limited resources)
4. "Create a data pipeline" (Data Factory + Synapse/Databricks)
5. "Connect on-premises to cloud" (ExpressRoute + private endpoints)

**Implementation options:**
- **Azure Developer Portal** (custom) — simplest to build
- **Service Catalog + Azure Resource Graph** — low-code approach
- **Backstage.io** (open-source developer portal) — enterprise-grade

### 3.3 CI/CD Standards

**Azure-native:**
- GitHub Actions or Azure DevOps for CI/CD pipelines
- Template pipelines for common patterns (web app, AKS, ARM/Bicep deployment)
- **Environments** with approval gates for production deployments
- **Deployments** via IaC — never manual portal changes

**Cross-cloud:**
- Standardise on GitHub Actions where possible (works for Azure, AWS, and bare metal via runners)
- Self-hosted runners for bare metal deployments
- Pipeline templates version-controlled in Git

### 3.4 Monitoring & Observability

**Centralised monitoring stack:**

| Component | Azure | AWS | Bare Metal |
|-----------|-------|-----|------------|
| Logs | Log Analytics Workspace | CloudWatch Logs | Log Analytics agent / Vector |
| Metrics | Azure Monitor | CloudWatch | Telegraf → Log Analytics |
| Traces | Application Insights | X-Ray | OpenTelemetry → App Insights |
| Alerts | Action Groups + Runbooks | SNS + Lambda | PagerDuty/OpsGenie integration |
| Dashboards | Azure Workbooks | CloudWatch Dashboards | Grafana (unified) |
| SIEM | Microsoft Sentinel | GuardDuty | Sentinel (ingest all) |

**Key principle:** One Log Analytics workspace per environment (dev/test/prod), with a **central management workspace** for cross-cloud/cross-environment dashboards.

**Bare metal monitoring:**
- Deploy **Azure Monitor Agent (AMA)** or **Telegraf** on all bare metal servers
- Centralise logs in Log Analytics
- Set up alerting for: CPU > 80% for 5 min, disk > 90%, memory > 90%, service down
- Integrate with existing incident management (ServiceNow, PagerDuty)

### 3.5 Training & Developer Enablement

| Audience | Curriculum | Format |
|----------|-----------|--------|
| Developers (all) | Azure fundamentals, IaC basics, security hygiene | 2-hour workshop + self-paced |
| Architects | Advanced Azure/AWS, hybrid patterns, cost optimisation | Quarterly deep-dive |
| Ops/Engineering | Monitoring, incident response, automation | Hands-on labs |
| Management | FinOps, cloud governance, risk reporting | Executive briefings |

**Certification targets:**
- Azure Fundamentals (AZ-900): 80% of technical staff within 6 months
- Azure Administrator (AZ-104): 50% of technical staff within 6 months
- Azure Solutions Architect (AZ-305): All architects within 6 months
- AWS equivalent for AWS-facing roles

**Quick Win #5:** Run a **"Cloud 101" workshop** in Weeks 11-12. 2 hours, hands-on, free sandbox. This builds immediate goodwill and demonstrates CCoE value.

---

## Phase 3: Optimisation & Scale (Weeks 17-24) — "Continuous Improvement"

*Objective: Shift from building to optimising — FinOps maturity, security hardening, innovation.*

### 4.1 FinOps Maturity

**Month 1-2 (Weeks 17-20):**
- Implement **cost allocation tags** — enforce across all subscriptions
- Set up **budget alerts** at subscription, resource group, and workload level
- Weekly cost review meetings with workload owners
- Identify top 20 cost drivers and present optimisation opportunities

**Month 3-4 (Weeks 21-24):**
- Implement **reserved instance / savings plan strategy** for Azure (1-year and 3-year)
- Rightsize VMs using **Azure Advisor** recommendations
- Implement **auto-shutdown** for dev/test environments
- Publish **cost-per-workload** dashboard for each business unit
- Establish **FinOps working group** with finance partners

**Bare metal cost allocation:**
- Allocate bare metal costs to business units via chargeback/showback model
- Track power/cooling as separate line item
- Compare bare metal TCO vs. cloud equivalent for active workloads

### 4.2 Security Hardening

| Area | Action | Timeline |
|------|--------|----------|
| Zero Trust | Implement Zero Trust architecture principles | Weeks 17-20 |
| Workload Protection | Deploy Microsoft Defender for Cloud (all subscriptions) | Weeks 17-18 |
| Vulnerability Management | Container scanning, VM vulnerability assessment | Weeks 18-20 |
| Secret Management | Azure Key Vault migration — eliminate hardcoded secrets | Weeks 19-22 |
| Compliance | Automated compliance reporting (NCSC CSP, ISO 27001) | Weeks 20-24 |
| Incident Response | Runbook development, tabletop exercises | Weeks 21-24 |

### 4.3 Bare Metal Modernisation Roadmap

| Wave | Timeline | Focus |
|------|----------|-------|
| Wave 1 | Weeks 17-20 | Monitoring, patching, access control (stabilise) |
| Wave 2 | Weeks 21-24 | Automation (Ansible), configuration management |
| Wave 3 | Months 7-9 | Workload migration assessment (lift-and-shift vs. refactor vs. retire) |
| Wave 4 | Months 9-12 | Execute migrations based on Wave 3 assessment |

**Assessment criteria for bare metal workloads:**
- Business criticality (P1-P4)
- Technical complexity (dependencies, OS version, custom configs)
- Cost (bare metal TCO vs. cloud equivalent)
- Risk (compliance requirements, data sensitivity)

### 4.4 Governance Maturity

Move from **reactive** to **proactive** governance:

| Maturity | Description | Target |
|----------|-------------|--------|
| Level 1 — Reactive | Issues found in audits, cost overruns discovered after | Current state |
| Level 2 — Defined | Policies documented, enforced via Azure Policy | Weeks 10 |
| Level 3 — Measured | KPIs tracked, cost/security reports automated | Weeks 16 |
| Level 4 — Proactive | Predictive cost modelling, automated remediation | Weeks 24 |
| Level 5 — Optimising | Continuous improvement, innovation-focused | Ongoing |

---

## Phase 4: Continuous Improvement (Month 7+) — "The Flywheel"

*Objective: CCoE becomes self-sustaining, focused on innovation and optimisation.*

### 5.1 Ongoing CCoE Rhythm

| Cadence | Activity | Attendees |
|---------|----------|-----------|
| Weekly | CCoE internal standup (30 min) | CCoE team |
| Weekly | Cost review with workload owners | CCoE + finance |
| Bi-weekly | Architecture review board | CCoE + architects |
| Monthly | Executive CCoE report | CCoE + CIO/CTO |
| Quarterly | CCoE retrospective + roadmap update | CCoE + all stakeholders |
| Quarterly | Cloud skills assessment + training plan | CCoE + HR |

### 5.2 Innovation Pipeline

Once foundations are solid, the CCoE shifts focus to:
- **Serverless evaluation** — identify workloads suited for Functions/Logic Apps
- **AI/ML enablement** — Azure AI services, OpenAI integration, responsible AI framework
- **Platform engineering** — internal developer platform (IDP) maturity
- **Multi-cloud patterns** — when and how to leverage AWS alongside Azure
- **Green cloud** — carbon-aware computing, rightsize for sustainability

### 5.3 CCoE Evolution

| Phase | Focus | CCoE Size |
|-------|-------|-----------|
| Phase 1 (Months 1-3) | Foundation + guardrails | 5-6 FTEs |
| Phase 2 (Months 4-6) | Enablement + automation | 6-8 FTEs |
| Phase 3 (Months 7-12) | Optimisation + innovation | 4-6 FTEs (some roles decentralise) |
| Phase 4 (Year 2+) | Platform engineering + evolution | 3-5 FTEs (embedded in teams) |

---

## KPIs & Success Metrics

| Category | Metric | Target (Month 6) | Target (Month 12) |
|----------|--------|-------------------|-------------------|
| **Cost** | Monthly Azure spend vs. budget | ±10% variance | ±5% variance |
| **Cost** | Reserved instance coverage | 40% | 70% |
| **Cost** | Idle resource savings identified | £X,000/month | £Y,000/month |
| **Security** | % resources compliant with Azure Policy | 80% | 95% |
| **Security** | Privileged access via PIM | 100% | 100% |
| **Security** | Mean time to detect security incidents | <4 hours | <1 hour |
| **Adoption** | % of new deployments via IaC | 50% | 90% |
| **Adoption** | Time to provision sandbox environment | <1 week | <1 hour |
| **Adoption** | Staff certified (AZ-900+) | 30% | 80% |
| **Governance** | % resources with required tags | 70% | 95% |
| **Bare Metal** | % servers with monitoring | 50% | 100% |
| **Bare Metal** | Critical patch compliance | 60% | 95% |

---

## Risks & Mitigations

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| CCoE perceived as "police" | High | High | Lead with enablement, showcase quick wins, measure team satisfaction |
| Lack of executive sponsorship | Medium | Critical | Secure C-level sponsor in Week 1, monthly executive reporting |
| Bare metal resistance to governance | High | Medium | Frame as risk reduction, not bureaucracy; involve bare metal owners in design |
| Skills gap across teams | High | Medium | Training program from Week 11, certification incentives, office hours |
| Cost overruns during build-out | Medium | High | FinOps from Day 1, budget alerts, monthly reviews |
| Tool sprawl | Medium | Medium | Standardise on Azure-native where possible, evaluate before adopting new tools |

---

## Immediate Next Steps (This Week)

1. **Secure executive sponsor** — confirm C-level champion (CIO/CTO)
2. **Draft CCoE charter** — scope, authority, KPIs, team structure
3. **Run Azure resource graph query** — produce estate summary
4. **Schedule CCoE kickoff meeting** — with all potential team members
5. **Identify bare metal inventory owner** — who knows what's running on-premises?
6. **Set up cost alerts** — Azure Cost Management budget alerts on all subscriptions

---

## Appendix A: Tool Stack Recommendations

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

## Appendix B: Bare Metal Inventory Template

```csv
Hostname,IP Address,Location,OS,Owner,Department,Criticality,Purpose,Power (W),
ExpressRoute Circuit,Monitoring Agent Installed,Last Patched,Notes
```

## Appendix C: Azure Policy Quick-Deploy List

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
