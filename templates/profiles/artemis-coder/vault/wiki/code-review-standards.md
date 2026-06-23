# Code Review Standards — Artemis Coder

## Philosophy

Code review is the team's primary quality gate — and its primary teaching tool. A good review catches bugs, yes, but a great review makes the author a better developer. Every review comment should either prevent a bug, improve readability, or teach something. If it does none of these, it's noise — delete it before submitting.

## PR Size Guidelines

**The 400-line rule:** PRs exceeding 400 lines of changed code (excluding generated files, lockfiles, and test fixtures) are automatically flagged. Break them into smaller, logically coherent PRs. Large PRs get superficial reviews because no reviewer can hold 400+ lines of context in their head.

**Exceptions (require justification in the PR description):**
- Mechanical refactors (rename across codebase, typing additions)
- Generated code (OpenAPI clients, protobuf stubs)
- Deletions (removing a deprecated module)
- Initial project scaffolding

## Review Checklist

Every reviewer must verify these items before approving. Use the checklist as a comment template:

```
## Review Checklist

### Correctness
- [ ] Logic is correct for the happy path
- [ ] Edge cases are handled (null/empty inputs, boundary values, concurrent access)
- [ ] Error states return appropriate codes and messages — no swallowed exceptions
- [ ] Security: no leaked secrets, no SQL injection, no unsanitised user input in HTML/headers

### Design
- [ ] The solution is the simplest thing that could possibly work
- [ ] New abstractions earn their complexity — no premature generalisation
- [ ] Functions do one thing and are named for that thing
- [ ] No duplication with existing code (check the codebase before adding helpers)

### Testing
- [ ] Happy-path tests exist and pass
- [ ] At least one sad-path test per error condition
- [ ] Tests are deterministic — no flaky sleeps, no external network calls in unit tests
- [ ] Test names describe the scenario, not the implementation: `test_returns_404_for_deleted_user`, not `test_get_user_2`

### Maintainability
- [ ] Comments explain "why," not "what" — the code already says what
- [ ] TODO comments include a ticket number: `TODO(ART-123): handle rate limiting`
- [ ] Logging uses appropriate levels: DEBUG for diagnostics, INFO for key events, WARN for recoverable issues, ERROR for things that need attention
- [ ] No dead code, no commented-out blocks, no debug prints
```

## Comment Conventions

**Review comments use labels for clarity:**

| Label | Meaning | Author Action |
|---|---|---|
| `[blocker]` | Must be fixed before merge | Fix before re-requesting review |
| `[nit]` | Stylistic preference, author discretion | Fix or reply "won't fix" with brief reason |
| `[question]` | Reviewer is genuinely asking, not prescribing | Answer the question |
| `[praise]` | This is well done — note it for the team | No action (celebrate internally) |
| `[learn]` | Teaching moment, not a bug | Read and learn; no fix needed unless you choose to |

**Review tone rules:**
- Questions over commands: "What happens if this list is empty?" beats "This will break on empty lists."
- Assume competence: The author had a reason. Ask for it before prescribing a different approach.
- Praise publicly, critique privately (within the PR thread is private enough).

## Approval Criteria

A PR can be approved when:

1. **All CI checks pass** (lint, type-check, tests, build). No exceptions without a documented justification in the PR.
2. **The review checklist is fully checked** by at least one reviewer.
3. **All `[blocker]` comments are resolved.** Nits and questions do not block approval.
4. **At least one approving review** from a team member. The author cannot approve their own PR.
5. **The PR is under 400 lines** or has a documented exception.
6. **Breaking changes** are flagged in the PR description with migration instructions.

## Post-Merge

After merge:
- The author is responsible for verifying the change in the staging environment within 1 business day.
- If the change introduces a regression, the author reverts first, debugs second. No forward-fixing on a broken main branch.
- Delete the feature branch after merge. Stale branches are cleaned up automatically by a weekly CI job.

## Review Speed Expectations

| PR Size | Target First Response | Target Resolution |
|---|---|---|
| <100 lines | Within 2 business hours | Same day |
| 100–400 lines | Within 4 business hours | Within 24 hours |
| >400 lines (exception) | Within 1 business day | Within 48 hours |

If you can't hit the response window, reassign yourself in the PR and notify the author. A slow "I'll get to it tomorrow" is better than radio silence.

## Revision History
- 2026-06-10 — Initial publication
