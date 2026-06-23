# Tech Stack Decisions

## Purpose
Engineering rationale for every technology choice in the [YOUR_BUSINESS_ALT] architecture. Use this as the reference when [NAME_REDACTED] or clients ask "why this, not that?" — every decision is defensible and documented.

---

## Platform: Home Assistant vs Hubitat

### Decision: Home Assistant (Primary) | Hubitat (Alternative)

| Factor | Home Assistant | Hubitat | Winner |
|--------|---------------|---------|--------|
| Device integrations | 2,500+ (official + community) | ~200–300 | **HA** |
| Local control | Yes — all local by default | Yes — all local by default | Tie |
| Flexibility | Unlimited — YAML, Python, Node-RED, custom components | Limited — Groovy-based, fewer customisation paths | **HA** |
| UI/Dashboard | Lovelace — fully customisable, tablet-optimised | Basic dashboards — functional but dated | **HA** |
| Community | Massive, active, fast updates | Smaller, slower development | **HA** |
| Learning curve | Steep (rewarding) | Moderate (constrained) | **Hubitat** |
| Maintenance | Active (monthly updates, breaking changes possible) | Lower (appliance-like, fewer updates) | **Hubitat** |
| Backup & restore | Full snapshot, Google Drive backup add-on | Cloud backup included | **HA** |
| Voice assistant bridge | HomeKit, Google, Alexa (Nabu Casa or manual) | HomeKit, Google, Alexa (built-in) | Tie |

**[YOUR_BUSINESS_ALT] Recommendation**: Home Assistant is the default platform. It offers the broadest device support, the most flexible automation engine, and a professional dashboard that matches the premium [YOUR_BUSINESS_ALT] brand. Hubitat is offered only when the client explicitly wants a lower-maintenance, appliance-like experience and is willing to accept reduced flexibility.

**Home Assistant Installation Method**:
- **Home Assistant OS (HAOS)** — recommended for all [YOUR_BUSINESS_ALT] installs. Full OS with supervisor, add-on store, managed updates.
- **Home Assistant Container** — only for clients with existing Docker infrastructure (NAS, homelab). Requires separate management of add-ons.
- **Home Assistant Supervised** — not recommended. Maintenance burden, frequent breaking changes, no [YOUR_BUSINESS_ALT] support commitment.

---

## Local Control vs Cloud Dependence

### Decision: Local-First Architecture

**Policy**: Every [YOUR_BUSINESS_ALT] device and automation must function without internet connectivity. Internet-dependent features (remote access, voice assistants, weather data) are additive — never foundational.

**Why Local-First**:
- **Reliability**: Internet outages in Singapore are rare but do happen. A smart home that stops working when the internet drops is a dumb home.
- **Latency**: Local Zigbee/Z-Wave → MQTT → Home Assistant → action = <100ms. Cloud API round-trip = 500ms–2s. Noticeable with motion-triggered lights.
- **Privacy**: No device telemetry leaving the home. No third-party server storing when you're home, when doors open, or camera feeds.
- **Longevity**: Cloud services shut down. Tuya could deprecate an API. Aqara could change cloud terms. Local devices work as long as the hardware survives.
- **[YOUR_BUSINESS_ALT] Value Proposition**: We sell independence. Competitors (Koble, Automate Asia) often rely on cloud platforms. Our USP: "Your house works even if the internet doesn't."

**Device Selection Rule**:
- ✅ Zigbee device paired via Zigbee2MQTT → local
- ✅ Z-Wave device paired via Z-Wave JS → local
- ✅ ESPHome-flashed Wi-Fi device → local
- ✅ PoE camera → local NVR → local
- ❌ Stock Tuya Wi-Fi device → cloud (avoid)
- ❌ Cloud-only smart lock → avoid (or bridge locally)
- ⚠️ Voice assistant → cloud-dependent BUT optional layer; core automations don't need it

**Remote Access (The Exception)**:
- Nabu Casa subscription ($6.50 USD/month) — official HA remote access, supports development, encrypted
- Alternative: Tailscale/WireGuard VPN — free, more technical, client must install VPN app
- Recommendation: Nabu Casa for client convenience; Tailscale for technical clients wanting zero ongoing cost

---

## Network Architecture: VLAN Strategy

### Decision: Segmented VLAN Design

[YOUR_BUSINESS_ALT] installs a minimum 3-VLAN topology on managed network gear.

| VLAN | Name | Subnet | Purpose | Devices |
|------|------|--------|---------|---------|
| VLAN 1 | Main LAN | 192.168.1.0/24 | Trusted devices | Phones, laptops, tablets, NAS, printer |
| VLAN 20 | IoT | 192.168.20.0/24 | Smart devices | Home Assistant, Zigbee coordinator, Z-Wave stick, all smart devices via HA |
| VLAN 30 | Guest | 192.168.30.0/24 | Visitors | Guest Wi-Fi, client isolation enabled |

**Firewall Rules (UniFi / OPNsense)**:
```
Main LAN → IoT: ALLOW (for HA dashboard access from phones/laptops)
IoT → Main LAN: BLOCK (smart devices cannot initiate connections to trusted network)
IoT → WAN: ALLOW (for Nabu Casa remote access, voice assistants, firmware updates)
Guest → Main LAN: BLOCK
Guest → IoT: BLOCK
Guest → WAN: ALLOW (internet only)
WAN → IoT: BLOCK (no inbound from internet except Nabu Casa tunnel)
```

**Why VLAN Segmentation**:
- **Security**: A compromised cheap Tuya sensor can't scan your laptop. IoT devices are among the least-secure networked devices — they belong in isolation.
- **Performance**: IoT broadcast traffic stays in VLAN 20, doesn't congest Main LAN.
- **Professionalism**: This is what separates [YOUR_BUSINESS_ALT] from a "buy a few smart bulbs and pair them" install. Network architecture is infrastructure.

---

## Zigbee Channel Planning

### The 2.4 GHz Congestion Problem
Zigbee shares the 2.4 GHz band with Wi-Fi. In HDB/condo environments with dense Wi-Fi from neighbours, channel overlap causes Zigbee mesh instability.

**Channel Map**:
```
Wi-Fi Channel 1  → 2401–2423 MHz (overlaps Zigbee 11–14)
Wi-Fi Channel 6  → 2426–2448 MHz (overlaps Zigbee 16–19)
Wi-Fi Channel 11 → 2451–2473 MHz (overlaps Zigbee 21–23)
```

**[YOUR_BUSINESS_ALT] Zigbee Channel Strategy**:
1. Survey the 2.4 GHz environment with a Wi-Fi analyser before install
2. Set 2.4 GHz Wi-Fi to Channel 1 or 6 (whichever is least congested)
3. Select Zigbee channel from the opposite band:
   - Wi-Fi on Ch 1 → Zigbee on Ch 20, 24, 25, or 26
   - Wi-Fi on Ch 6 → Zigbee on Ch 11, 24, 25, or 26
   - Wi-Fi on Ch 11 → Zigbee on Ch 11, 15, or 24
4. Recommended default: **Zigbee Channel 25** (2475–2480 MHz, least Wi-Fi overlap)
5. Avoid Zigbee channels 15, 20, 25 if using Wi-Fi Channel 11+6 simultaneously

**Z-Wave Advantage**: Operates at 868.42 MHz — completely separate from 2.4 GHz. Zero congestion risk. This is why critical devices (locks, smoke detectors) should use Z-Wave.

---

## MQTT: The Backbone

### Decision: Mosquitto MQTT Broker on Home Assistant

**Why MQTT**:
- Lightweight pub/sub protocol — the universal language of IoT
- Zigbee2MQTT publishes all Zigbee device states to MQTT; HA subscribes
- Z-Wave JS UI can publish to MQTT
- ESPHome devices communicate via MQTT (or native API)
- Enables cross-platform: a Node-RED flow can subscribe to MQTT topics independently of HA

**Setup**:
- Mosquitto broker add-on (Home Assistant)
- Zigbee2MQTT add-on configured to use `mqtt://core-mosquitto:1883`
- All MQTT authenticated (username/password — not anonymous)

---

## Cameras: PoE vs Wi-Fi

### Decision: PoE Only (No Wi-Fi Cameras)

**Why PoE**:
- **Reliability**: No Wi-Fi congestion, no disconnections, no interference
- **Security**: Wi-Fi cameras are trivially jammed with a $20 deauth tool. PoE cameras require physical access to cut.
- **Power**: Single cable for data + power. UPS on the PoE switch = cameras survive power flickers.
- **Bandwidth**: 4K cameras at 15–25 Mbps each. 4 cameras on Wi-Fi = 60–100 Mbps consumed — degrades everything else.

**Recommended Camera Stack**:
- **Budget/Mid**: Reolink PoE cameras + Reolink NVR
- **Premium**: UniFi Protect — cameras + UNVR + UniFi PoE switch (single ecosystem)
- **Explicitly Avoid**: Any Wi-Fi camera (Ring, Arlo, Xiaomi Wi-Fi cams); cloud-dependent cameras (Nest, Ring without local storage)

**NVR Placement**: With networking gear — in utility closet, bomb shelter, or ventilated cabinet. UPS-protected.

---

## [YOUR_BUSINESS_ALT] Tech Stack Summary

```
                    ┌──────────────────────────────┐
                    │      Voice Assistants         │
                    │   (HomeKit / Google / Alexa)  │
                    │   ── Cloud, Optional Layer ──  │
                    └──────────┬───────────────────┘
                               │ (via HA Bridge)
                    ┌──────────▼───────────────────┐
                    │      Home Assistant           │
                    │   (Automation Engine + UI)    │
                    │   ── Local, Core Platform ──  │
                    └──┬──────┬──────┬──────┬──────┘
                       │      │      │      │
              ┌────────▼┐ ┌──▼──┐ ┌─▼──┐ ┌─▼──────┐
              │ Zigbee2 │ │ZWave│ │ESP │ │Camera  │
              │  MQTT   │ │  JS │ │Home│ │  NVR   │
              └────┬────┘ └──┬──┘ └─┬──┘ └───┬────┘
                   │         │      │        │
         ┌─────────▼──┐ ┌───▼──┐ ┌─▼────┐ ┌─▼──────┐
         │   Zigbee   │ │Z-Wave│ │Wi-Fi │ │  PoE   │
         │   Devices  │ │Devices│ │ESP   │ │Cameras │
         └────────────┘ └──────┘ └──────┘ └────────┘
             
              All on IoT VLAN 20
              MQTT = Mosquitto broker
              All local. No cloud dependency.
```
