# Tool Adoption Framework

Every tool you adopt is a long-term relationship — you'll live with its quirks, pay its bills, and depend on its reliability. This framework ensures you choose tools deliberately, not reactively.

## Evaluation Criteria

Score each candidate tool (1-5) across these dimensions:

- **Core fit (weight: 30%)** — Does it solve the actual problem, or a slightly different one? Be ruthless: if you need a hammer, a multi-tool that also hammers isn't a hammer.
- **Learning curve (weight: 15%)** — Time to basic proficiency. Under 2 hours = 5. Over 2 weeks = 1. Your team's learning budget is real money.
- **Integration surface (weight: 20%)** — Native APIs, webhooks, Zapier/Make connectors, data export formats. Can you get data in and out without manual CSV wrangling?
- **Vendor risk (weight: 20%)** — Company age, funding, founder retention, open-source fallback. A startup acquired and sunset in 18 months costs you more than the subscription.
- **Community & support (weight: 10%)** — Documentation quality, community responsiveness, support SLA. A great tool with zero docs is a brick.
- **Pricing predictability (weight: 5%)** — Per-seat vs. usage-based vs. hidden enterprise-tiers. Surprise price hikes are a failure mode of the evaluation, not the vendor.

**Scoring**: Weighted total below 3.0 → reject. 3.0-4.0 → trial. Above 4.0 → strong candidate.

## Total Cost of Ownership (TCO) Calculator

Subscription price is the smallest line item. True TCO includes:

```
TCO = (Subscription × Months) + (Migration Cost) + (Training Hours × Hourly Rate) + (Integration Build Cost) + (Annual Maintenance Hours × Hourly Rate) + (Switching Cost Buffer × 0.3)
```

**Switching cost buffer**: Estimate the cost of migrating away (data export, retraining, pipeline rewiring). Multiply by 0.3 and add to TCO — this is your insurance against vendor lock-in. If the buffer exceeds 50% of subscription cost, the tool owns you, not the other way around.

**Example**: A $29/month tool with $2,000 migration cost, 5 hours training ($250), 8 hours integration ($400), and 2 hours/month maintenance ($1,200/year) over 3 years:
- Subscription: $1,044
- Total TCO: $4,894
- Perceived vs. actual: 4.7× multiplier

## Build vs. Buy Decision Matrix

| Factor | Favor Buy | Favor Build |
|--------|-----------|-------------|
| Core to differentiation | Commodity | Strategic advantage |
| Time to value | Under 1 week | Acceptable in 1-3 months |
| In-house expertise | None | Strong, available |
| Maintenance burden | Vendor handles | Acceptable ongoing cost |
| Customization need | Standard workflows | Unique, non-negotiable |
| Data sensitivity | Tolerable external hosting | Must stay in-house |

**Decision rule**: If 4+ factors land in "Buy" → buy. If 4+ land in "Build" → build. At 3-3, default to buy (reversibility is a feature). You can always migrate from a SaaS later; un-building custom software is harder.

**No-code exception**: If a no-code/low-code tool (Airtable, Make, n8n, Retool) can deliver 80% of the build outcome at 20% of the cost and time, treat it as "buy." The remaining 20% gap is rarely worth closing.

## Stack Compatibility Checklist

Before adopting any tool, verify:

- [ ] **Authentication**: Does it support SSO/SAML/OIDC, or will you manage yet another password?
- [ ] **Data residency**: Where does data live? GDPR/PDPA implications?
- [ ] **Export format**: Can you export all data in machine-readable format (JSON/CSV/SQL dump)? Test this during trial — don't trust the docs.
- [ ] **API rate limits**: What's the practical throughput? "1,000 requests/minute" means nothing if each operation costs 50 requests.
- [ ] **Webhook reliability**: Do webhooks support retry with exponential backoff? Are delivery logs available?
- [ ] **Incident history**: Check their status page history. More than 2 major incidents per quarter → risk factor.
- [ ] **Deprecation policy**: How much notice for breaking API changes? Any history of surprise deprecations?
- [ ] **Overlap audit**: Does this tool duplicate functionality already covered by the existing stack? Every overlapping tool adds cognitive overhead and integration debt.

## Action Steps

1. For every tool currently in your stack, calculate the TCO multiplier. Any above 5× should trigger a replacement evaluation.
2. Before adopting a new tool, run the 8-point compatibility checklist. Flag any "no" answers for explicit risk acceptance.
3. Maintain a **tool register** (a simple Notion table or spreadsheet) with: name, subscription cost, renewal date, TCO estimate, owner, and last review date. Review quarterly.

---

*Last reviewed: June 2026*
