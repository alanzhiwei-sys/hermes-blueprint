# Smart Home Ecosystem

## Overview
Technology ecosystem reference for [YOUR_BUSINESS_ALT] installations. Covers wireless protocols, device brands, hub requirements, and platform compatibility decisions. Every [YOUR_BUSINESS_ALT] design starts here.

---

## Wireless Protocols

### Zigbee
- **Type**: Low-power mesh network (IEEE 802.15.4)
- **Frequency**: 2.4 GHz (global) — same band as Wi-Fi; potential interference managed through channel selection
- **Range**: ~10–30m per device (extends with mesh/mains-powered devices acting as routers)
- **Key Strengths**:
  - True mesh: each mains-powered device repeats the signal — ideal for whole-home coverage
  - Very low power consumption — excellent for battery sensors (1–2 year battery life typical)
  - Large ecosystem: Aqara, Philips Hue, IKEA TRÅDFRI, Sonoff, Tuya Zigbee
  - Local control possible through Zigbee coordinator (no cloud dependency)
- **Key Weaknesses**:
  - 2.4 GHz congestion in dense HDB/condo environments
  - Device limit ~50–200 devices per network (depending on coordinator)
  - Less standardised than Z-Wave — some inter-brand quirks
- **[YOUR_BUSINESS_ALT] Recommendation**: **Primary protocol for sensor and lighting mesh.** Use Zigbee3.0-certified devices only.

### Z-Wave
- **Type**: Low-power mesh network
- **Frequency**: 868.42 MHz (Singapore/Europe) — separate from Wi-Fi, less congestion
- **Range**: ~30–50m per device (extends with mesh)
- **Key Strengths**:
  - Sub-GHz band — zero Wi-Fi interference; excellent penetration through concrete walls
  - Mandatory certification — all Z-Wave devices interoperate reliably
  - Strong security (S2 framework)
  - Better for critical devices (door locks, smoke alarms, flood sensors)
- **Key Weaknesses**:
  - Smaller device ecosystem than Zigbee
  - Higher device cost (typically 20–40% more than Zigbee equivalent)
  - Different regional frequencies — must buy SG/MY/Asia-market Z-Wave devices (868.42 MHz)
- **[YOUR_BUSINESS_ALT] Recommendation**: **Secondary protocol for security and critical devices.** Use for smart locks, smoke/CO detectors, and flood sensors where reliability is paramount.

### Wi-Fi (Direct)
- **Type**: Standard IP-based wireless
- **Key Strengths**: No hub needed — direct to router/app; familiar setup
- **Key Weaknesses**:
  - High power consumption (unsuitable for battery devices)
  - Router congestion — 20+ Wi-Fi smart devices can degrade home network
  - Often cloud-dependent (privacy, latency, internet-outage-fragility)
- **[YOUR_BUSINESS_ALT] Recommendation**: **Avoid for most devices.** Use only where no Zigbee/Z-Wave alternative exists (e.g., certain robot vacuums, smart TVs). All Wi-Fi IoT devices go on a dedicated VLAN (see `tech-stack-decisions.md`).

### Bluetooth / BLE Mesh
- **Type**: Short-range, increasingly mesh-capable
- **Key Strengths**: Direct phone pairing; Thread/Matter support growing; low cost
- **Key Weaknesses**: Range limitations; BLE mesh still maturing; fewer Home Assistant integrations
- **[YOUR_BUSINESS_ALT] Recommendation**: **Use only where required** (e.g., SwitchBot curtain bots, certain smart locks). Thread/Matter adoption promising but wait for stability.

### Thread & Matter (Emerging)
- **Status**: Growing ecosystem; Matter 1.3+ supports more device types
- **Recommendation**: Monitor actively. Spec Thread border routers (Apple HomePod, Google Nest Hub) in all new designs as future-proofing. Not yet the default recommendation.

---

## Key Device Brands

### Aqara (Zigbee — Tier 1 Recommended)
- **Category**: Sensors, switches, relays, smart locks, motorised curtain tracks
- **Zigbee Version**: Zigbee 3.0
- **Hub Options**: Aqara Hub M3 (multi-protocol), or direct pair to Home Assistant via Zigbee2MQTT / ZHA
- **Strengths**: Excellent build quality, competitive pricing, wide product range, good HomeKit compatibility, local control via Zigbee2MQTT
- **Weaknesses**: Older Aqara devices may not play well with non-Aqara Zigbee routers; use Aqara-specific repeaters or mains-powered Aqara devices as routers
- **[YOUR_BUSINESS_ALT] Go-To Devices**: Aqara D1/Z1 Pro switches (no neutral), Aqara T1 sensors, Aqara E1 curtain driver

### Philips Hue (Zigbee — Premium)
- **Category**: Smart lighting
- **Strengths**: Best-in-class light quality, reliability, large ecosystem
- **Weaknesses**: Expensive; Hue hub adds cost layer
- **Recommendation**: Client wants premium smart lighting? Hue. Budget-conscious? Aqara + compatible Zigbee bulbs.

### Sonoff (Zigbee/Wi-Fi — Budget)
- **Category**: Relays, switches, sensors
- **Strengths**: Very affordable, good Zigbee range
- **Weaknesses**: Build quality varies; flash with Tasmota/ESPHome for local control on Wi-Fi models
- **Recommendation**: Good for behind-switch relays (ZBMINI) where aesthetics aren't visible.

### Tuya (Zigbee/Wi-Fi — Broad Ecosystem)
- **Category**: Everything — sensors, switches, bulbs, blinds, locks
- **Strengths**: Cheapest, widest selection
- **Weaknesses**: Cloud-dependent on stock firmware; quality varies wildly by OEM; local control requires Tuya Local / Zigbee2MQTT
- **Recommendation**: Use Zigbee Tuya devices with Zigbee2MQTT for local control. Avoid Tuya Wi-Fi devices unless flashed with ESPHome.

---

## Hub Requirements

### Home Assistant (Recommended Hub)
- **Hardware**: Raspberry Pi 5 (8GB), Intel NUC, or Home Assistant Green/Yellow
- **Storage**: Minimum 128GB SSD (avoid SD cards for long-term reliability)
- **Zigbee Coordinator**: SONOFF Zigbee 3.0 USB Dongle Plus (CC2652P) or SMLIGHT SLZB-06 (PoE — recommended for central placement)
- **Z-Wave Controller**: Zooz ZST39 LR or Aeotec Z-Stick 7
- **Minimum Specs**: 2GB RAM, 32GB storage, Ethernet recommended; for 50+ devices: 4GB RAM minimum
- **Add-ons**: Zigbee2MQTT, Z-Wave JS UI, Node-RED, Mosquitto (MQTT broker), ESPHome

### Hubitat (Alternative Hub)
- **Strengths**: All-in-one appliance, lower maintenance than Home Assistant, built-in Z-Wave and Zigbee radios
- **Weaknesses**: Less flexible, smaller community, fewer integrations
- **Recommendation**: Offer as simpler alternative for clients who want smart home without tinkering. Home Assistant preferred for [YOUR_BUSINESS_ALT] managed installs.

### Apple HomeKit / Google Home / Amazon Alexa
- **Role**: Front-end voice control and family-facing UI — NOT the hub
- **Integration**: Home Assistant exposes all devices to HomeKit (via HomeKit Bridge) and Google/Alexa (via Nabu Casa cloud or manual setup)
- **Recommendation**: Always bridge to client's preferred voice assistant. HomeKit Bridge = default for Apple households.

---

## Network Infrastructure Minimum
- **Router**: UniFi Dream Router / TP-Link Deco X50 (Wi-Fi 6 minimum)
- **Switch**: Managed PoE switch (for Zigbee coordinator, cameras, access points)
- **VLANs**: Minimum 3 — Main LAN, IoT (all smart devices + hub), Guest
- **UPS**: Small UPS for router, switch, Home Assistant hub (survive power flickers, enable graceful shutdown)
- **Static IPs**: Home Assistant, cameras, NVR — all DHCP-reserved or static

---

## Ecosystem Decision Flowchart
```
Q1: Does the client want voice control?
  Yes → Which ecosystem? Apple (HomeKit) / Google / Alexa
       → Bridge via Home Assistant
  
Q2: Number of devices expected?
  <20 devices → Hubitat or Home Assistant (either)
  20–80 devices → Home Assistant (required)
  80+ devices → Home Assistant + dedicated coordinator placement + Zigbee channel planning

Q3: Client technical comfort?
  Tech-savvy & wants full control → Home Assistant
  Prefers set-and-forget → Hubitat + scheduled maintenance visits

Q4: Security/critical devices?
  Smart lock → Z-Wave (not Zigbee)
  Smoke/CO/flood sensors → Z-Wave preferred
  Cameras → PoE IP cameras (UniFi Protect / Reolink / Hikvision) — NEVER Wi-Fi for security cameras
  Alarm → Wired sensors to Konnected.io panel where possible
```
