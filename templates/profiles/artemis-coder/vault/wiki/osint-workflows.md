# OSINT Workflows — Artemis Coder

## What This Covers

Open Source Intelligence (OSINT) at Artemis means systematically collecting, analysing, and operationalising publicly available information. This document covers recon methodology, approved data sources, automation scripts, and the ethical boundary lines we never cross.

**Disclaimer:** Artemis OSINT workflows are for legitimate security research, penetration testing (with written authorisation), threat intelligence, and competitive analysis within legal bounds. Nothing in this document authorises unlawful surveillance, stalking, or violation of computer fraud statutes.

## Recon Methodology

All Artemis OSINT engagements follow a five-phase methodology adapted from the intelligence cycle.

### Phase 1 — Scoping & Authorisation
- Define the target: domain(s), IP range(s), organisation name(s), individual(s) with context.
- Verify written authorisation is on file (penetration testing engagement letter, signed scope document).
- Identify out-of-scope assets and program them into automation filters so they are never touched.

### Phase 2 — Passive Reconnaissance
No direct interaction with target infrastructure. All data comes from third-party sources.

**Checklist:**
- [ ] WHOIS lookup (domain registration, registrar, dates, registrant — if not redacted)
- [ ] DNS enumeration: A, AAAA, MX, NS, TXT (SPF/DKIM/DMARC), CNAME, SOA records
- [ ] Certificate Transparency logs (crt.sh) — discover subdomains and internal hostnames
- [ ] Search engine dorking: `site:target.com filetype:pdf`, `intitle:"index of" site:target.com`
- [ ] Wayback Machine (web.archive.org) — historical versions, forgotten endpoints, exposed configs
- [ ] Shodan / Censys — exposed services, open ports, software versions, banners
- [ ] Social media enumeration: LinkedIn (employee roles, tech stack mentions), Twitter/GitHub (employee personal projects that reference company code)
- [ ] Pastebin & dark-web monitoring (via approved paid services only — never browse directly)

### Phase 3 — Active Reconnaissance
Direct interaction with target infrastructure. **Requires explicit authorisation.**

- [ ] Port scanning (`nmap` with timing controls — never `-T5` on production targets)
- [ ] Service version detection on discovered ports
- [ ] Web application crawling (respect `robots.txt` for scope, but note what's disallowed — those are interesting)
- [ ] API endpoint discovery via JavaScript source maps, swagger.json, OpenAPI specs
- [ ] Directory enumeration (rate-limited — max 10 requests/second)

### Phase 4 — Analysis & Correlation
- Map discovered assets to the target's known infrastructure. Flag anomalies.
- Cross-reference technology versions against CVE databases.
- Prioritise findings by exploitability × impact, not by quantity.
- Document every finding with: asset, discovery method, timestamp, screen evidence, risk rating.

### Phase 5 — Reporting & Cleanup
- Deliver findings in a standardised report template (see `vault/wiki/report-template.md`).
- Rate findings: Critical / High / Medium / Low / Informational.
- Include remediation steps for every finding — never just say "fix this."
- Delete all collected data within 30 days of engagement close, unless the client contract specifies otherwise.

## Approved Data Sources

**Always approved (passive, no auth needed):**
- `crt.sh` — Certificate Transparency logs
- `dnsdumpster.com` — DNS recon
- `shodan.io` — Internet-wide scanning data
- `urlscan.io` — URL scanning and screenshot history
- `web.archive.org` — Historical web snapshots
- `haveibeenpwned.com` — Breach data (API for domain-based searches with domain verification)

**Approved with caution (may require accounts or have rate limits):**
- `hunter.io` — Email discovery (requires account, respect GDPR)
- `builtwith.com` / `wappalyzer.com` — Technology stack profiling
- `censys.io` — Like Shodan, different dataset
- `spiderfoot` — Self-hosted OSINT automation (must be configured to respect scope)

**Never use (banned sources):**
- Leaked credential databases from dark-web markets (illegal possession)
- Data obtained via compromised devices or accounts
- Any source that requires bypassing authentication or access controls to reach

## Automation Scripts

Artemis maintains a toolkit of OSINT automation scripts in the `scripts/osint/` directory. All scripts follow these rules:

1. **Rate-limiting is mandatory.** Every script includes a configurable delay between requests. Default: 2 seconds.
2. **User-agent honesty.** Scripts identify themselves with a custom User-Agent string that includes `Artemis-OSINT/1.0` and a contact URL. Never impersonate a browser.
3. **Output is structured.** All scripts output JSON or JSON Lines. Human-readable output is a post-processing step, not the default.
4. **Scope filtering.** Every script accepts a scope file (`--scope targets.txt`) and will not touch anything outside it.

### Key Scripts

| Script | Purpose | Data Source |
|---|---|---|
| `dns-recon.py` | Full DNS enumeration with zone-transfer attempt | Direct DNS queries + crt.sh |
| `subdomain-harvest.py` | Gather subdomains from 12+ sources | crt.sh, DNSdumpster, VirusTotal, AlienVault OTX, URLScan, etc. |
| `tech-profiler.py` | Fingerprint web technology stacks | Wappalyzer data + custom header checks |
| `social-footprint.py` | Map organisation employees and their public tech mentions | LinkedIn, GitHub, Twitter, Stack Overflow |
| `exposure-check.py` | Check for exposed credentials, API keys, and config files | GitHub dorking, Pastebin monitoring, S3 bucket enumeration |

## Ethics & Legal Boundaries

**Hard rules — violation means immediate removal from the engagement:**

1. **Never exceed authorisation.** If the scope says "test subdomain.example.com," do not touch example.com or any other subdomain. No "well, technically it's on the same server" justifications.
2. **Never retain data beyond the engagement.** Client data belongs to the client. Delete all collected information within 30 days of engagement close. Confirm deletion in writing.
3. **Never access, download, or store PII from breaches.** If you encounter a breach dataset during research, stop immediately. Do not search it. Do not browse it. Report its existence to the client's security team.
4. **Never use OSINT for personal purposes.** The toolkit is for authorised engagements only. Running recon on an ex-partner, a competitor without a signed engagement, or a public figure for curiosity is grounds for termination.
5. **Report crimes, don't exploit them.** If you discover evidence of an active intrusion, data exfiltration, or criminal activity, report it to the client's incident response team immediately. Do not investigate further without explicit direction.
6. **Know the law.** Computer Misuse Act (SG), CFAA (US), GDPR (EU), PDPA (SG). Ignorance is not a defence. When operating across jurisdictions, consult legal counsel before touching any infrastructure in that jurisdiction.

**When in doubt:** Ask the engagement lead before acting. No piece of intelligence is worth your reputation, your career, or a criminal charge.

## Revision History
- 2026-06-10 — Initial publication
