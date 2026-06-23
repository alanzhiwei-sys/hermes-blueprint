# PDPA Compliance Guide for Smart Home Businesses

**Jurisdiction:** Singapore (PDPA 2012, as amended) | **Profile:** Themis-Legal | **Last Updated:** 2026-06-10

---

## 1. Why PDPA Matters for Smart Home Installers

As a smart home business ([YOUR_BUSINESS_ALT]), you routinely collect some of the most sensitive data in a client's life. The Personal Data Protection Act (PDPA) applies the moment you collect, store, or process any data that can identify an individual. Enforcement by the PDPC includes financial penalties up to 10% of annual turnover.

---

## 2. Client Data Categories — What You're Collecting

### Category A: Personal Data (Standard PDPA)

| Data Type | Collection Context | Risk |
|-----------|-------------------|------|
| Full name, NRIC | Contract, warranty registration | ⚡ MEDIUM |
| Mobile number, email | Contact, WhatsApp coordination | ℹ️ LOW |
| Residential address | Site visit, delivery, installation | ⚡ MEDIUM |

### Category B: Sensitive Installation Data (Elevated Risk)

| Data Type | Collection Context | Risk |
|-----------|-------------------|------|
| Wi-Fi SSID & password | Smart device provisioning | ⚠️ HIGH |
| Camera placements & feeds | CCTV installation | ⚠️ HIGH |
| Home network topology maps | Network setup, VLAN config | ⚠️ HIGH |
| Smart lock PINs / access codes | Lock programming | ⚠️ HIGH |
| Floor plan with device locations | System design | ⚡ MEDIUM |

### Clause → Risk → Revision: Storing Wi-Fi Passwords in Plain Text

- **Clause (your current practice?):** Wi-Fi credentials stored in project notes, shared via WhatsApp to technicians.
- ⚠️ **HIGH** — PDPA requires "reasonable security arrangements." Plain-text storage on shared messaging platforms is a likely breach. If leaked, an attacker gains network access to the client's entire smart home.
- **Revision:** _"All client network credentials shall be stored encrypted at rest (AES-256 minimum). Access shall be granted on a need-to-know basis only to technicians actively provisioning devices. Credentials shall be deleted from technician devices within 48 hours of project completion."_

---

## 3. Consent Requirements

### When You Need Consent

Under the PDPA, you must obtain consent **before** collecting, using, or disclosing personal data. The consent must be:

- **Informed** — the client understands what you're collecting and why
- **Specific** — not buried in fine print
- **Revocable** — the client can withdraw at any time with reasonable notice

### Recommended: [YOUR_BUSINESS_ALT] Data Consent Form

Add this language to your contract or a standalone consent schedule:

> *"By signing, you consent to [YOUR_BUSINESS_ALT] collecting and using the following data solely for the purpose of installing, configuring, and maintaining your smart home system: (a) home Wi-Fi network name and password; (b) camera placement locations and viewing angles; (c) smart lock access codes; (d) floor plan with device location annotations. This data will not be shared with any third party except as necessary for warranty support, and will be deleted within [30] days of our engagement ending unless you request earlier deletion."*

### Clause → Risk → Revision: Implied/Bundled Consent

- **Clause:** _"By engaging us, you agree to our privacy policy available on our website."_
- ⚠️ **HIGH** — PDPC has explicitly rejected bundled consent for sensitive purposes. A generic privacy policy link does not satisfy the consent obligation for Wi-Fi passwords and camera data.
- **Revision:** Use an explicit, standalone consent schedule (as above) with a separate signature or checkbox for sensitive installation data categories.

---

## 4. Data Breach Notification Timeline

### Mandatory Timeline (PDPA Sections 26C–26E)

| Trigger | Action Required | Timeline |
|---------|----------------|----------|
| Suspected breach | Internal assessment | Reasonably practicable (no delay) |
| **Notifiable breach confirmed** | Notify PDPC | **Within 3 calendar days** |
| Notifiable breach with significant harm risk | Notify affected individuals | **As soon as practicable** (same day recommended) |

### What Is "Notifiable"?

A data breach is notifiable if it:
- Results in, or is likely to result in, **significant harm** to affected individuals; OR
- Is of a **significant scale** (≥500 individuals affected).

For [YOUR_BUSINESS_ALT]: if a technician's phone containing 20+ clients' Wi-Fi passwords and camera feeds is lost — this is likely notifiable given the nature of the data.

### Clause → Risk → Revision: No Breach Response Plan

- **Clause:** (no data breach procedure in company policy)
- ⚠️ **HIGH** — PDPC can impose financial penalties for failing to notify. Lack of a documented plan virtually guarantees a delayed response.
- **Revision:** Implement a written Data Breach Response Plan covering: (1) containment — remotely wipe/lock affected devices; (2) assessment — determine if breach is notifiable within 24 hours; (3) notification — PDPC within 3 calendar days, affected clients as soon as practicable; (4) remediation — password resets, lock re-keying at [YOUR_BUSINESS_ALT]'s cost.

---

## 5. Retention Limits

### Data Retention Policy

| Data Type | Retention Period | Disposal Method |
|-----------|-----------------|-----------------|
| Client name, contact, address | Duration of warranty + 1 year | Secure deletion from CRM |
| Wi-Fi credentials | Until device provisioning complete (max 30 days post-project) | Delete from all devices & servers |
| Camera placement records | Duration of warranty | Secure deletion |
| Smart lock codes | Delete immediately after client takes possession | Not retained beyond handover |
| Floor plans with device map | Duration of warranty | Secure deletion |

### Principle: Delete When Purpose Is Fulfilled

PDPA Section 25 requires that personal data must not be kept longer than necessary. Once the smart home system is commissioned and the client has accepted handover, there is no ongoing purpose for retaining Wi-Fi passwords or access codes.

### Clause → Risk → Revision: Indefinite Retention

- **Clause:** (no data retention or deletion policy)
- ⚡ **MEDIUM** — Retaining credentials indefinitely creates unnecessary breach exposure and violates the retention limitation obligation.
- **Revision:** Adopt the retention schedule above in a written Data Protection Policy, communicated to all staff handling client data.

---

## 6. DNC (Do Not Call) Registry Rules

If [YOUR_BUSINESS_ALT] sends marketing messages (SMS, WhatsApp broadcast, voice calls) to Singapore numbers, the **DNC Registry** applies:

| Obligation | Detail |
|-----------|--------|
| Check DNC Registry | Before every marketing campaign (valid for 30 days per check) |
| Facility to opt out | Every message must include an opt-out; honour within a reasonable time |
| Consent exception | Existing customers (ongoing relationship) — limited marketing about similar products is exempt but must still honour opt-outs |
| Penalty | Up to SGD 10,000 per message for non-compliance |

### ⚠️ HIGH Risk: WhatsApp Broadcasts Without DNC Check

If you collect client numbers during renovation and later use them for marketing without checking the DNC Registry, you are in breach. This is one of the most common PDPA violations in the SME sector.

**Revision:** _"Before any marketing message is sent to a Singapore telephone number, the sender shall (a) check the number against the current DNC Registry; (b) confirm the recipient has given clear consent or falls within the ongoing-relationship exemption; and (c) include an opt-out mechanism (e.g., 'Reply STOP to unsubscribe'). Records of these checks shall be retained for 24 months."_
