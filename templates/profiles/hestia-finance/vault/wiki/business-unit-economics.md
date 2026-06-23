# Business Unit Economics — [YOUR_BUSINESS_ALT] Margin & Pricing

> Last updated: June 2026. All figures in SGD unless stated.

---

## [YOUR_BUSINESS_ALT] Margin Analysis Template

Every package must pass a 3-layer margin check before quoting.

```
LAYER 1: HARDWARE COST
    Bill of materials (retail/wholesale price):    $________
    Shipping + import duties (if any):              $________
    Buffer for price fluctuation (5% of BOM):      $________
    Total hardware cost:                            $________

LAYER 2: LABOUR BUFFER
    Estimated installation hours:                   ________ hrs
    × Labour rate (floor: $30/hr, target: $50/hr): $________
    Subcontractor costs (if outsourced install):     $________
    Total labour:                                   $________

LAYER 3: OVERHEAD & NET PROFIT
    Transport (site visits × trips):                $________
    Consumables (cable ties, trunking, screws):     $________
    Warranty provision (3% of hardware cost):       $________
    Marketing allocation (% of deal):               $________
    Total overhead:                                 $________

    COST BASE = Hardware + Labour + Overhead:       $________
    TARGET NET PROFIT (margin on cost base):        $________
    MINIMUM QUOTE = Cost base + Target net profit:  $________
```

- **Labour rate floor:** $30/hr covers opportunity cost — you could earn that consulting elsewhere. Below this = you're donating time.
- **Target rate:** $50/hr for skilled work (CCTV config, Zigbee mesh tuning, HomeKit programming).
- **Warranty provision:** Ring-fence 3% of hardware into a separate "warranty bank" account. Not profit — it's reserved for call-backs.

---

## Pricing Anatomy — What Clients Actually Pay For

A [YOUR_BUSINESS_ALT] package has 4 pricing layers. Clients only see the quote. You track all four:

| Layer | What it is | Margin profile | [YOUR_BUSINESS_ALT] example |
|---|---|---|---|
| **Base hardware** | Devices at cost | 0% (pass-through or +10–15%) | Aqara hub, sensors, smart plugs |
| **Installation labour** | Physical mounting, cabling | $30–50/hr | Mount blinds motor, run power, trunking |
| **Configuration** | Programming, pairing, scenes | $50–80/hr | Zigbee mesh, HomeKit scene setup, automation rules |
| **Project management** | Design, sourcing, coordination | Built into overhead % (~10%) | Floor plan review, BOM sourcing, client walkthrough |

**Key insight:** Hardware is the least profitable layer. The margin lives in configuration + project management. Don't compete on hardware price — compete on the package outcome.

---

## Renovation Project Profitability Tracking

For [YOUR_BUSINESS_ALT] projects embedded within a larger renovation (Zeus referral):

```
Job: SH + Zeus reno combo
Main contractor: Zeus Renovation
[YOUR_BUSINESS_ALT] scope: $________ (your package value)

REVENUE SPLIT (if referral fee applies):
    SH package (yours):                            $________
    Less: Referral fee to Zeus (%):                $________
    Net SH revenue:                                $________

DIRECT COSTS (same as above):                      $________
LABOUR COST (your hours):                          $________

SH NET PROFIT (standalone):                        $________

BONUS: Did this SH deal enable/speed the Zeus close?
    If yes → attribution value = % of Zeus profit. Track separately.
```

- **Watch out:** When Zeus bundles SH as "free value-add" in a reno package, you still need to trace your costs. A "free" Zigbee lighting package that costs you $800 in hardware + 6 hours labour is a **loss** unless Zeus compensates it separately.
- **Cross-sell rule:** Every completed SH project should generate at least one upsell or referral within 90 days. Track conversion rate.

---

## Cost-Plus vs Value-Based Pricing

### Cost-Plus (current default for most)
```
Price = Cost base × (1 + markup%)
Example: $2,000 cost × 1.3 = $2,600 quote
Margin: 23% (30% markup on cost = 23% margin on price)
```

- ✅ Simple, transparent, safe.
- ❌ Leaves money on the table when client values outcome above parts cost.
- ❌ Penalises efficiency (the faster you work, the less you bill).

### Value-Based (where you should be heading)
```
Price = What the client gains − What they'd lose without it
```

| Package | Hardware cost | Labour | Value to client | Cost-plus price | Value-based price |
|---|---|---|---|---|---|
| Basic smart lighting (4 zones) | $400 | 3 hrs | Energy saving + convenience + "wow" | $590 | $900–1,200 |
| Motorised blinds (2 windows) | $800 | 4 hrs | South-facing heat reduction, privacy, automation | $1,100 | $1,800–2,200 |
| Full smart home (10+ devices) | $2,500 | 12 hrs | Complete scene control, energy dashboards, security | $3,400 | $5,000–6,500 |

**When to use value-based:**
- Client asks "can you make my home smart?" (not "how much per switch?")
- Property is high-end (condo/landed with reno budget > $80k)
- You're the only smart home specialist in the reno package
- Client has never seen the tech before (education premium)

**When to stick to cost-plus:**
- Client is comparing 3 quotes line-by-line
- B2B subcontract work for Zeus (fixed rate per unit)
- Basic installs with no configuration (plug-and-play)

---

## Margin Health Dashboard (weekly)

```
Active projects: ______
    Average gross margin: ______%
    Average net margin (after labour): ______%
    Projects below target net margin: ______ (target: 0)

Monthly blended metrics:
    Total [YOUR_BUSINESS_ALT] revenue:          $________
    Total direct costs:                $________
    Total labour (your hours × rate):  $________
    Net SH profit:                     $________
    Effective hourly rate:             $______/hr (Net profit ÷ total hours)

Target effective hourly rate: $40/hr (floor) / $60/hr (good) / $80+ (excellent)
```

- If effective hourly rate < $40/hr for 2 consecutive months, the business model needs restructuring — not more volume.

---

## Quick Pricing Sanity Check

Before sending any quote, run:

1. At my labour rate, will I earn > $40/hr on this job? → Yes/No
2. If hardware prices rise 10% between now and install, am I still profitable? → Yes/No
3. If install takes 2× estimated hours, is the job still break-even? → Yes/No

**All three must be Yes before sending.** If any is No: raise price, reduce scope, or walk.
