# Architecture Patterns — Artemis Coder

## Decision Framework

Architecture decisions at Artemis follow a simple rule: **choose the simplest pattern that satisfies the non-functional requirements you actually have, not the ones you might have someday.** Premature architectural complexity is technical debt with interest.

Every architecture decision document (ADD) must answer three questions:
1. What problem does this pattern solve that a simpler pattern doesn't?
2. What new problems does this pattern introduce?
3. What's the migration path if we outgrow this decision?

## Monolith vs Microservices

**Default choice: modular monolith.** Start here. Split only when you have concrete evidence, not a hunch.

### Modular Monolith

**Use when:**
- Team size ≤ 15 developers
- Domain boundaries are still emerging or shifting
- Deployment coordination overhead outweighs scaling benefits
- You need strong transactional consistency across features

**Implementation:**
- Enforce module boundaries at the package level (Python: namespace packages; Node: workspace packages).
- Modules communicate through well-defined internal APIs — no circular imports, no reaching into another module's private internals.
- Shared kernel for cross-cutting concerns (logging, auth, config). Keep it small — if it grows beyond 5% of the codebase, you're probably leaking domain logic into it.

**Signals it's time to split:**
- Two modules have different deployment cadences (one ships weekly, the other ships quarterly)
- Two modules need independent scaling (one handles 10 req/s, the other handles 10,000 req/s)
- Two different teams own modules and merge conflicts are frequent
- One module's failure mode regularly takes down another module

### Microservices

**Only after the modular monolith proves insufficient.** When you do split:

- **One service = one bounded context.** Never split by technical layer (don't have a "models service" and a "views service").
- **Each service owns its data store.** No shared databases between services. If Service B needs data from Service A, it calls Service A's API or consumes its events.
- **Asynchronous communication first.** Services communicate via events (pub/sub or message broker). Synchronous HTTP calls create coupling and cascading failures.
- **Contract testing required.** Every service that exposes an API must have contract tests. Consumers write the contracts.

## Event-Driven Architecture

**Use when:** Multiple services need to react to the same business event, or when you need loose coupling between producers and consumers.

**Event schema rules:**
- Events are immutable facts about the past: `OrderPlaced`, not `PlaceOrder`.
- Every event includes: `event_id` (UUID), `event_type`, `timestamp` (ISO 8601 UTC), `aggregate_id`, `version`, and `payload`.
- Events are backward-compatible. Add fields, never remove or rename them. Use a schema registry.

**Error handling:**
- Failed event processing enters a **dead letter queue** (DLQ). Don't just retry forever.
- DLQ messages are inspected by a human or an automated triage script within 24 hours.
- Idempotency is the consumer's responsibility. Always design consumers to handle duplicate events gracefully.

## API Design

**REST for CRUD, RPC for operations.** REST maps naturally to resource lifecycle. When the operation doesn't fit a resource model ("send password reset email"), use RPC-style endpoints (`POST /auth/send-reset-email`).

**REST conventions:**
- Plural nouns: `/users`, `/orders`, not `/user`, `/getOrders`
- Nested resources max 2 deep: `/users/{id}/orders/{order_id}` — never `/users/{id}/orders/{order_id}/items/{item_id}/...`
- Pagination: cursor-based for large collections (`?cursor=abc&limit=50`), offset-based only for small, stable collections
- Versioning: URL prefix (`/v1/users`). Never header-based versioning — it's invisible and hard to debug.
- Status codes: use the full spectrum. Don't return 200 with an error body.

**Error response format:**
```json
{
  "error": {
    "code": "INSUFFICIENT_FUNDS",
    "message": "Account balance is below the minimum required.",
    "details": { "balance": "12.50", "required": "25.00" }
  },
  "request_id": "req_abc123"
}
```

## Database Conventions

- **Migrations:** Every schema change is a migration file. Never apply DDL manually. Migration files are numbered, reversible, and tested in CI.
- **Naming:** `snake_case` for tables and columns. Plural table names (`users`, `orders`). Primary keys are always `id` (UUID v4, never auto-increment integers for entity tables).
- **Indexes:** Add indexes based on query patterns, not guesswork. Every new index must include a comment explaining which query it serves.
- **No ORM magic:** ORMs are fine for simple CRUD. For complex queries, write raw SQL in a repository layer. The ORM should never generate queries you haven't read and understood.

## Caching Strategy

**Cache only when you have a measured problem.** Premature caching hides performance bugs and adds invalidation complexity.

**Cache hierarchy:**
1. **Application-level:** In-memory LRU cache for hot configuration data (TTL: 5 minutes). No more than 1,000 entries.
2. **Distributed:** Redis for shared cache across instances. Use for expensive queries, rate-limiting counters, session data.
3. **CDN/Edge:** For static assets and fully public, rarely-changing API responses.

**Cache invalidation rules:**
- Every cache entry must have a TTL. No eternal caches.
- The service that writes the data is responsible for invalidating related caches.
- When in doubt during an incident, flush the cache. Consistency beats performance during outages.

## Revision History
- 2026-06-10 — Initial publication
