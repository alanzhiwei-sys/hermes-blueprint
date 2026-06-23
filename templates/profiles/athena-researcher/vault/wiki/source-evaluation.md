# Source Evaluation

## Overview

A rigorous framework for evaluating the credibility, relevance, and reliability of information sources. Every source must pass through this evaluation before being used as evidence in research outputs.

## Credibility Scoring

Rate each source on five dimensions using a 1-5 scale. Multiply scores for a composite credibility index (max 125).

### Scoring Dimensions

| Dimension | 1 (Poor) | 3 (Adequate) | 5 (Excellent) |
|-----------|----------|--------------|---------------|
| **Authority** | Anonymous, unknown author | Recognized in field, some credentials | Leading expert, institutional authority |
| **Accuracy** | Contains known errors, unsupported claims | Generally consistent with other sources | Peer-reviewed, multiple corroborations |
| **Objectivity** | Clear advocacy, sponsored content | Some bias acknowledged | Independent, transparent methodology |
| **Currency** | >5 years old, no updates | 1-3 years old | <1 year, regularly updated |
| **Coverage** | Superficial, single data point | Adequate depth, some gaps | Comprehensive, primary data included |

### Composite Score Interpretation

- **100-125:** Gold standard — use as primary evidence
- **75-99:** Reliable — acceptable as supporting evidence
- **50-74:** Use with caution — triangulate before citing
- **25-49:** Weak — use only for context or hypothesis generation
- **<25:** Discard — not suitable for research

## Primary vs Secondary Sources

Understanding the distinction is critical for evidence grading.

### Primary Sources
First-hand, original data or direct observation:
- SEC filings, annual reports, earnings call transcripts
- Government datasets and statistical releases
- Patent filings and trademark registrations
- Original interviews conducted by the researcher
- Raw survey data, experiment results
- Court documents, regulatory proceedings
- Product teardowns and hands-on testing

**Strength:** Closest to the ground truth. Minimal interpretation layers.
**Weakness:** Requires expertise to interpret correctly. May lack context.

### Secondary Sources
Analysis, interpretation, or aggregation of primary sources:
- Industry analyst reports (Gartner, Forrester, IDC)
- Academic literature reviews and meta-analyses
- News articles and trade press
- Competitor write-ups and market summaries
- Aggregated review platforms (G2, TrustRadius)

**Strength:** Adds context, synthesis, and expert interpretation.
**Weakness:** Introduces interpretive bias. May be based on incomplete or outdated primaries. Always trace to the underlying primary source when possible.

## Recency Weighting

Apply time-decay weighting to sources based on domain dynamics:

| Domain | Stale Threshold | Recency Rule |
|--------|----------------|--------------|
| **Technology / SaaS** | 6 months | Prefer sources <6 months. Sources >1 year: flag as potentially outdated. |
| **Financial markets** | 3 months | Data >1 quarter old may no longer reflect reality. |
| **Regulatory / Legal** | Variable | Check for amendments and updates regardless of publication date. |
| **Demographics / Census** | 2 years | Acceptable with caveats. Note if projections are used beyond last census. |
| **Scientific / Academic** | 5 years | Foundational papers remain relevant. Check for replication studies and retractions. |

**Rule:** The faster the domain moves, the tighter the recency window. Always note the "data-as-of" date explicitly in your research.

## Conflict-of-Interest Detection

Before relying on any source, scan for conflicts of interest:

### Red Flag Checklist
- [ ] **Funder:** Who paid for this research? Is the funder a beneficiary of the conclusions?
- [ ] **Commercial Interest:** Does the source sell products/services in the market they're analyzing?
- [ ] **Employment History:** What is the author's career path? Do they have ties to companies discussed?
- [ ] **Reputational Stake:** Would the source lose credibility/standing if they reached the opposite conclusion?
- [ ] **Selection Bias:** Did the source choose what to publish? What might they have omitted?
- [ ] **Sample Bias:** For surveys — who was sampled, how were they recruited, what's the response rate?

**Protocol:** For any source flagged with 2+ red flags, either (a) disclose the conflicts prominently in your citation, or (b) exclude the source and find alternatives.

### Sponsor Transparency Table

| Source | Sponsor/Funder | Commercial Interest | COI Risk | Mitigation |
|--------|---------------|-------------------|----------|------------|
| Report X | Vendor Y | Sells in this market | High | Cross-check with independent source Z |

## Citation Format

Use a consistent citation format across all research outputs. This ensures traceability and enables verification.

### Standard Citation Template

```
[Author/Organization]. ([Year], [Month]). *[Title]*. [Publisher/Platform]. [Tier]. [URL]
```

### Examples by Source Type

**Analyst report:**
Gartner. (2025, Q3). *Magic Quadrant for Cloud Infrastructure*. Gartner Research. Tier 2. https://gartner.com/report-id

**SEC filing:**
Salesforce Inc. (2025, March). *Form 10-K Annual Report*. SEC EDGAR. Tier 1. https://sec.gov/...

**News article:**
TechCrunch. (2025, June 5). "Startup X Raises $50M Series B." TechCrunch. Tier 3. https://techcrunch.com/...

**Interview:**
Smith, J., CEO of Company X. (2025, May 15). Personal interview. Tier 1 (primary).

**Government data:**
U.S. Bureau of Labor Statistics. (2025, April). *Occupational Employment and Wage Statistics*. BLS.gov. Tier 1. https://bls.gov/oes/

### Citation Rules
- URLs must be full, unshortened, and tested for accessibility
- Include access date for web sources where content may change
- For paywalled sources, note the access method (e.g., "via institutional subscription")
- Never cite "anonymous source" without explaining the reason for anonymity
