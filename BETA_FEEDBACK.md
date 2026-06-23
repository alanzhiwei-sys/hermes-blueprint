# Beta Feedback Program — Interview Script & Board Setup

## Purpose

Validate that Hermes Blueprint solves real problems for real people before commercial launch.

The beta is no longer just testing whether the installer works. It is testing whether customers feel **guided after installation**, whether the **setup path matches their confidence level**, and whether the **First Business Win wizard** helps them create a usable business artifact within 48 hours — before any sales conversation.

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
- Whether the setup path matched your confidence level
- Whether the First Business Win wizard helped you create a usable artifact
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

### Minute 7-10: First Business Win

6. "Did you complete the First Business Win wizard and create an artifact?"
   - *This is the core value test.*
   - *If no:* "What stopped you — was it unclear what to pick, unclear how to use it, or not relevant to your business?"
   - *If yes:* "What artifact did you choose and did you actually use it in real work?"

7. "Did the First Business Win wizard make you feel there was immediate value, or did it feel like forced onboarding?"
   - *Listen for:* whether they perceived the wizard as useful guidance or busywork.

### Minute 10-13: First Use and Business Fit

8. "What's the FIRST useful thing you tried to do after setup?"
   - *Reveals:* what they thought the product was for
   - *If they didn't know what to do first → onboarding gap still exists*

9. "What worked immediately? What surprised you in a good way?"
   - *Collect wins for the landing page.*

10. "What did Hermes still not understand about your business?"
   - *This finds personalization gaps.*
   - *Ask for exact missing context, not vague impressions.*

11. "Did any profile feel unnecessary, confusing, or overlapping?"
   - *This tests whether 13 profiles feels valuable or overwhelming.*

### Minute 13-16: Customer Objections

Ask these directly:

12. "Did the setup path (DIY/Guided) match your confidence level? Would a different path have been better?"

13. "Honestly — do I need to become an IT person to use this?"
    - *Listen for:* whether guide + path reduced intimidation.

14. "What's the actual monthly running cost on top of the one-time fee?"
    - *Did they understand LLM usage pricing?*

15. "Can this actually generate documents/workflows for your industry, or do you spend 15 minutes fixing what the AI wrote?"
    - *Key metric:* time saved vs editing burden.

16. "If you were recommending this to someone in your industry, what would you tell them?"
    - *Word-of-mouth potential. Capture their wording.*

17. "What would make you NOT recommend this?"
    - *Hardest question. Ask it last. Don't let them dodge.*

### Minute 16-18: The Money Question

18. "If this were $149 one-time, would you pay for it today?"
    - *YES → "What made it worth it?"*
    - *NO → "What price would feel fair?"*
    - *MAYBE → "What would need to change for it to be a yes?"*

19. "Would the First Business Win wizard + 30-day guided path make you more willing to pay compared to just an installer?"
    - *This validates the first-win activation model.*

20. "What's ONE thing we could add that would make you pay double?"
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
| Users who completed First Business Win wizard | ≥ 5 | 0 |
| Users who created a usable artifact within 7 days | ≥ 3 | 0 |
| Users who opened `SUCCESS_PATH.md` | ≥ 5 | 0 |
| Users who completed Day 7 review | ≥ 3 | 0 |
| Active users after 2 weeks | ≥ 3 | 0 |
| Feedback interviews completed | ≥ 5 | 0 |
| Unprompted "I would pay" | ≥ 1 | 0 |
| Users who said setup path matched confidence | ≥ 4 | 0 |
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

| Beta Path | Price (SGD) | What's Included |
|---|---|---|
| **DIY Beta Kit** | $49-99 (vs $149) | Self-install + First Business Win wizard + 30-day success path + all profiles/scripts/docs |
| **Guided Beta** | $299-499 (vs $599) | Guided setup call + install verification + first-win selection + Day 7 review + 30-day support |
| **Foundry Beta** | $799-999 (vs $999) | Done-with-you setup + 3 custom profiles + Day 30 ROI review + 90-day support (1 slot only) |

In exchange for:
1. Install within 48 hours
2. Complete the personalization interview
3. Use the First Business Win wizard
4. Create one usable artifact within 7 days
5. One 15-minute feedback call using this script

**For everyone else during beta:**
- Open-source core free on GitHub
- Kit at full price ($149)
- No Pro/Foundry during beta unless manually approved

---

## Core Beta Question

The most important question is:

> Did Hermes Blueprint help you create one usable business artifact? Did the setup path match your confidence? Did it feel like a guided AI workflow system, or just a pile of scripts and profiles?

If users can't name one thing they created and used, the product is not ready.

---

*This script is alive — update it after every 3 interviews based on what you learn.*
