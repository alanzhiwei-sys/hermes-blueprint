# Package Pricing Matrix

## Purpose
Standardised pricing framework for all [YOUR_BUSINESS_ALT] packages. Ensures consistent margin targets, transparent hardware vs. labour breakdown, and easy tier comparison for client proposals.

---

## Package Tiers

### Tier 1: [YOUR_BUSINESS_ALT] — Starter Hub
**Target Client**: New BTO homeowners, first-time smart home users, budget-conscious

**Scope**:
- Home Assistant hub (Raspberry Pi 5 / Home Assistant Green)
- Zigbee coordinator (SONOFF USB dongle)
- 3× smart light switches (Aqara D1, no-neutral)
- 2× motion sensors (Aqara P1)
- 1× temperature/humidity sensor (Aqara T1)
- 1× smart door sensor (Aqara)
- 1× voice control bridge (HomeKit or Google Home — setup only, device by client)
- Basic automations: motion-activated lights, schedule-based scenes
- Orientation + user guide (1 hour)

**Hardware Cost**: ~$350–$450
**Labour**: ~$200–$300 (installation + configuration, ~4–6 hours)
**Total Cost**: ~$550–$750
**Package Price**: $1,200–$1,500
**Margin Target**: 42–50%

**Suggested Client Pitch**: *"Entry-level smart home that handles the basics — lights that turn on when you walk in, and off when you leave. All local, no cloud dependency, no monthly fees."*

---

### Tier 2: [YOUR_BUSINESS_ALT] — Essential Living
**Target Client**: Young families, tech enthusiasts, 3–4 room HDB / small condo

**Scope**: Everything in Starter Hub, plus:
- 5× additional smart switches (total 8 zones)
- 2× additional motion sensors (total 4)
- 1× smart curtain/blind motorisation for living room (Aqara E1 or SwitchBot)
- 1× smart door lock (Aqara U200 or Yale Linus — Z-Wave preferred)
- 1× smart smoke detector (Z-Wave — First Alert ZCOMBO or similar)
- 1× video doorbell (Reolink PoE or Aqara G4)
- VLAN IoT network setup (requires managed switch; client provides router)
- Advanced automations: presence-based scenes, away mode, morning/evening routines
- 1-year remote support (email/WhatsApp)

**Hardware Cost**: ~$1,200–$1,600
**Labour**: ~$500–$700 (installation + configuration, ~12–16 hours)
**Total Cost**: ~$1,700–$2,300
**Package Price**: $3,500–$4,200
**Margin Target**: 45–55%

**Suggested Client Pitch**: *"Full-home smart living. Lights, curtains, door lock, and safety sensors — all unified under one app. Your home knows when you're home, and when you're not."*

---

### Tier 3: [YOUR_BUSINESS_ALT] — Premium Command
**Target Client**: Condo owners, landed property, smart home enthusiasts, security-conscious

**Scope**: Everything in Essential Living, plus:
- 10+ additional smart switches (total 18+ zones)
- Motorised blinds for all windows (up to 6 motors)
- 2× smart thermostats / AC controllers (Sensibo Air / Aqara AC companion)
- PoE security camera system (4× UniFi / Reolink cameras + NVR)
- Door/window sensors on all entry points (6–8 sensors)
- Flood sensors in kitchen + bathrooms (3× Aqara / Z-Wave)
- Full Ubiquiti UniFi network stack: Dream Machine, PoE switch, 2× access points
- Dedicated IoT VLAN with firewall rules
- NAS integration (Synology — client provides; [YOUR_BUSINESS_ALT] configures)
- Home Assistant Dashboard: custom tablet-mounted control panel
- Scene keypads: physical scene controllers (Aqara S1E / Zooz ZEN32)
- 2-year support with annual on-site health check

**Hardware Cost**: ~$4,000–$6,000
**Labour**: ~$1,500–$2,500 (installation + configuration, ~30–45 hours)
**Total Cost**: ~$5,500–$8,500
**Package Price**: $11,000–$15,000
**Margin Target**: 43–50%

**Suggested Client Pitch**: *"Your home as a command centre. Enterprise-grade networking, security, and automation — managed and maintained. Walk in and the house responds to you."*

---

### Tier 4: [YOUR_BUSINESS_ALT] — Bespoke (Custom)
For projects exceeding Premium Command scope: full landed properties, multi-floor automation, KNX integration, legacy system bridge, dedicated home cinema automation, Lutron lighting systems, etc.

**Pricing Formula**: (Hardware cost + Labour cost) × 1.35–1.55 margin multiplier based on complexity
**Minimum Project**: $18,000+

---

## Hardware Cost Benchmarks (2026 — SGD)

| Device | Model | Unit Cost | Notes |
|--------|-------|-----------|-------|
| Smart Switch (no neutral) | Aqara D1 | $25–$30 | Zigbee; single rocker |
| Smart Switch (with neutral) | Aqara Z1 Pro | $35–$45 | Zigbee; requires neutral wire |
| Motion Sensor | Aqara P1 | $20–$25 | Zigbee; 5-year battery |
| Door/Window Sensor | Aqara | $15–$20 | Zigbee |
| Temp/Humidity Sensor | Aqara T1 | $18–$22 | Zigbee |
| Smoke Detector | First Alert ZCOMBO | $60–$80 | Z-Wave |
| Flood Sensor | Aqara | $25–$30 | Zigbee |
| Smart Lock | Aqara U200 | $250–$350 | Zigbee + HomeKit |
| Curtain Motor | Aqara E1 | $80–$110 | Zigbee; per motor |
| Video Doorbell | Reolink PoE | $120–$180 | PoE, local NVR |
| Zigbee Coordinator | SONOFF Dongle Plus | $30–$40 | CC2652P chipset |
| Z-Wave Controller | Zooz ZST39 | $50–$60 | 700 series |
| Home Assistant Green | HA Green | $130–$160 | Pre-installed HA |
| Raspberry Pi 5 (8GB) | RPi5 | $100–$120 | + case + PSU + SSD |
| PoE Camera (4K) | Reolink RLC-811A | $130–$180 | PoE |
| NVR | Reolink RLN8-410 | $200–$280 | 8-channel, HDD included |
| UniFi Dream Router | UDR | $280–$350 | Router + AP + controller |
| UniFi Switch Lite 8 PoE | USW-Lite-8-PoE | $150–$180 | Managed PoE switch |
| UniFi AP (Wi-Fi 6) | U6 Lite | $160–$200 | Ceiling mount |

---

## Labour Rates

| Activity | Rate | Notes |
|----------|------|-------|
| Home Assistant Setup & Config | $60–$80/hr | Includes HAOS install, add-ons, integrations, dashboard |
| Device Installation (physical) | $40–$60/hr | Switch replacement, sensor mounting, cable run |
| Network Setup | $80–$100/hr | UniFi config, VLANs, firewall rules, AP placement |
| Automation Programming | $60–$80/hr | Node-RED / HA automations, scene logic |
| Client Orientation | $60/hr | Walkthrough + user guide |
| On-Site Health Check (annual) | $150–$250 flat | All devices tested, firmware updates, HA backup verified |

---

## Margin Rules
- **Hardware**: Mark up 25–35% above wholesale/street price (covers sourcing, pre-config, warranty handling)
- **Labour**: Bill at rates above — margin is embedded in hourly rate (already above direct cost)
- **Blended target**: 45–55% across hardware + labour per project
- **Floor**: Never below 35% blended margin (walk away — project not worth [YOUR_BUSINESS_ALT] brand)
- **Discounting**: Offer 5–10% discount only for bundled networking + automation packages (upgrade incentive)

---

## Proposal Format (Client-Ready, One Page)

```
━━━ SMART HUSH PACKAGE PROPOSAL ━━━

Client: [Name]
Property: [Type / Rooms]
Package: [YOUR_BUSINESS_ALT] — [Tier Name]
Proposed: [Date] | Valid: 30 days

HARDWARE SUMMARY
• Smart switches: [qty] × Aqara [model] – $[total]
• Sensors: [qty] motion + [qty] door + [qty] temp – $[total]
• Security: smart lock, doorbell, cameras – $[total]
• Hub & network: Home Assistant hub + Zigbee/Z-Wave – $[total]
• Other: [curtain motors / blinds / scene keypads] – $[total]
━━ Hardware Subtotal: $[X,XXX]

SERVICES
• Home Assistant configuration & automation programming – $[X,XXX]
• Device installation – $[X,XXX]
• Network setup & IoT VLAN – $[X,XXX]
• Client orientation & user guide – $[XXX]
━━ Services Subtotal: $[X,XXX]

PACKAGE TOTAL: $[X,XXX]

WHAT'S INCLUDED
✅ All hardware listed above
✅ Full installation & configuration
✅ [1/2] year remote support
✅ [Annual health check] (Premium tier)
✅ User guide & orientation session

WHAT'S NOT INCLUDED
❌ Home Wi-Fi router (unless UniFi stack included in package)
❌ Client mobile devices / tablets
❌ NAS storage drives
❌ Third-party subscription fees
❌ Structural modifications (false ceiling access for cable runs — coordinate with renovation contractor)

PAYMENT SCHEDULE
• 40% upon package confirmation (hardware procurement)
• 40% upon installation completion
• 20% upon final sign-off & handover

TIMELINE
• Hardware procurement: 1–2 weeks
• Installation: 1–3 days (dependent on package)
• Configuration & testing: 3–7 days
• Handover & orientation: 1 session (2 hours)
```
