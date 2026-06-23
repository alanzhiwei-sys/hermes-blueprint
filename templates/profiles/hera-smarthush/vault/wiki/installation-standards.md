# Installation Standards

## Purpose
Mandatory installation standards for every [YOUR_BUSINESS_ALT] deployment. These standards ensure consistent quality, professional appearance, and reliable performance across all projects. Every subcontractor receives this document as part of their scope package.

---

## Pre-Installation Requirements

### Site Readiness Checklist
- [ ] Property has power (all circuits live); DB box accessible and labelled
- [ ] Internet service active (ONT/ONR installed and functional)
- [ ] Network rack/cabinet location confirmed with adequate ventilation and power
- [ ] False ceiling / drywall work completed (if cable concealment required)
- [ ] Painting completed (before device mounting to avoid paint on sensors/switches)
- [ ] Floor plan with device positions approved by client
- [ ] Cable schedule finalised with all runs accounted for
- [ ] [YOUR_BUSINESS_ALT] pre-install site survey completed (Wi-Fi scan, Zigbee channel plan, neutral wire audit)
- [ ] Client provided Wi-Fi SSID/password for HA configuration (changed post-install if desired)

### Tools Required On-Site
| Tool | Purpose |
|------|---------|
| Fluke DSX CableAnalyzer (or equivalent) | Cat6/6a cable certification |
| Non-contact voltage tester | Safety check before switch work |
| Network cable toner & probe | Cable tracing and identification |
| Laser distance measure | AP/camera placement verification |
| Spirit level (digital preferred) | Device alignment |
| Drill + masonry bits | Wall mounting |
| Cable rods / fish tape | Cable pulling through conduit/false ceiling |
| Labelling machine (Brother P-Touch) | Cable + device labelling |
| Laptop with Home Assistant access | On-site configuration and testing |

---

## Cable Routing Standards

### General Rules
- **Separation**: Maintain minimum 300mm separation between mains power cables and low-voltage data cables where running parallel. Cross at 90° where intersection is unavoidable.
- **Bend Radius**: Minimum 4× cable diameter bend radius for Cat6/Cat6a. No sharp kinks.
- **Pull Tension**: Maximum 110N (11 kg) pulling tension on Cat6 cable. Use cable lubricant for long runs.
- **Service Loop**: Leave 300mm service loop at both ends of every cable run — at patch panel and at device end.
- **Concealment**: All cable runs inside false ceiling must be supported on cable trays or J-hooks — not laid directly on ceiling grid or tiles. Use Velcro ties (not cable ties) for bundling.

### Trunking & Conduit
- **Surface-Mount (Exposed)**: Use D-Line or MK self-adhesive trunking in white (match wall colour where possible). Minimum 25×16mm for single Cat6; 38×25mm for 2–3 cables.
- **Routes**: Trunking runs must follow architectural lines — along skirting, door frames, ceiling cornices. No diagonal cuts across walls. 90° corners must use trunking angle connectors or neat mitre cuts (not butted with gap fill).
- **Concealed**: Where walls are being hacked/skimmed (during renovation), run cables in 20mm PVC conduit embedded in wall chasing. Back boxes must be 35mm minimum depth for smart switches (47mm preferred for Z-Wave modules).

### Ceiling Access
- **Access Hatches**: For every critical device above false ceiling (Zigbee coordinator, PoE injector, hidden AP), ensure there is an access hatch within 1m. No permanently sealed devices.
- **AP Mounting**: Access points mounted on ceiling surface, not above false ceiling (metal grid and gypsum attenuate Wi-Fi signal significantly). If client insists on hidden AP, use APs designed for in-ceiling mounting (UniFi U6 Enterprise In-Wall or similar with appropriate housing).

---

## Device Mounting Standards

### Smart Switches
- **Alignment**: All switches within a multi-gang box must be perfectly flush — no more than 1mm height variation between gang plates. Use spirit level.
- **Back Box Depth**: Minimum 35mm; 47mm preferred. Shallow back boxes are the #1 installation failure point for smart switches (especially with neutral + Zigbee module behind).
- **Neutral Wire**: Every switch location must have neutral wire verified with multimeter before smart switch installation. No-neutral switches (Aqara D1) only used where neutral is unavailable.
- **Labelling**: Each switch labelled on the back of the faceplate with its Zigbee/Z-Wave device ID for future maintenance.

### Sensors (Motion, Door/Window, Temperature)
- **Motion Sensor Placement**:
  - Ceiling mount: centred in room for 360° coverage
  - Wall mount: at 2.0–2.2m height, angled 15–20° downward
  - Avoid pointing directly at windows (false triggers from outside movement)
  - Avoid mounting within 1m of air-con vents (temperature differential triggers)
  - Avoid mounting where sensor has direct line of sight to robot vacuum dock (false triggers)
- **Door/Window Sensor**:
  - Magnet half on door/window frame, sensor half on moving part
  - Gap between magnet and sensor: ≤ 5mm for reliable detection
  - Mounting: screw preferred; 3M VHB tape only where screw not possible (client approval required — tape fails in Singapore humidity)
- **Temperature/Humidity Sensor**:
  - Mount at 1.2–1.5m height (breathing zone)
  - Away from direct sunlight, air-con vents, kitchen heat sources
  - Minimum 1m from any heat-generating device

### Cameras
- **Height**: Mount at 2.5–3.0m. Higher = wider view but less facial detail. Lower = better face capture but more vulnerable to tampering.
- **Angle**: Aimed to cover entry/exit points and thoroughfares. Avoid pointing at neighbours' windows/doors (PDPA compliance — privacy masking configured in NVR).
- **Cable**: Cat6 terminated to weatherproof RJ45 connector at camera end. Drip loop mandatory for outdoor cameras. All outdoor connections sealed with dielectric grease.
- **Testing**: Camera must be live and recording to NVR before installer leaves site. Verify 24-hour loop recording. Set correct time/date and NTP sync.

### Access Points
- **Placement Principles**:
  - Ceiling-mount in centre of coverage zone
  - One AP per ~70–90 sqm in HDB (concrete walls attenuate heavily)
  - Minimum 3m separation between APs to avoid co-channel interference
  - Avoid mounting behind large metal objects (fridge, mirror, TV)
- **Cable**: Cat6/Cat6a terminated to RJ45. Test connectivity and PoE delivery before mounting.
- **Post-Mount Survey**: Run Wi-Fi survey (UniFi WiFiman or similar) from all key areas — confirm -67 dBm or better signal in all occupied spaces.

### Tablet Wall Mount (Home Assistant Dashboard)
- **Height**: 1.3–1.5m (eye level for average adult). Same height as light switches for multi-gang panel integration.
- **Power**: Recessed USB-C power behind tablet. Dedicated circuit or from nearest power point. No dangling cables.
- **Ventilation**: Ensure recessed box has ventilation gap — tablets generate heat when running HA dashboard 24/7.
- **Screen Settings**: Auto-brightness enabled; screen timeout disabled; HA Companion App in kiosk mode; screensaver enabled after 5 minutes inactivity (clock/weather display).

---

## Testing Checklist (Pre-Handover)

### Network Layer
- [ ] Internet connectivity verified (speed test: ≥80% of subscribed speed for wired)
- [ ] All VLANs configured and routing correctly
- [ ] IoT VLAN: devices can reach internet (for updates/voice) but not Main LAN
- [ ] Guest VLAN: client isolation working; no access to Main LAN or IoT VLAN
- [ ] DHCP reservations set for all fixed devices (HA hub, cameras, NVR, APs, NAS)
- [ ] Wi-Fi coverage verified: ≥-67 dBm in all rooms (2.4 GHz); ≥-70 dBm (5 GHz)
- [ ] All switch ports documented and labelled

### Zigbee / Z-Wave Layer
- [ ] Zigbee coordinator online; all devices paired and reporting
- [ ] Zigbee LQI (Link Quality Indicator) ≥ 80 for all devices (≥ 50 acceptable for distant battery sensors)
- [ ] Z-Wave controller online; all devices interviewed and included
- [ ] Mesh map reviewed: at least 2 routing paths to each battery device
- [ ] No orphaned devices or failed interviews

### Device Layer
- [ ] All smart switches: toggle from HA dashboard; physical toggle works; LED indicator functions
- [ ] All motion sensors: trigger test in HA logbook; response time < 1 second
- [ ] All door/window sensors: open/close registered in HA within 500ms
- [ ] Smart lock: lock/unlock from HA (if integrated); auto-lock timer confirmed
- [ ] Motorised blinds/curtains: open, close, stop, set position (0–100%) all responsive
- [ ] Cameras: live view in NVR/HA; motion detection zones configured; 24-hr recording confirmed
- [ ] Video doorbell: ring notification on HA + client phone; two-way audio working
- [ ] Smart smoke/CO detector: test button triggers HA notification
- [ ] Flood sensors: wet-contact test triggers HA notification

### Automation Layer
- [ ] Motion → Light: walk through each zone; lights turn on within 1 second; turn off after configured timeout
- [ ] Away Mode: arm system; verify all lights off, curtains closed, cameras recording
- [ ] Arrival Mode: disarm; verify welcome scene activates
- [ ] Night Mode: arm; verify selected lights dim, motion sensors on security alert
- [ ] Schedule-based scenes: verify correct activation at configured times
- [ ] Voice control: test each voice assistant (HomeKit/Google/Alexa) on 3 random commands
- [ ] Failure mode test: disconnect internet; verify all local automations still function; re-connect and verify cloud services resume

### Documentation (Delivered to Client)
- [ ] Network diagram (VLAN topology, IP assignments, switch port map)
- [ ] Device inventory (room by room — device type, model, protocol, Device ID)
- [ ] Cable schedule (run ID, from, to, cable type, Fluke certification file reference)
- [ ] Home Assistant backup (downloaded to USB drive + client's Google Drive)
- [ ] User guide: basic operations, adding devices, troubleshooting common issues
- [ ] Support contact: [YOUR_BUSINESS_ALT] WhatsApp + email + Nabu Casa remote access info

---

## Handover Protocol

### Client Walkthrough (2 Hours Minimum)
1. **Network tour** (15 min): Show the rack, explain VLANs, demonstrate UPS
2. **Dashboard tour** (15 min): Walk through HA dashboard on tablet and phone
3. **Room-by-room demo** (45 min): Walk through every room — demonstrate each device and its automations
4. **Voice control demo** (10 min): Demonstrate voice commands for lights, scenes, lock
5. **Troubleshooting basics** (15 min): Show how to reboot HA, check device status, toggle devices manually
6. **Q&A** (20 min): Open session

### Sign-Off Form
```
SMART HUSH INSTALLATION SIGN-OFF

Project: [Name/Address]
Package: [Tier]
Installation Date: [DD/MM/YYYY] — [DD/MM/YYYY]
Lead Installer: [Name]

I confirm that:
[ ] All devices listed in the package scope are installed and functioning
[ ] All automations have been demonstrated and are working
[ ] I have received the network diagram, device inventory, cable schedule, and HA backup
[ ] I have received the user guide and support contact information
[ ] I understand how to operate the system and get help if needed

Client Name: ______________________
Signature: ______________________
Date: ______________________

[YOUR_BUSINESS_ALT] Representative: ______________________
Signature: ______________________
Date: ______________________
```

### Post-Handover
- **24-Hour Check-In**: WhatsApp client; confirm no issues overnight
- **1-Week Check-In**: Follow up; offer adjustment session for automations/settings
- **1-Month Check-In**: Schedule if part of support package; firmware update check
- **Annual Health Check** (Premium tiers): On-site visit — test all devices, update firmware, verify backups, replace batteries as needed
