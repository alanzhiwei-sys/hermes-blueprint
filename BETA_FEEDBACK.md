# Beta Feedback Program — Interview Script & Board Setup

## Purpose

Validate that Hermes Blueprint solves real problems for real people before commercial launch.

The beta is no longer just testing whether the installer works. It is testing whether customers feel **guided after installation** and whether the 30-day path helps Hermes become personalized to their business.

---

## Feedback Board Setup (Canny.io — Free Tier)

### Board Name
**Hermes Blueprint — Beta Feedback**

### Categories
1. **🐛 Bug Report** — Something broke, didn't install, gave wrong output
2. **💡 Feature Request** — Something missing that would make this 10x better
3. **❓ Confusing** — I didn't understand how to do X
4. **✅ Win** — This saved me time / made me money / impressed someone
5. **🔄 Workflow** — I use it differently than intended, here's how
6. **🧭 Onboarding Path** — Feedback on Day 0 / Day 7 / Day 30 guidance

### Board Welcome Message
```
Welcome to the Hermes Blueprint beta! 🎉

This board is where we collect real feedback from real users. Be honest.
Be brutal if needed. The only bad feedback is silence.

What to share:
- What worked immediately
- What was confusing
- Whether the 30-day path made you feel guided
- What Hermes still doesn't understand about your business
- What almost made you quit
- What would make you pay

Your feedback directly shapes what ships next.
```

### Feedback Link
Place this in the product:
```
📣 Help shape Hermes Blueprint → [Share Feedback](https://hermes-blueprint.canny.io)
```

---

## Beta Interview Script (15 min)

### Minute 0-2: Warm-Up — Don't Skip

**Goal:** Make them comfortable giving honest feedback. They're talking to the person who built this, so they may pull punches.

"Thanks for doing this. Quick context: this is pre-launch, you're one of the first users. Nothing you say will offend me — I need to know if it works for people other than me. If something was confusing, useless, or underwhelming, tell me. That's the most valuable thing you can do."

### Minute 2-4: Installation Experience

1. "Walk me through your install. Where did you get stuck, even for a second?"
   - *Listen for:* terminal fear, API key confusion, Linux version issues
   - *Key data point:* Did they need help from a friend/Google?

2. "On a scale of 1-10, how confident were you that the install would work?"
   - *<6 = trust / credibility issue*
   - *Follow-up:* "What would have made you more confident?"

### Minute 4-7: Personalization Path

3. "After installation, did you understand what to do next?"
   - *This is the core 'that's it?' test.*
   - *If no:* Ask what screen, file, or message would have helped.

4. "Did the personalization interview ask the right questions about your business?"
   - *Listen for:* questions too generic, too many, missing industry context
   - *Follow-up:* "What question should Hermes have asked but didn't?"

5. "Did `SUCCESS_PATH.md` make you feel there was a planned journey?"
   - *Goal:* validate Day 0 / Day 1 / Day 7 / Day 14 / Day 30 structure
   - *If weak:* Ask which day felt unnecessary or missing.

### Minute 7-10: First Use and Business Fit

6. "What's the FIRST useful thing you tried to do after setup?"
   - *Reveals:* what they thought the product was for
   - *If they didn't know what to do first → onboarding gap still exists*

7. "What worked immediately? What surprised you in a good way?"
   - *Collect wins for the landing page.*

8. "What did Hermes still not understand about your business?"
   - *This finds personalization gaps.*
   - *Ask for exact missing context, not vague impressions.*

9. "Did any profile feel unnecessary, confusing, or overlapping?"
   - *This tests whether 13 profiles feels valuable or overwhelming.*

### Minute 10-13: Customer Objections

Ask these directly:

10. "Honestly — do I need to become an IT person to use this?"
    - *Listen for:* whether guide + path reduced intimidation.

11. "What's the actual monthly running cost on top of the one-time fee?"
    - *Did they understand LLM usage pricing?*

12. "Can this actually generate documents/workflows for your industry, or do you spend 15 minutes fixing what the AI wrote?"
    - *Key metric:* time saved vs editing burden.

13. "If you were recommending this to someone in your industry, what would you tell them?"
    - *Word-of-mouth potential. Capture their wording.*

14. "What would make you NOT recommend this?"
    - *Hardest question. Ask it last. Don't let them dodge.*

### Minute 13-15: The Money Question

15. "If this were $149 one-time, would you pay for it today?"
    - *YES → "What made it worth it?"*
    - *NO → "What price would feel fair?"*
    - *MAYBE → "What would need to change for it to be a yes?"*

16. "Would the Day 0 / Day 7 / Day 30 guided path make you more willing to pay compared to just an installer?"
    - *This validates the new product positioning.*

17. "What's ONE thing we could add that would make you pay double?"
    - *Reveals premium features they'd actually pay for.*

### Closing

"Last question: can I quote any of what you said today on the website? Anonymously or with your business name — whatever you prefer."

Collect:
- ✓ Permission — yes/no/anonymous
- ✓ Best quote from the conversation
- ✓ Permission to follow up in 2 weeks
- ✓ Whether they completed Day 0 and Day 7 path

---

## Beta Success Criteria — 2-Week Checkpoint

| Metric | Threshold | Current |
|---|---:|---:|
| Beta signups | ≥ 10 | 0 |
| Completed installs | ≥ 5 | 0 |
| Completed personalization interviews | ≥ 5 | 0 |
| Users who opened `SUCCESS_PATH.md` | ≥ 5 | 0 |
| Users who completed Day 7 review | ≥ 3 | 0 |
| Active users after 2 weeks | ≥ 3 | 0 |
| Feedback interviews completed | ≥ 5 | 0 |
| Unprompted "I would pay" | ≥ 1 | 0 |
| Critical bugs unresolved | 0 | 0 |
| Support hours/week | ≤ 5 | 0 |

---

## What to Do with Feedback

### Immediate — Same Day
- **Bug reports** → fix, push update, notify user
- **Confusion reports** → update USER_GUIDE.md, README, FAQ, or installer text
- **Onboarding gaps** → update `personalization-interview.sh` or `SUCCESS_PATH.md`

### Weekly
- **Feature requests** → rank by frequency, add top 3 to roadmap
- **Wins** → collect for testimonials page
- **Repeated missing context** → add to personalization interview questions

### End of Beta
- Publish a "What We Learned" post on GitHub
- Decide Go/No-Go for commercial launch based on success criteria
- Decide whether the 30-day onboarding path is strong enough to justify Pro/Foundry pricing

---

## Beta Offer

**For the first 10 beta users:**
- Kit tier at 50% off → $75 SGD instead of $149
- In exchange for:
  1. Install within 48 hours
  2. Complete the personalization interview
  3. Use the Day 0 to Day 7 path
  4. One 15-minute feedback call using this script

**For everyone else during beta:**
- Open-source core free on GitHub
- Kit at full price ($149)
- No Pro/Foundry during beta unless manually approved

---

## Core Beta Question

The most important question is:

> Did Hermes Blueprint feel like a guided AI business OS, or just a pile of scripts and profiles?

If users still feel "that's it?", the product is not ready.

---

*This script is alive — update it after every 3 interviews based on what you learn.*
