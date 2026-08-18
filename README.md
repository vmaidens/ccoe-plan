# ccoe-plan

Cloud Center of Excellence (CCoE) — plan, delivery action plan, and build assets for the Capita Azure estate.

## Documents

| File | What it is | Status |
|------|------------|--------|
| [CCoE Charter & Execution Plan.md](CCoE%20Charter%20&%20Execution%20Plan.md) | Charter, governance, decision rights, 24-week roadmap | Sign-off ready |
| [CCoE Build Plan.md](CCoE%20Build%20Plan.md) | Phase-by-phase build plan with quick wins | Approved in principle |
| [CCoE Delivery Action Plan.md](CCoE%20Delivery%20Action%20Plan.md) | Operational action plan: phases, owners, exit criteria, KPIs | **Current working doc** |
| [CCoE_Steering_Deck.md](CCoE_Steering_Deck.md) / [.html](CCoE_Steering_Deck.html) | Steering committee deck (marp) — status + asks | For next steering meeting |

## Build assets

| Path | What it is |
|------|------------|
| [landing-zone/](landing-zone/) | Bicep landing zone: hub-spoke networking, security baseline, cost governance. See its README for deploy steps. |
| [reference-architectures/](reference-architectures/) | RA-01 web app · RA-02 bare-metal lift-and-shift · RA-03 Oracle DB migration (COPII reference path) |
| [playbooks/migration-playbook-template.md](playbooks/migration-playbook-template.md) | Fill-in template: RACI, gates 1–4, cutover runbook, risk register, sign-offs |
| [policies/](policies/) | Policy definitions (Bicep + Terraform), management-group scope — NCSC CSP aligned |

## Related

- COPII Azure Migration Project Plan: `~/Documents/COPII_Azure_Migration_Project_Plan.md` (12-phase, 28–31 weeks)
- CCoE presentation (18 slides): [CCoE_Presentation.html](CCoE_Presentation.html)
