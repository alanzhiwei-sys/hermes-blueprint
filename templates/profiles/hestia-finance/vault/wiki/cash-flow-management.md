# Cash Flow Management — Personal Runway & [YOUR_BUSINESS_ALT]

> Last updated: June 2026. All figures in SGD.

---

## Personal Runway Calculation Template

Runway answers: "If all income stops today, how many months until I'm broke?"

```
(A) Liquid assets
    Cash (bank balances):           $________
    Liquid investments (stocks/ETFs at 80% haircut): $________
    Emergency fund (dedicated):     $________
    Total liquid (A):               $________

(B) Monthly fixed burn
    Mortgage/rent:                  $________
    Utilities + internet:           $________
    Insurance (all policies):       $________
    Groceries (essential only):     $________
    CPF Medisave top-up required:   $________
    Transport (essential):          $________
    Debt servicing (min payments):  $________
    Total monthly burn (B):         $________

RUNWAY (months) = (A) / (B) = ______ months
```

- ⚠️ Haircut: Don't count illiquid assets (property equity, CPF OA beyond what's withdrawable, cars).
- ⚠️ Baseline scenario: all [YOUR_BUSINESS_ALT] revenue → $0. No new projects. No employment salary.
- ⚠️ Stretch scenario: Employment continues but [YOUR_BUSINESS_ALT] → $0. Subtract employment net salary from (B) and recalc.
- **Target:** 12 months runway minimum. 6 months = yellow. < 3 months = red.

---

## [YOUR_BUSINESS_ALT] Profit/Loss Per Project Tracking

**Mandatory per-project close-out within 7 days of handover.**

```
Project ID: SH-YYYY-MM-XXX
Client name: ________________  Date: ___/___/___

REVENUE
    Contract value (incl. any VO):         $________
    Less: Discounts/rebates:               $________
    Net revenue:                           $________

DIRECT COSTS
    Hardware/materials (receipt-attached): $________
    Subcontractor payments:                $________
    Transport (site visits × trips):       $________
    Consumables + misc:                    $________
    Total direct costs:                    $________

GROSS PROFIT (Net revenue − Direct costs):  $________
    Gross margin %: ______%

LABOUR BUFFER
    Your hours × rate ($__/hr):            $________
    Total labour allocation:               $________

NET PROFIT (Gross profit − Labour buffer):  $________
    Net margin %: ______%
```

- Labour rate floor: Use at least $30/hr as the opportunity cost of your time. If project nets below this after paying yourself, it's a **loss-making project** — cash positive ≠ profitable.
- File each project close-out in `vault/raw/` for aggregation.

---

## Revenue-vs-Cash Gap Detection

The gap is: **invoiced amount − cash collected**. It kills side hustles.

```
Reconciliation (monthly):
    (a) Revenue recognised this month (invoices sent):    $________
    (b) Cash received this month (bank deposits):          $________
    (c) Gap = (a) − (b):                                   $________
    (d) Cumulative gap (carried forward + this month):     $________
```

- ⚠️ [YOUR_BUSINESS_ALT] clients often pay at milestones: 30% deposit, 40% midway, 30% on completion.
- A project at "80% complete" with only deposit collected = you are the client's bank.
- Flag rule: If cumulative gap > 1 month's burn OR > 30% of monthly revenue → escalate.

---

## Burn Rate Monitoring

Track month-on-month. Three lines to watch:

| Metric | Formula | Yellow | Red |
|---|---|---|---|
| Monthly burn | Fixed costs + variable biz costs | > 70% of avg income | > 100% of avg income |
| Net cash flow | Cash in − Cash out (actual) | Negative 1 month | Negative 2+ months |
| Runway change | (Last month runway) − (This month runway) | Dropped by 1 month | Dropped by 2+ months |

- Run this check every Sunday. Takes 5 minutes with bank balance + the template above.

---

## Emergency Fund Sizing — 3/6/12 Month Tiers

Based on employment stability + business risk profile.

| Tier | Months of burn | Who it's for | Trigger to move up |
|---|---|---|---|
| **Tier 1** | 3 months | Stable employment, no dependents, [YOUR_BUSINESS_ALT] < 20% of income | — |
| **Tier 2** | 6 months | Side hustle > 20% of income, 1 dependent, or contract-based work | Revenue-vs-cash gap breached 2 months in a row |
| **Tier 3** | 12 months | Sole income is side hustle, multiple dependents, renovation industry cyclical dip risk | If [YOUR_BUSINESS_ALT] > 50% total income OR expecting market slowdown |

- **Stacking rule:** The cash must be in a separate, instantly accessible account (CIMB FastSaver, OCBC 360, UOB One — not CPF, not SRS, not equities).
- **Refill rule:** If you draw emergency funds, all surplus goes to refill before any new discretionary spending.
- **Interest rate:** Emergency fund earns negligible interest. That's fine — the job is liquidity, not returns.

---

## Quick Health Check (30-second Sunday scan)

1. Current runway: ______ months (target: 12)
2. Cumulative revenue-vs-cash gap: $______ (yellow if > 1× burn)
3. Projects with open invoices > 30 days: ______ (target: 0)
4. Emergency fund % of target tier: ______%

✅ All green → standard week.
⚠️ Any yellow → review next 30 days of inflows.
❌ Any red → immediate halt on discretionary spend.
