# Tool Evaluation Log — Artemis Coder

## Purpose

Every tool, library, or service we adopt becomes part of our maintenance burden — forever, or until we rip it out. This document defines the evaluation process, scoring rubric, and decision template. No tool enters the Artemis stack without passing through this process.

## When to Evaluate

A formal evaluation is required when:
- The tool will be used in production (not just a local dev convenience)
- The tool introduces a new dependency category (our first message broker, our first vector database)
- The tool costs money beyond a free tier
- Multiple reasonable alternatives exist and the choice is non-obvious

Skipping evaluation is acceptable for: patch-level upgrades of existing tools, dev-only utilities with no production impact, and tools that are the de facto standard with no serious competitor (e.g., Git).

## Assessment Template

Copy this template and fill it out for every evaluation. Store completed evaluations in `vault/raw/tool-evaluations/` with the filename `YYYY-MM-DD-tool-name.md`.

```markdown
# Tool Evaluation: [Tool Name]

**Date:** YYYY-MM-DD
**Evaluator:** [Name]
**Decision:** [ADOPT / REJECT / DEFER]

## Summary
[One paragraph: what the tool does and why we're considering it.]

## Alternatives Considered
| Alternative | Why Rejected / Why Deferred |
|---|---|
| [Name] | [Reason] |
| [Name] | [Reason] |

## Scoring

Rate each dimension 1 (worst) to 5 (best). **Minimum passing score: 28/40.**

| Dimension | Score (1–5) | Notes |
|---|---|---|
| **Functional fit** — Does it solve our actual problem? | | |
| **DX / ease of use** — Is the API clean? Docs good? | | |
| **Performance** — Measured under realistic load | | |
| **Reliability & maturity** — Release history, bug frequency, community size | | |
| **Maintenance burden** — How much ongoing work to keep it running? | | |
| **Licensing & cost** — Open-source? Enterprise pricing reasonable? | | |
| **Ecosystem compatibility** — Plays well with our existing stack? | | |
| **Security posture** — CVEs, dependency health, supply-chain practices | | |
| **TOTAL** | /40 | |

## Build vs Buy Analysis
[For tools that could be built in-house: estimate build effort vs adoption cost over 2 years.]

## Proof of Concept Results
[What we built to validate the tool. Include code snippets, performance numbers, and surprises.]

## Risks & Mitigations
| Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|
| [Risk] | Low/Med/High | Low/Med/High | [Mitigation] |

## Migration Plan (if ADOPT)
[How we roll this out. Feature flags? Gradual rollout? Big-bang switch?]

## Re-evaluation Trigger
[What would cause us to revisit this decision? E.g., "If the project goes >6 months without a release."]
```

## Scoring Rubric Detail

### Functional Fit (1–5)
- **5:** Solves our problem exactly, no workarounds needed.
- **3:** Solves 80% of the problem; the remaining 20% requires acceptable workarounds.
- **1:** Requires significant rearchitecture to make it work.

### DX / Ease of Use (1–5)
- **5:** `pip install` or equivalent, API is intuitive, docs are excellent, first working prototype in under an hour.
- **3:** Works after reading docs carefully, some gotchas, prototype takes half a day.
- **1:** Requires reading source code, documentation is wrong or missing, prototype takes days.

### Maintenance Burden — Lower is Better (1–5)
- **5:** Set-and-forget. Upgrades are painless. No operational toil.
- **3:** Requires periodic attention (major version upgrades, config tuning, incident response).
- **1:** Demands constant babysitting. Every upgrade breaks something.

**Passing threshold:** Any dimension scoring 1 or 2 requires explicit justification and team lead sign-off, even if the total score exceeds 28.

## Build vs Buy Framework

For capabilities that could be built in-house, estimate honestly:

**Cost to build (person-weeks):**
- Add 50% buffer for testing, docs, and edge cases.
- Add 20% per year for ongoing maintenance.
- Multiply by fully-loaded developer cost.

**Cost to buy (annual):**
- Licensing + hosting + integration effort (person-weeks) + training.
- Add 30% for vendor risk (price hikes, EOL, acquisition).

**Decision heuristic:**
- Build if: the capability is core differentiating IP, off-the-shelf options force unacceptable compromises, OR build cost < 30% of 2-year buy cost.
- Buy if: the capability is commodity infrastructure, the market has mature options, OR build cost > 70% of 2-year buy cost.
- In the grey zone (30–70%): defer to buy, with a commitment to re-evaluate in 12 months.

## Re-evaluation Cadence

Every adopted tool gets a lightweight re-evaluation on its adoption anniversary:
- Is the tool still actively maintained?
- Have our needs changed in a way that makes it a worse fit?
- Has a better alternative emerged?

Re-evaluations are one paragraph and a keep/replace recommendation. They go in the same directory as the original evaluation.

## Revision History
- 2026-06-10 — Initial publication
