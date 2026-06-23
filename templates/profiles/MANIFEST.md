# Hermes Blueprint — Profile Manifest

Generated: 2026-06-23

## Profile Types

### Industry-Specific Profiles
These are ready to use out of the box for the named industry:

| Profile | Industry | Best For |
|---|---|---|
| `zeus-renovation` | Interior Design & Renovation | Renovation contractors, interior designers, construction PMs |
| `hera-smarthush` | Smart Home Automation | Smart home integrators, AV installers, home network providers |

### Adaptable Profiles ⭐
These use `{{CUSTOMER_*}}` placeholders. Fill in `CUSTOMER_DOMAIN.md` and run `config-apply-template.sh`:

| Profile | Role | Adaptable To | Examples |
|---|---|---|---|
| `zeus-project-manager` | **Execution Engine** — client delivery, quoting, scope, project management | Any service-based project business | Landscaping, construction, event planning, IT services, consulting |
| `hera-business-ops` | **Growth Engine** — strategy, packaging, competitor analysis, business expansion | Any product/service business | Security systems, IT consulting, AV production, managed services |

### General Profiles
No industry-specific content — use as-is:

| Profile | Purpose |
|---|---|
| `hephaestus-assistant` | Cross-domain strategy, investment decisions, tool adoption |
| `aphrodite-relationship` | Relationship, wellness, personal growth |
| `apollo-content` | Content creation, branding, social media |
| `artemis-coder` | Software development, debugging, architecture |
| `athena-researcher` | Deep research, competitive analysis, market reports |
| `poseidon-operations` | Workflows, automation, cron jobs, system maintenance |
| `ares-adversary` | Negotiation prep, objection handling, stress-testing |
| `themis-legal` | Contract audit, PDPA compliance, disputes |
| `hestia-finance` | CPF, IRAS, margin analysis, financial health |

## How to Adapt Zeus or Hera

1. Scaffold the profile:
   ```bash
   ./profile-scaffold.sh --profiles zeus-project-manager
   ```

2. Edit `CUSTOMER_DOMAIN.md` in the scaffolded profile directory

3. Apply the domain configuration:
   ```bash
   ./config-apply-template.sh --profile-dir ~/.hermes/profiles/zeus-project-manager
   ```

4. Verify no remaining placeholders:
   ```bash
   grep -r '{{CUSTOMER_' ~/.hermes/profiles/zeus-project-manager/
   ```

## What Was Removed (Sanitization)

- All API keys and tokens → replaced with `YOUR_*` placeholders
- All email addresses → `[EMAIL_REDACTED]`
- All phone numbers → `[PHONE_REDACTED]`
- All personal names → `[NAME_REDACTED]`
- All personal locations → `[LOCATION_REDACTED]`
- Auth files, state databases, caches → completely excluded
- Private memories (MEMORY.md, USER.md) → completely excluded
- Raw vault content → excluded
- Cron jobs and personal workspace → excluded

## What Was Preserved

- Profile structure and directory layout
- SOUL.md identity and instructions (sanitized of personal references)
- AGENTS.md routing rules and operational protocols
- Vault/wiki knowledge base structure
- Profile naming and skill conventions
- Communication style, response rules, and sales philosophy
