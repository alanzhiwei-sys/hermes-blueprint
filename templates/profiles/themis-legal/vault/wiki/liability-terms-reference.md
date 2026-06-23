# Liability Terms Reference — [YOUR_BUSINESS_ALT]

**Jurisdiction:** Singapore | **Profile:** Themis-Legal | **Last Updated:** 2026-06-10

---

## 1. [YOUR_BUSINESS_ALT] Terms of Service — Recommended Structure

Every [YOUR_BUSINESS_ALT] engagement should be governed by a Terms of Service (ToS) document incorporated by reference into the main contract. The ToS should cover:

1. **Definitions** — "System," "Hardware," "Software," "Services," "Client"
2. **Scope of Services** — design, supply, installation, configuration, handover training
3. **Hardware Warranty** — manufacturer warranty pass-through + installer workmanship warranty
4. **Software & Cloud Services** — third-party dependency disclaimer (Tuya, Aqara, Apple HomeKit)
5. **Limitation of Liability** — cap, carve-outs, exclusions
6. **Service-Level Expectations** — response times, not guarantees
7. **Force Majeure**
8. **Data Protection** (cross-reference PDPA Compliance Guide)
9. **Dispute Resolution & Governing Law** — Singapore

---

## 2. Warranty Clause Templates

### Hardware Warranty (Standard)

> *"[YOUR_BUSINESS_ALT] warrants that all hardware supplied shall be free from manufacturing defects for a period of twelve (12) months from the date of installation (the 'Hardware Warranty Period'). During the Hardware Warranty Period, [YOUR_BUSINESS_ALT] shall, at its option, repair or replace any defective hardware at no cost to the Client, excluding labour for removal/reinstallation where the defect is attributable to the manufacturer. This warranty is in addition to and does not limit any manufacturer's warranty that may apply."*

### Installation Workmanship Warranty

> *"[YOUR_BUSINESS_ALT] warrants that all installation services shall be performed in a professional and workmanlike manner for a period of twelve (12) months from the date of practical completion (the 'Workmanship Warranty Period'). Defects in installation workmanship reported in writing during this period shall be rectified within fourteen (14) calendar days at [YOUR_BUSINESS_ALT]'s sole cost."*

### Clause → Risk → Revision: No Distinction Between Hardware and Workmanship

- **Clause:** _"[YOUR_BUSINESS_ALT] warrants the system for 12 months."_
- ⚡ **MEDIUM** — Ambiguous. Does this cover hardware or installation? Who bears labour cost for a manufacturer defect? Opens door to disputes.
- **Revision:** Separate warranties as above. Hardware = pass-through to manufacturer ([YOUR_BUSINESS_ALT] handles the RMA process but does not bear the manufacturer's liability). Workmanship = [YOUR_BUSINESS_ALT] bears full labour and materials for installation defects.

---

## 3. Limitation of Liability — The Cap & Carve-Outs

### Why This Matters

Smart home systems control locks, cameras, and sensors. A system failure can mean a door that won't lock or a security camera that goes dark. Your liability clause is the most scrutinised provision in any claim.

### Recommended Language

> *"To the maximum extent permitted by Singapore law:*
>
> **(a) Cap.** *[YOUR_BUSINESS_ALT]'s total aggregate liability to the Client for any and all claims arising out of or in connection with this Agreement shall not exceed the total fees paid by the Client under this Agreement.*
>
> **(b) Exclusion of Indirect Loss.** *[YOUR_BUSINESS_ALT] shall not be liable for any indirect, special, or consequential loss, including but not limited to loss of use, loss of data, loss of business, or loss of profit, howsoever caused.*
>
> **(c) Carve-Outs.** *Nothing in this clause excludes or limits [YOUR_BUSINESS_ALT]'s liability for: (i) death or personal injury caused by negligence; (ii) fraud or fraudulent misrepresentation; (iii) any liability that cannot be excluded or limited under Singapore law.*"

### Clause → Risk → Revision: Uncapped Liability

- **Clause:** (no limitation of liability clause)
- ⚠️ **HIGH** — Unlimited liability exposure. A single claim for a failed smart lock resulting in a burglary could exceed many times the contract value.
- **Revision:** Insert the cap language above. A fee-paid cap (total contract sum) is the most defensible position in Singapore for SME service providers. Note that under the Unfair Contract Terms Act (UCTA, Cap. 396), limitation clauses in standard-form contracts are subject to a reasonableness test — the fee-paid cap is generally reasonable for service contracts.

### Clause → Risk → Revision: Cap Too High Relative to Contract Value

- **Clause:** _"Liability limited to SGD 50,000."_ (on a SGD 3,000 contract)
- ⚡ **MEDIUM** — A flat dollar cap independent of contract value creates disproportionate exposure on small jobs.
- **Revision:** Tie the cap to fees paid. On a SGD 3,000 job, exposure is SGD 3,000, not SGD 50,000.

---

## 4. Hardware Failure Responsibility

### The Third-Party Problem

[YOUR_BUSINESS_ALT] is an integrator — you install hardware manufactured by Aqara, Tuya, Yale, etc. Your ToS must clearly state that:

- **Manufacturer defects:** [YOUR_BUSINESS_ALT] facilitates warranty claims with the manufacturer but does not manufacture the hardware. The remedy is repair or replacement of the hardware unit.
- **Interoperability:** [YOUR_BUSINESS_ALT] does not guarantee that third-party hardware will remain compatible with future software updates (Apple HomeKit, Google Home, Amazon Alexa).
- **End-of-life / discontinuation:** [YOUR_BUSINESS_ALT] is not liable if a manufacturer discontinues a product line or ceases cloud support.

### Clause → Risk → Revision: Implied Guarantee of Ongoing Functionality

- **Clause:** (silence on third-party dependency)
- ⚠️ **HIGH** — A client may reasonably expect a "smart home" to remain smart indefinitely. If Tuya deprecates an API or Aqara drops firmware support, you may face claims.
- **Revision:** _"The Client acknowledges that the System incorporates third-party hardware and cloud services not controlled by [YOUR_BUSINESS_ALT]. [YOUR_BUSINESS_ALT] does not warrant the continued availability, compatibility, or functionality of any third-party product or cloud service. [YOUR_BUSINESS_ALT] shall use reasonable efforts to identify and recommend alternative solutions if a critical third-party component is discontinued, but shall not be liable for the unavailability of such component."_

---

## 5. Service-Level Expectations (Not Guarantees)

[YOUR_BUSINESS_ALT] is not a 24/7 security monitoring company. Set expectations clearly:

| Service Level | Expectation | Response Time |
|--------------|-------------|---------------|
| Emergency (lock failure, security breach) | Best-effort phone support | Within 4 hours during business hours |
| Standard (device offline, app issue) | Remote diagnosis | Within 1 business day |
| On-site visit (if remote fix fails) | Scheduled visit | Within 3 business days |
| After-hours / weekend | Not guaranteed | Best-effort; surcharge may apply |

These are **targets, not guarantees**. Do not use "warranty" or "guarantee" language for response times.

### Clause → Risk → Revision: "24/7 Support" Promise

- **Clause:** _"[YOUR_BUSINESS_ALT] provides 24/7 support for all installations."_
- ⚠️ **HIGH** — Creates a binding commitment that is impractical for a small business. One missed 3 AM call = breach of contract.
- **Revision:** _"[YOUR_BUSINESS_ALT] provides support during business hours (Monday–Friday, 9:00 AM–6:00 PM SGT, excluding public holidays). Emergency telephone support outside business hours is provided on a best-effort basis and may be subject to additional charges."_

---

## 6. Force Majeure

### Standard Clause

> *"Neither party shall be liable for any failure or delay in performance caused by circumstances beyond its reasonable control, including but not limited to: acts of God, fire, flood, epidemic, government restriction, supply chain disruption, or failure of third-party cloud infrastructure. The affected party shall notify the other within three (3) calendar days and resume performance as soon as reasonably practicable."*

### Clause → Risk → Revision: No Force Majeure Clause

- **Clause:** (no force majeure provision)
- ⚡ **MEDIUM** — Without it, a delay caused by a global chip shortage or cloud outage could be treated as a breach.
- **Revision:** Insert the standard clause above. Ensure it covers both hardware supply disruption and cloud service outages — these are the two most likely force majeure events for a smart home business.
