# Decision Framework

Good decisions aren't about being right every time. They're about having a repeatable process that surfaces assumptions, quantifies tradeoffs, and prevents the cognitive biases that sabotage even the smartest minds. This framework gives you that process.

## The Decision Matrix

When comparing options with multiple criteria, use a weighted scoring model:

1. **List options** (rows): Option A, Option B, Option C.
2. **Define criteria** (columns): What matters? Cost, speed, risk, strategic fit, reversibility.
3. **Weight criteria** (1-10): Not all criteria are equal. "Strategic fit" might be an 8 while "implementation speed" is a 4.
4. **Score each option** (1-5 per criterion): Be honest. 5 = excellent fit, 1 = poor.
5. **Calculate weighted totals**: Sum(weight × score) for each option.

**Critical rule**: The matrix doesn't make the decision — it surfaces tradeoffs. If the top-scoring option *feels* wrong, drill into why. The gap between intuition and score is where hidden assumptions live.

**Format** (avoid tables in chat; use labeled scorecards):
- **Option A**: Cost (3/5, weight 7) = 21 | Speed (5/5, weight 4) = 20 | Risk (2/5, weight 9) = 18 → **Total: 59**
- **Option B**: Cost (5/5, weight 7) = 35 | Speed (3/5, weight 4) = 12 | Risk (4/5, weight 9) = 36 → **Total: 83**

Option B wins — but ask: why is Option A's risk score so low? Is that fixable?

## Cost-Benefit Analysis (CBA)

For binary decisions ("should I do X?"), quantify both sides in the same currency:

```
Net Benefit = Total Benefits (one-time + recurring × years) - Total Costs (one-time + recurring × years)
```

**Rules for honest CBA**:
- **Timeframe anchor**: Use a consistent horizon (3 years for tactical decisions, 5-10 years for strategic).
- **Include opportunity cost**: What's the next-best use of the same time/money? This is the most commonly omitted line item — and the most important.
- **Sensitivity check**: Recalculate with benefits 30% lower and costs 30% higher. Does the decision still make sense? If not, it's fragile.
- **Non-monetary factors**: Some benefits (peace of mind, learning, reputation) resist quantification. List them separately — don't force a dollar value. If they dominate the decision, acknowledge that explicitly.

## Risk Scoring

For any decision with uncertainty, score three dimensions:

| Dimension | Low Risk (1) | Medium Risk (3) | High Risk (5) |
|-----------|-------------|-----------------|---------------|
| **Probability** of negative outcome | <10% | 10-40% | >40% |
| **Impact** if it materializes | Minor inconvenience | Significant setback | Existential threat |
| **Recoverability** | Fully reversible within days | Partially reversible with effort | Permanent or near-permanent |

**Risk Score** = Probability × Impact. A score above 15 is a red flag. A score above 9 with low recoverability should trigger escalation — don't make these decisions alone.

**Pre-mortem**: Before committing, imagine the decision failed 12 months from now. Write a brief obituary: "This failed because ________." The specific reason you write first is what you should safeguard against.

## Sunk-Cost Awareness

The sunk-cost fallacy is the single most expensive cognitive error in decision-making. Symptoms:

- "We've already spent $X, so we should continue."
- "If we stop now, all that effort was wasted."
- "Just a little more time/money and it'll work."

**The cure**: Every decision is forward-looking. Past costs are gone — they exist whether you continue or stop. The only question that matters: "Given where we are today, is the best use of our next dollar/hour to continue, or to redirect?"

**Sunk-cost audit**: Review your current projects. For each, ask: "If I inherited this project today with zero history, would I fund it?" If the answer is no, you have your answer. The history is irrelevant.

## Decision Journal

Keep a simple log of major decisions. Template:

```
Date: [date]
Decision: [one sentence]
Options considered: [brief list]
Chosen option: [which one]
Key assumptions: [what must be true for this to work]
Expected outcome: [what success looks like in 6/12 months]
Confidence level: [1-10]
```

Review every 6 months. The journal's purpose isn't to be right — it's to calibrate your judgment. Patterns will emerge:
- Where do you overestimate benefits?
- Which types of decisions consistently underperform?
- What assumptions recur that you should test more rigorously?

**The meta-decision**: Deciding *how* to decide is itself a decision. For low-stakes choices (< $500 impact, reversible within a week), don't use this framework — it's overhead. Reserve formal analysis for decisions where the cost of a bad outcome exceeds the cost of analysis. A $100 decision that takes 4 hours of analysis already lost.

## Action Steps

1. Start a decision journal today. Log the next 3 significant decisions.
2. For any pending major decision, run a pre-mortem. Write the failure obituary.
3. Audit your current projects for sunk-cost entrapment. Be willing to kill your darlings.

---

*Last reviewed: June 2026*
