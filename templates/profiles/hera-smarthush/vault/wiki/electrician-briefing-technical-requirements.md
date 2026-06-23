# [YOUR_BUSINESS_ALT] Electrician Briefing — Technical Requirements

## Purpose
Mandatory briefing for all electrician subcontractors working on [YOUR_BUSINESS_ALT] installations. This covers four critical areas where standard residential electrical work diverges from smart-home requirements. Read and acknowledge before starting site work.

---

## 1. NEUTRAL WIRE REQUIREMENTS

### The Non-Negotiable

**Most Aqara/Zooz smart switches require a neutral wire.** If there is no neutral at the switch box, the switch will malfunction (random flickering, failure to pair, or complete dropout from the Zigbee/Z-Wave mesh).

### Standard Switch Configurations by Brand

| Switch Model | Neutral Required | Works Without Neutral? | Notes |
|---|---|---|---|
| Aqara D1 / D1 Pro | No | Yes | Single live wire only — our fallback when no neutral exists |
| Aqara Z1 Pro / H1 | Yes | No | Requires neutral + live — preferred for performance/reliability |
| Zooz ZEN31 / ZEN30 | Yes | No | Z-Wave line voltage switches — neutral mandatory |
| Sonoff ZBMINI (behind plate) | No | Yes | Inline relay; hidden behind normal plate + dumb switch |

### Pre-Install Neutral Audit Procedure

**Before any switch removal, the electrician MUST:**

1. Isolate the circuit at the DB
2. Remove the existing switch plate
3. Identify all wires with a multimeter (phase, live out, neutral) — visual identification only is NOT acceptable
4. Tag each wire clearly (L-in, L-out, N, Earth)
5. Photograph each switch box with wires exposed for [YOUR_BUSINESS_ALT] records
6. Mark each location on the floor plan: Neutral YES / Neutral NO

**Where neutral is absent:**
- Do NOT create a neutral by running wire from a nearby ceiling rose without [YOUR_BUSINESS_ALT] approval — this can create a floating neutral and is a safety risk
- Flag the location immediately; we will switch to D1 Pro or Sonoff ZBMINI design
- In 60%+ of pre-2000 HDB builds, switch boxes lack neutral. This is normal.

### Multi-Way Switch Circuits

- Existing two-way/multi-way lighting circuits **must remain wired to multi-way** — do NOT rewire to single-pole unless we explicitly instruct it
- For Aqara D1 multi-way: the second location uses a D1 wireless wall switch (battery-powered, no rewiring)
- For Zooz Z-Wave multi-way: Z-Wave scene controller at second location — again, no rewiring

---

## 2. ZIGBEE REPEATER PLACEMENT

### Why the Electrician Needs to Know This

The Zigbee mesh depends on mains-powered devices (switches, plugs, repeaters) acting as routers between battery sensors and the coordinator. If we place switches/repeaters behind thick concrete walls or metal junction boxes without planning, the mesh fails and end devices orphan.

### Coordinator Location Rules

- The Zigbee coordinator (USB dongle or SLZB-06 PoE unit) must be placed **centrally** in the home — not crammed in the utility closet behind a metal DB box
- USB dongles: antenna must point UP, not into the cabinet side panel
- Minimum 1m separation from any USB 3.0 device (hub, SSD, NAS) — USB 3.0 creates 2.4 GHz radio noise that kills Zigbee
- Metal electrical DB boxes act as Faraday cages. Never place the coordinator inside an unventilated metal enclosure without antenna passthrough

### Repeater Spacing Guidelines

- **Target**: One mains-powered Zigbee device every 8–12m (wall-to-wall, accounting for HDB concrete)
- **Minimum LQI threshold**: Every sensor must show Link Quality Indicator >= 80 in Zigbee2MQTT (50 acceptable for distant battery sensors only)
- When laying out switch locations, every room with battery sensors (motion, door/window, temperature) must have a mains-powered Zigbee device within 2 wall penetrations

### Power Point Placement for Future Proofing

- Install 1 extra 13A power point near the network rack/central location — dedicated for Zigbee coordinator, Smart Plug (as repeater backup), and UPS
- Label this point: **"IoT Hub Power"**
- Do not share this circuit with air-con compressors, heaters, or any motor load — voltage sags reset USB dongles

### What to Avoid

- Do NOT mount Zigbee-powered switches inside a deep metal trunking run behind a switch plate with no antenna clearance
- Do NOT place the coordinator behind a mirror, fridge, or large TV — metal and glass attenuate the signal
- Do NOT run the coordinator antenna cable through an electrical junction box — use drywall or plastic conduit only

---

## 3. SMART SWITCH BACKBOX REQUIREMENTS

### Depth Matters

Standard HDB deep boxes are 25mm. Smart switches need **more**.

| Switch Type | Minimum Box Depth | Recommended Depth | Why |
|---|---|---|---|
| Aqara D1 single gang (no neutral) | 25mm | 35mm | Compact body; fits standard box |
| Aqara D1 double/triple gang | 25mm | 35mm | Wider but still shallow |
| Aqara Z1 Pro (neutral + Zigbee module) | 35mm | 47mm | Zigbee module adds bulk behind switches |
| Zooz ZEN series (Z-Wave) | 35mm | 47mm Z-Clip | Z-Wave controller is longer than Zigbee equivalents |
| Sonoff ZBMINI (behind standard plate) | 25mm | 35mm | Fits inside existing box if just 5mm deeper |

### Replacement Protocol

**For pre-wired HDB/condo switch boxes:**
1. Check existing box depth with a tape measure before the job
2. If < 35mm and we specified Z1 Pro/Zooz switches, flag to [YOUR_BUSINESS_ALT] immediately — either upgrade the back boxes NOW or change device selection
3. For renovated properties where walls are being hacked/skimmed: install 47mm deep boxes at ALL switch locations as standard
4. For double-gang and triple-gang installations: use matching width back boxes — misalignment between gangs causes visible gaps

### Alignment Tolerance

- Multi-gang switch plates must be **flush and level** — max 1mm height difference between gangs
- Use a spirit level when fixing the plate
- If the back box is recessed too shallow and the plate won't sit flush, replace the box — do NOT shim with filler

### Wire Management Inside the Box

- Leave 50mm of stripped wire length (not 30mm) — smart switches have smaller terminal blocks than standard switches and need more slack
- Twist and cap any unused wire ends with wire nuts — no exposed copper inside the back box
- When running neutral (if the box has it): terminate cleanly and do NOT let it touch the live terminals

### Label Back of Faceplate

Every installed faceplate must have the device's Zigbee/Z-Wave MAC address or entity ID written on the back with a permanent marker. This saves hours of troubleshooting later when we need to depair/re-pair a specific switch.

---

## 4. COMMISSIONING SEQUENCE

### Do NOT install everything and then power on. Follow this order:

### Phase 1: Network Foundation (Before Any Smart Devices)

```
[ ] All Cat6 cable runs terminated and Fluke-certified
[ ] Patch panel connected to managed switch
[ ] IoT VLAN (VLAN 20) configured and tagged
[ ] DHCP reservations set for: coordinator, NVR, cameras, APs
[ ] Internet connectivity confirmed at the rack
```

### Phase 2: Coordinator + Mesh Backbone

```
[ ] Zigbee coordinator installed and powered (antenna UP)
[ ] Home Assistant OS booted and accessible on LAN
[ ] Zigbee2MQTT add-on running; coordinator detected
[ ] Zigbee channel confirmed (Channel 25 = default unless survey recommends otherwise)
[ ] First mains-powered Zigbee device paired — this becomes the primary repeater
```

> **Rule**: Coordinator and network layer must be green before installing any battery devices or end-point sensors.

### Phase 3: Mains-Powered Smart Switches (All of Them)

```
[ ] Install ALL smart switches before sensors
[ ] Each switch paired and confirmed in Zigbee2MQTT/Z-Wave JS
[ ] Verify each switch has LQI >= 80 (Zigbee) or health check score >= 7/7 (Z-Wave)
[ ] Confirm each switch responds to HA toggle AND physical toggle
[ ] Confirm LED indicator works (or is deliberately disabled per room)
```

> **Why this order**: The mesh is built from mains-powered devices first. Sensors connect to the mesh that already exists — not the other way round.

### Phase 4: Battery Sensors

```
[ ] Motion sensors installed and paired — verify placement per plan
[ ] Door/window sensors paired — gap <= 5mm between magnet and sensor
[ ] Temperature/humidity sensors paired
[ ] Every sensor shows LQI >= 50 in Zigbee2MQTT
[ ] Every sensor reports at least once within 5 minutes of pairing
```

### Phase 5: Cameras + NVR

```
[ ] All PoE cameras mounted and powered
[ ] Each camera visible in NVR with live feed
[ ] Recording confirmed (24-hour loop minimum)
[ ] Privacy motion zones drawn (no neighbour windows/doors)
[ ] NTP sync confirmed on NVR
```

### Phase 6: Automations + Testing

```
[ ] Motion-to-light automations active and tested (response < 1s)
[ ] Away/Arrival/Night Modes tested
[ ] Internet-isolation test: pull the internet cable; confirm all local automations still work
[ ] Voice control test (HomeKit/Google) on 3 random commands
```

### Phase 7: Documentation + Handover Prep

```
[ ] Cable schedule completed with Fluke report references
[ ] Device inventory updated (room-by-room, protocol, device ID)
[ ] Network diagram finalised
[ ] HA snapshot/backup downloaded
[ ] Sign-off form printed for client walkthrough
```

---

## Quick Reference Card (Laminate and Keep in Tool Bag)

```
NEUTRAL CHECK: multimeter before removal; photograph every box; mark floor plan
MIN BOX DEPTH: 35mm (Aqara D1), 47mm (Z1 Pro / Zooz Z-Wave)
COORDINATOR: antenna UP, 1m from USB 3.0, not inside metal DB box
ZIGBEE CHANNEL: 25 default; confirm with Wi-Fi survey first
MESH ORDER: coordinator -> mains switches -> battery sensors -> cameras -> automations
LQI THRESHOLD: >= 80 switches, >= 50 sensors
COMMISSIONING: never power on battery devices until mains mesh is complete
MULTI-WAY: do NOT rewire to single-pole unless explicitly instructed
LABEL: every faceplate gets device ID on the back
```

---

## Acknowledgement

I, _______________, certify that I have read and understood the [YOUR_BUSINESS_ALT] electrical briefing requirements for neutral wire auditing, Zigbee repeater placement, smart switch backbox specifications, and the commissioning sequence. I commit to following these standards on all [YOUR_BUSINESS_ALT] jobs.

Signature: ________________________     Date: ____________
Company: _________________________     EMA LIC #: __________
