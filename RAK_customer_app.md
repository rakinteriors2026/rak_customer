# RAK Customer App — Development Prompt Playbook

Source: `RAK Customer App Action Plan.docx` (planning draft v1.0, prepared by Santo Martin for RAK Interiors).
Purpose: turn that action plan into ready-to-paste prompts for building the Flutter customer app in Cursor, module by module, in the stack you already use (Clean Architecture, BLoC/Cubit, GetIt, TDD).

This file is a working tool, not a spec. The action plan calls out many open decisions (SKU model, phase/progress rules, payment provider, publishing owners). Where a prompt below depends on one of those, it is flagged **[DECISION NEEDED]** — resolve it (or mock it explicitly) before running that prompt, so the AI doesn't silently invent business rules.

---

## 0. How to use this file

1. Work top to bottom, module by module — the sequence mirrors the action plan's release gates (§9).
2. Before each module's prompt, confirm the "Depends on" line is done and the "Backend contract" is either live on staging or explicitly mocked.
3. Paste the prompt block into Cursor/Claude as-is, then append any project-specific context (exact package names, folder root, existing files) it should read first.
4. Every prompt asks for tests alongside code — keep TDD discipline even when moving fast; the action plan's acceptance tests (§10) are release-blocking, not optional polish.
5. Do not let a prompt hardcode a business rule that's still open (progress calculation, phase list, delivery areas, refund policy). Ask it to take those as configurable/injected values instead.

---

## 1. Project summary (from the action plan)

One Flutter customer app, two connected areas:

- **My Projects** — existing/prospective clients track an ERP-linked interior project: phase, progress, timeline, published site updates/photos, payments/balance, documents, approved designs, support queries, push notifications.
- **Shop** — new e-commerce extension: browse catalogue → check delivery/installation availability → cart → checkout → pay → track order → cancel/return where eligible. Bespoke items go through "Request a Quote" instead of checkout.

Key constraints to carry into every prompt:

- A buyer can exist with zero, one, or multiple linked projects. Buyer access must never require a project.
- All customer-facing endpoints are new wrappers around ERP/commerce data — never assume a customer route already exists just because an internal one does.
- The backend owns progress calculation, pricing, and payment confirmation. The app never computes or trusts these locally.
- Object-level ownership checks apply to every project, order, ticket, and file lookup — client A must never reach client B's data by editing an ID.

---

## 2. Architecture & conventions

Use this as the standing context block at the top of every feature prompt.

```
Stack: Flutter (null-safe), feature-based Clean Architecture.
State management: flutter_bloc (Cubit for simple screens, Bloc for multi-event flows).
DI: get_it + injectable (or manual get_it registration if injectable isn't set up).
Networking: dio, with an interceptor for auth headers, token refresh, and request IDs.
Models: freezed + json_serializable for DTOs and domain entities where useful.
Routing: go_router (or the project's existing router — confirm before generating routes).
Secure storage: flutter_secure_storage for tokens; nothing sensitive in shared_preferences.
Testing: TDD. bloc_test + mocktail for unit/bloc tests; integration_test for critical flows.
Error handling: a shared Failure/Either (dartz or a custom Result type) from data → domain → presentation.
Money: integer minor units + currency code, never double.
Timestamps: parse/display as UTC ISO-8601, convert to local for display only.
Pagination: opaque cursor, never offset/page number.
```

### Folder structure (per feature)

```
lib/
  core/
    network/          (dio client, interceptors, token refresh)
    di/                (get_it setup)
    error/             (Failure types, exception mapping)
    storage/           (secure storage wrapper)
    router/
    theme/
  features/
    auth/
      data/            (datasources, dto, repository_impl)
      domain/          (entities, repository interface, usecases)
      presentation/    (bloc/cubit, pages, widgets)
    projects/
    updates/
    finance/
    documents/
    designs/
    support/
    notifications/
    catalogue/
    cart/
    addresses/
    checkout/
    orders/
  shared/              (design system widgets, formatters, validators)
```

Each `features/<name>` module should be independently testable and only depend on `core/` and `shared/`.

---

## 3. Delivery sequence (from action plan §9)

Build strictly in this order — later modules assume earlier ones' auth/session and error-handling scaffolding exist.

| Phase        | Weeks | Modules                                                                    | Exit gate                                                           |
| ------------ | ----- | -------------------------------------------------------------------------- | ------------------------------------------------------------------- |
| Foundation   | —     | Core setup (§5.0 below): DI, networking, auth scaffolding, router, theming | —                                                                   |
| Tracking 1–2 | 1–2   | Auth/OTP, session, project selector                                        | G1: identity + project contracts on staging                         |
| Tracking 3–4 | 3–4   | Project overview, milestones/timeline, site updates/gallery                | G2: staff→customer publish flow with real data                      |
| Tracking 5–6 | 5–6   | Payments/balance, documents, designs, support, push                        | G3: finance fixtures, expiring links, routed ticket, event triggers |
| Tracking 7–8 | 7–8   | End-to-end QA, pilot hardening, store prep                                 | G4: full FR-CUST coverage, security sign-off                        |
| Commerce 1–2 | —     | Catalogue, variants, serviceability, cart                                  | C1: product/stock rules + admin ownership operational               |
| Commerce 3–4 | —     | Addresses, checkout, sandbox payment, orders                               | C2: transaction/concurrency/recovery tests pass                     |
| Commerce 5–6 | —     | Order tracking, cancellations, returns, refund status                      | C3: staff fulfilment + finance reconciliation verified              |
| Commerce 7–8 | —     | Pilot, recovery hardening, release                                         | C4: paid order through delivery/refund, business sign-off           |

Ship Tracking and Commerce behind **separate feature flags** so either can roll out to a pilot cohort independently.

---

## 4. Master prompt template

Reuse this skeleton for any module not explicitly covered below, or to extend one.

```
Context: [paste Section 2's architecture block]

Feature: <feature name>
Goal: <one paragraph, what the customer can do>
Depends on: <earlier modules/services this needs>

Backend contract (proposed, confirm against OpenAPI before trusting field names):
<paste the relevant endpoint table row(s) from Section 8>

Requirements:
- <functional requirements, from the FRD/action-plan row>
- <business rules that MUST be server-derived, never computed client-side>
- <ownership/authorization notes — is this "own data only"?>

Build:
1. domain/: entities + repository interface + usecases
2. data/: DTOs (freezed), datasource (dio calls), repository implementation, error mapping
3. presentation/: Bloc/Cubit with explicit states for loading/success/empty/error/unauthorized
4. UI: <screens/widgets needed>, including empty state and error state per Section 6
5. Tests: unit tests for usecases and repository, bloc tests for every state transition, and at least one widget test for the empty/error states

Do NOT:
- Hardcode business rules that are marked [DECISION NEEDED] — accept them as injected config/constants instead
- Compute progress, price, or payment status locally — display only what the server returns
- Cache or log tokens, OTP codes, or full document/photo URLs
```

---

## 5. Feature-by-feature prompts

### 5.0 Core setup (do this first, once)

Depends on: nothing. Backend contract: none yet (mock-friendly).

```
Set up the app foundation for a Flutter Clean Architecture project:
1. get_it + injectable service locator (or plain get_it) with a clear registerLazySingleton/registerFactory convention.
2. A dio HttpClient wrapped in core/network/: base URL from environment config (dev/staging/prod flavors), an auth interceptor that attaches the access token, and a token-refresh interceptor that retries once on 401 using POST /auth/refresh before forcing logout.
3. A shared Failure hierarchy (network, unauthorized, validation, notFound, conflict409, rateLimited429, unknown) mapped from dio exceptions and HTTP status codes.
4. flutter_secure_storage wrapper for access/refresh tokens and device ID, with a single `clearSession()` used on logout AND on account switch.
5. go_router setup with route guards: unauthenticated users can reach Home/Shop (browse) but are redirected to login before Checkout, My Projects, Account, or Support.
6. A design-system base (colors, typography, spacing) in shared/ that all feature UIs will reuse — keep it minimal for now.
7. Tests: unit tests for the token-refresh interceptor logic (success, refresh failure → forced logout, concurrent 401s only trigger one refresh) and for the Failure mapping.

Also read Section 10's isolation/identity acceptance scenarios now, and structure the interceptor and route guards so those scenarios are testable later (no shortcuts that would make cross-account data leak possible).
```

### 5.1 Authentication (OTP) — FR-CUST-01/02

Depends on: Core setup. Backend contract: `POST /auth/otp/request`, `POST /auth/otp/verify`, `POST /auth/refresh`, `POST /auth/logout`.

```
Implement the `auth` feature (phone + OTP login):

Flow: enter phone → POST /auth/otp/request (phone, purpose) → challenge_id, expires_at, resend_after → enter code → POST /auth/otp/verify (challenge_id, code) → access/refresh tokens + account → store securely → navigate based on account.capabilities (has_projects vs buyer_only).

Requirements:
- Enforce resend_after cooldown client-side (countdown UI) in addition to whatever the server enforces.
- Handle expired/incorrect/reused OTP with a generic error message — do not reveal whether the phone number itself is invalid or linked to a project (the backend intentionally returns generic responses; the UI should not add its own hints).
- On verify success, decide initial route: if account has authorised projects, land on My Projects; if buyer-only, land on Shop. Never require a project number to be typed to get in.
- Logout calls POST /auth/logout, clears the secure storage session, and returns to the unauthenticated Home/Shop browse state (not a dead end).
- No account ownership fields are ever sent from the client to establish identity — identity comes only from the verified token.

Build: domain/data/presentation per the master template.
UI: phone entry, OTP entry with resend countdown, generic error states, loading states.
Tests: full OTP happy path, expired code, resend-cooldown enforcement, token storage on success, and forced logout on refresh failure.
```

### 5.2 My Projects — overview & project selector — FR-CUST-03

Depends on: Auth. Backend contract: `GET /me`, `GET /me/projects`, `GET /projects/{id}`.

```
Implement the `projects` feature: overview list + detail.

Requirements:
- GET /me/projects returns only authorised, linked projects (cursor-paginated). If empty, show a clear "no linked project yet" state with a support/contact action — this is a valid, expected state for buyer-only accounts, not an error.
- If exactly one project, still show it via the same selector UI (don't special-case navigation) so adding a second project later needs no UI change.
- Project detail (GET /projects/{id}) shows phase code/label, progress_percent, target vs forecast handover date, and updated_at. If progress_percent is null, show "not yet available" — never compute or estimate it from photo count or elapsed time.
- {id} is always server-checked for ownership; a client-supplied project ID that isn't the caller's returns 403/404, not another user's data — write a test that asserts this at the repository/datasource level (mock a 403 and assert the UI shows an access-denied/not-found state, not stale cached data).

Build per master template. UI: project list/selector, project overview card (phase, progress, dates, "last updated" relative time).
Tests: empty state, single-project state, multi-project selector, null-progress rendering, 403-on-wrong-id handling.
```

### 5.3 Milestones & timeline — FR-CUST-04a

Depends on: Projects. Backend contract: `GET /projects/{id}/milestones`.

```
Implement the `projects` milestones/timeline sub-feature.

Requirements:
- Render milestones in stable order (use server-provided ordering/index, not client sort-by-date, since planned vs actual can differ).
- Each milestone has id, title, state, planned_at, completed_at (nullable), and an optional visible note. Distinguish "planned" vs "completed" visually; do not infer completion from today's date vs planned_at.
- [DECISION NEEDED] the actual phase/milestone list and weighting is owned by Project Operations — do not hardcode a fixed milestone list; render whatever the API returns, in the order given.

Build per master template. UI: vertical timeline widget with planned/completed states and an optional note.
Tests: ordering fidelity, planned-only milestone rendering, completed-with-note rendering, empty timeline state.
```

### 5.4 Site updates & photo gallery — FR-CUST-04

Depends on: Projects. Backend contract: `GET /projects/{id}/updates`, `POST /assets/{id}/access`.

```
Implement the `updates` feature (published site updates + photo gallery).

Requirements:
- GET /projects/{id}/updates returns only published notes/photos with event time, cursor-paginated. Internal/draft media must never appear — this is enforced server-side, but write a UI-level test asserting a draft-flagged item (if the mock ever returns one) is not rendered, as a safety net.
- Photo/file access is NOT a direct static URL. For each asset, call POST /assets/{id}/access to get a short-lived signed URL + expires_at immediately before display; re-request if expired_at has passed (e.g., user returns to a cached list after a long time). Never persist the signed URL beyond the session.
- Withdrawal: if a previously-shown asset's access re-check fails (owner withdrew it), show a "no longer available" placeholder instead of a broken image, and drop it from any local cache.

Build per master template. UI: reverse-chronological feed with lazy-loaded gallery, thumbnail grid → full-screen viewer that re-checks access on open.
Tests: pagination, expired-link re-fetch, withdrawn-asset placeholder, empty feed state.
```

### 5.5 Payments / balance — FR-CUST-05

Depends on: Projects. Backend contract: `GET /projects/{id}/payments`.

```
Implement the `finance` feature (project ledger view — NOT product checkout, keep this ledger fully separate from the commerce order ledger in Module 5.15).

Requirements:
- Render posted/reversed ledger entries, server-calculated totals, currency, as_of timestamp, and due schedule exactly as returned. Never sum line items client-side to derive a total — display the server's total field.
- Distinguish (per the action plan's business rule) total contract value, approved variations, net received, outstanding total, amount currently due, and any credit/overpayment — render each as its own labeled figure, not folded together.
- [DECISION NEEDED] exact outstanding/due formula is Finance-owned — treat all these figures as server-provided, opaque values; the app only formats and labels them.

Build per master template. UI: balance summary card + itemised ledger list with as_of freshness indicator.
Tests: totals rendering fidelity (values shown must exactly match fixture, no client math), credit/overpayment display, stale-as_of indicator.
```

### 5.6 Documents — FR-CUST-06

Depends on: Projects, the signed-URL pattern from 5.4. Backend contract: `GET /projects/{id}/documents`, `POST /assets/{id}/access`.

```
Implement the `documents` feature (agreements/quotations/invoices).

Requirements:
- List published document versions (type, title, created_at, asset ID). Only the latest published version of a superseded document is authoritative unless the API explicitly returns version history — render whatever the API gives, don't assume single-version.
- Use the same POST /assets/{id}/access short-lived-URL pattern as photos; open PDFs via that URL, never a persisted link.
- Show clearly which document type each row is (agreement / quotation / invoice) since customers may confuse them.

Build per master template. UI: grouped-by-type document list, tap-to-view/download via signed URL.
Tests: signed-URL refetch-on-expiry, grouping-by-type, empty state.
```

### 5.7 Approved designs gallery — FR-CUST-07

Depends on: Projects, signed-URL pattern. Backend contract: `GET /projects/{id}/designs`.

```
Implement the `designs` feature (approved + published design gallery).

Requirements:
- Only versions that are BOTH internally approved AND published appear — this is a server-side filter, but the UI must never merge in any other "designs" source (e.g., don't reuse the generic photo feed for this).
- No customer design-approval workflow exists in this baseline — the screen is read-only viewing, not an approve/reject action. Do not add approve/reject buttons.
- Same signed-URL access-recheck pattern as photos/documents.

Build per master template. UI: gallery grid grouped by design/version, full-screen viewer.
Tests: read-only-ness (no mutation actions present), signed-URL handling, empty state.
```

### 5.8 Support / raise a query — FR-CUST-08

Depends on: Projects (optional — buyer-only accounts must be able to reach support too), Orders (once built, for order-linked queries). Backend contract: `POST /queries`, `GET /queries`, `GET /queries/{id}`.

```
Implement the `support` feature (raise/track a query).

Requirements:
- A query is created against EITHER a project_id OR an order_id (never both, and never neither) — the form should adapt to context (e.g., a "contact support" button on a project screen pre-fills project_id; one on an order screen pre-fills order_id; a general entry point lets the user pick which, if they have both).
- On submit, show the returned ticket ID and assignee-queue info if provided; the customer never sees internal staff names.
- List/detail of own tickets only — server enforces ownership, but include a repository-level test that a foreign ticket ID returns not-found, not another user's ticket.
- Design the ticket detail screen to be extensible for a reply/history thread (the action plan calls this a "proposed extension") even if the initial API only returns status.

Build per master template. UI: new-query form (subject, message, context chip showing project/order), ticket list, ticket detail.
Tests: project-context vs order-context query creation, ownership isolation, empty ticket list state.
```

### 5.9 Push & in-app notifications — FR-CUST-09

Depends on: Auth (device registration needs a session). Backend contract: `POST /devices`, `DELETE /devices/{id}`, `GET /notifications`, `PATCH /notifications/{id}`.

```
Implement the `notifications` feature.

Requirements:
- Register the device (push token, platform, installation ID) via POST /devices right after login, and DELETE /devices/{id} on logout — do not leave a stale token bound to a signed-out session.
- On tapping a push/deep link, re-verify access before navigating to the target (project/order/document) — never trust the notification payload's IDs as pre-authorized; this mirrors the "recheck access when opened" rule from the action plan.
- Handle push-permission-denied gracefully: the app must remain fully usable without push, falling back to the in-app GET /notifications list as the recovery surface (per the action plan's "finance updates must succeed independently of push" rule — this UI is a safety net, not the source of truth).
- Support PATCH /notifications/{id} for read-state if the API implements it; degrade gracefully (local-only read state) if not yet available.

Build per master template. UI: in-app notification list/inbox, deep-link handler with an access-recheck step before navigation.
Tests: device register/unregister on login/logout, deep-link access-recheck (simulate a 403 on the target and assert a fallback screen, not a crash), push-denied fallback to in-app list.
```

### 5.10 Catalogue — COM-01

Depends on: Core setup only (browsable without login). Backend contract: `GET /categories`, `GET /products`, `GET /products/{id}`.

```
Implement the `catalogue` feature (Shop browse — guest-accessible).

Requirements:
- Fully usable without authentication: category browse, search, filters, product detail with images/specs/dimensions/price/sales_mode, cursor pagination.
- sales_mode distinguishes fixed-price SKU vs made-to-order vs quotation-only (bespoke) — product detail UI must branch on this: fixed-price/made-to-order show "Add to cart"; quotation-only shows "Request a Quote" instead (routes to Module 5.17), never a price/checkout path.
- [DECISION NEEDED] which categories are sellable vs quote-only is a RAK product/sales decision — don't assume every catalogue item is purchasable; always branch on the server's sales_mode field.

Build per master template (repository/usecases still apply even though there's no auth gate). UI: category grid, search/filter bar, product list, product detail with sales_mode-based CTA.
Tests: guest access (no token attached, still succeeds), sales_mode branching (fixed-price/made-to-order/quote-only each render the correct CTA), pagination, empty search-results state.
```

### 5.11 Serviceability check — COM-02

Depends on: Catalogue. Backend contract: `POST /serviceability/check`.

```
Implement the serviceability check as part of the `catalogue`/`cart` flow.

Requirements:
- Given postcode + variant/quantity, show eligibility, charges, and delivery/installation estimate before the user commits to adding to cart (surface it on product detail and re-check on cart/checkout, since postcode may change).
- Never hardcode delivery areas or lead times client-side — always call the endpoint; if it's not eligible, show why (out of delivery area / not currently stocked) rather than a generic error.

Build per master template. UI: postcode entry + result card (eligible/not, charges, estimate).
Tests: eligible/ineligible responses, re-check-on-postcode-change, network-failure fallback messaging.
```

### 5.12 Cart — COM-03

Depends on: Catalogue. Backend contract: `GET /cart`, `POST /cart/items`, `PATCH/DELETE /cart/items/{id}`.

```
Implement the `cart` feature (server-authoritative cart).

Requirements:
- The cart lives server-side; the app is a thin view over GET /cart plus mutation calls — do not maintain a separate local source of truth for price/availability, only for optimistic UI (e.g., quantity stepper) that reconciles with the next GET /cart response.
- Surface `unavailable` and `repriced` flags per line item clearly (e.g., "price changed" or "no longer available" banners) — these are expected states the action plan explicitly calls out, not edge-case bugs.
- Guest users can build a cart; sign-in is required only at the checkout boundary (per the proposed navigation), so keep cart state working pre-login and merge/attach it to the account after OTP verify if the API supports that — if it doesn't yet, at minimum don't lose the user's cart intent through the login flow (e.g., re-add locally-remembered items after login as a fallback).

Build per master template. UI: cart list with quantity controls, repriced/unavailable banners, running total (server-provided, not client-summed), checkout CTA (routes to login if unauthenticated).
Tests: add/update/remove, repriced/unavailable banner rendering, guest-cart-through-login continuity.
```

### 5.13 Addresses — part of COM-04

Depends on: Auth (addresses are account-owned). Backend contract: `GET/POST /addresses`, `PATCH/DELETE /addresses/{id}`.

```
Implement the `addresses` feature.

Requirements:
- CRUD on the customer's own saved addresses with validated delivery/contact fields (surface server validation errors field-by-field, don't just show a generic "invalid address").
- Selecting an address at checkout re-triggers the serviceability check (Module 5.11) for the cart contents against that address's postcode.

Build per master template. UI: address list, add/edit form with field-level validation errors, select-at-checkout flow.
Tests: CRUD happy path, field-level validation error rendering, re-serviceability-check on address selection.
```

### 5.14 Checkout & quotes — COM-04

Depends on: Cart, Addresses, Serviceability. Backend contract: `POST /checkout/quotes`.

```
Implement the `checkout` feature — quote step.

Requirements:
- POST /checkout/quotes takes cart_version + address and returns an EXPIRING quote with itemised totals (tax, shipping, installation, discount) and currency — display the countdown/expiry and force a re-quote if it lapses before payment.
- The quote is the single source of truth for "final payable total" — never let the UI compute or adjust this total.
- If cart_version is stale (items changed since quote was requested), surface that clearly and re-quote rather than proceeding with mismatched totals.

Build per master template. UI: order review screen showing itemised quote breakdown, expiry countdown, re-quote action.
Tests: quote-expiry handling, stale-cart-version handling, itemised total rendering fidelity.
```

### 5.15 Payment & order creation — COM-05

Depends on: Checkout. Backend contract: `POST /orders`, `POST /webhooks/payments/{provider}` (server-side only, but the app must handle the resulting order states).

```
Implement the `orders` feature — order/payment creation and confirmation.

Requirements:
- POST /orders takes quote_id + a client-generated idempotency key — generate and persist this key BEFORE the network call so a retry (e.g., after a timeout) reuses the same key and cannot create a duplicate order.
- The mobile app's own success callback from the payment provider SDK is NOT proof of payment — after the provider flow completes, poll or refresh GET /orders/{id} to reflect the server-confirmed payment state; show a "confirming payment…" state in between, not an immediate "success."
- Handle app backgrounding/closure mid-payment: on next app open, check for any pending_payment order and resume polling its status rather than losing track of it.
- Track three independent states per the action plan: order (pending_payment/confirmed/cancelled/closed), payment (pending/paid/failed/partially_refunded/refunded), fulfilment (unfulfilled/processing/partially_shipped/shipped/delivered) — model these as three separate enums, never collapse them into one "status" field in the domain layer.

Build per master template. UI: payment hand-off screen, "confirming payment" pending state, order confirmation screen.
Tests: idempotency-key reuse on retry, pending→confirmed polling transition, resume-after-app-closure, the three-state-enum modeling (a bloc test asserting payment=paid + fulfilment=unfulfilled is a valid combined state, not an error).
```

### 5.16 Order tracking, cancellations & returns — COM-06/07

Depends on: Orders. Backend contract: `GET /orders`, `GET /orders/{id}`, `POST /orders/{id}/cancellations`, `POST /orders/{id}/returns`.

```
Implement order history, tracking, and after-sales requests.

Requirements:
- Order list/detail shows order lines, the three independent states from Module 5.15, shipments, and invoice assets (reuse the signed-URL pattern from Module 5.6 for invoices).
- Support partial shipment: a fulfilment state of partially_shipped with per-line shipment/tracking info must render correctly — never show "delivered" for the whole order just because some lines shipped.
- Cancellation/return requests submit eligible items/quantities + reason and return a request ID + decision state (requested/approved/rejected/received) — surface eligibility rules from the API (which lines/quantities are even offered) rather than letting the user pick freely and fail server-side.
- [DECISION NEEDED] exact return/refund policy windows are Fulfilment/Finance-owned — the UI should only offer what the API marks eligible, never a hardcoded "returnable within 7 days" assumption.

Build per master template. UI: order list, order detail with per-line shipment tracking, cancellation/return request form scoped to eligible lines, request status tracker.
Tests: partial-shipment rendering, eligible-lines-only request form, request-state tracking through requested→approved/rejected→received.
```

### 5.17 Product enquiry / Request a Quote — COM-08

Depends on: Catalogue (for product/config context). Backend contract: `POST /product-enquiries`.

```
Implement the "Request a Quote" flow for bespoke/quotation-only items.

Requirements:
- Reachable from any product marked sales_mode = quotation-only (Module 5.10) and also as a general entry point for custom interiors not in the catalogue at all.
- Submits product/configuration snapshot + message + consent, and must deduplicate retries (don't create duplicate leads on a double-tap or network retry — reuse the same idempotency approach as Module 5.15 if the API expects it, otherwise disable the submit button optimistically and reconcile with the response).
- Confirmation screen shows the lead/query ID and sets expectations (a consultant will follow up) — this is explicitly NOT a checkout/payment path.

Build per master template. UI: enquiry form pre-filled with product/config context when launched from a product page, generic form otherwise, confirmation screen.
Tests: duplicate-submit prevention, product-context pre-fill, generic-entry-point flow.
```

---

## 6. Cross-cutting prompts (run these against the whole app, not one module)

### 6.1 Empty / loading / error state audit

```
Audit every screen built so far in this app for four required states: loading, success, empty (zero results — not an error), and error (network/4xx/5xx). For any screen missing one, generate it following the existing design-system widgets. Empty states must never look like errors, and error states must offer a retry action wired to re-invoke the same usecase.
```

### 6.2 Session & security hardening pass

```
Review the app against these release-blocking scenarios from the action plan and write/extend tests for any that aren't covered yet:
- Client A cannot reach client B's projects/payments/asset URLs/tickets/orders by editing an ID in a request, including IDs reachable via a notification deep link.
- Buyer-only accounts see zero project data anywhere in the UI (no empty project card leaking a project-shaped widget).
- Sensitive cached data (tokens, any locally-cached ledger/order figures) is cleared on logout AND on account switch (switching accounts without a full app restart).
- Expired/incorrect/reused OTP, resend abuse, and refresh-token replay all fail safely with generic messaging.
- Expired signed file/photo/document links are re-checked, not served from a stale cache.
For each gap found, propose the fix and the test that would have caught it.
```

### 6.3 Offline / slow network pass

```
Add explicit handling for slow network and offline conditions across auth, project data, cart, and checkout: show a distinguishable "slow connection" state after a timeout threshold (don't just spin forever), disable mutating actions (checkout submit, payment) while offline rather than letting them queue silently, and ensure no cached price/stock/balance is presented as current without a visible as-of/staleness indicator.
```

---

## 7. Acceptance test prompt (run once major flows exist)

```
Generate an integration_test suite covering the release-blocking scenarios from the action plan's acceptance section:
1. Isolation: attempt cross-account access to a project, payment, ticket, and order by ID substitution; assert access denied, not data leakage.
2. Identity: expired/incorrect/reused OTP, resend-cooldown enforcement, refresh-token replay, logout, and access after a phone reassignment scenario (mocked).
3. Publishing: draft/internal designs never render; withdrawn assets show unavailable, not broken; published items show correct timestamps/amounts.
4. Commerce: two near-simultaneous last-item purchases — assert the second is rejected/requoted, not double-sold; a price change between quote and payment invalidates the quote; a duplicated/out-of-order webhook (simulate via repeated GET /orders/{id} states) never double-renders a charge.
5. Recovery: payment success arriving after the app was closed and reopened is reflected correctly; an expired stock hold surfaces as such, not a silent failure; partial shipment never displays as full delivery.
6. Devices: run the core flows with push permission denied, an expired file link, and simulated slow network; assert no crashes and correct fallback states; assert secure storage is cleared on logout.
```

---

## 8. API contract quick reference

Use this table while writing prompts so endpoint names/fields stay consistent across modules. Treat all of it as **proposed** — confirm against the actual OpenAPI spec once delivered (action plan §4/§8) before locking field names in generated DTOs.

**Identity & session:** `POST /auth/otp/request`, `POST /auth/otp/verify`, `POST /auth/refresh`, `POST /auth/logout`, `GET /me`.

**Projects:** `GET /me/projects`, `GET /projects/{id}`, `GET /projects/{id}/milestones`, `GET /projects/{id}/updates`, `GET /projects/{id}/payments`, `GET /projects/{id}/documents`, `GET /projects/{id}/designs`, `POST /assets/{id}/access`.

**Support & notifications:** `POST /queries`, `GET /queries`, `GET /queries/{id}`, `POST /devices`, `DELETE /devices/{id}`, `GET /notifications`, `PATCH /notifications/{id}`.

**Commerce:** `GET /categories`, `GET /products`, `GET /products/{id}`, `POST /serviceability/check`, `GET/POST /addresses`, `PATCH/DELETE /addresses/{id}`, `GET /cart`, `POST /cart/items`, `PATCH/DELETE /cart/items/{id}`, `POST /checkout/quotes`, `POST /orders`, `GET /orders`, `GET /orders/{id}`, `POST /orders/{id}/cancellations`, `POST /orders/{id}/returns`, `POST /product-enquiries`, `POST /webhooks/payments/{provider}` (server-only).

Global conventions to bake into the dio client / DTOs from the start: `/v1` prefix, UTC ISO timestamps, integer minor-unit money + currency code, opaque cursors, bounded page sizes, request IDs on every call, and defined handling for 401/403/404/409/429.

---

## 9. Open decisions to track (don't let prompts silently assume these)

- What's actually deployed today vs only drafted in the Corporate FRD (affects how much "existing" ERP reuse Module 5.2 onward can rely on).
- Phone/household/project linking rules (affects Module 5.1's duplicate-number handling).
- Phase/progress/date-change definitions (Module 5.2/5.3 — currently must treat these as fully server-opaque).
- Who publishes files/designs/site updates, and the exact publish/withdraw workflow (Modules 5.4/5.6/5.7).
- Support routing/ownership (Module 5.8).
- Which SKUs are directly purchasable vs quote-only, and the full stock/delivery/installation/return rule set (Modules 5.10–5.16).
- Payment provider, invoicing, and reconciliation ownership (Module 5.15).

Resolve these alongside backend delivery (action plan §8); until then, keep every corresponding value server-driven/configurable in the app rather than hardcoded.
