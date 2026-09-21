# RAK Interiors Customer API

Version: `1.0.0`  
Audience: backend implementers and the Flutter customer app (`rak_customer`)  
Source of truth: domain repositories and entities under `lib/features/` and `lib/core/domain/`

The Flutter app currently runs against a **local Drift database**. This document is the HTTP contract those domain use cases expect when a remote API replaces local datasources.

---

## 1. Overview

RAK Interiors is a customer app for:

- Phone OTP sign-in (project clients and shop-only buyers)
- Furniture / interiors catalogue, branch availability, cart, checkout
- Interior **project tracking**: timeline, site updates, finance, documents, approved designs
- Support tickets and in-app notifications

### Base URL

| Environment | Base URL |
|-------------|----------|
| Production | `https://api.rakinteriors.in/v1` |
| Staging | `https://staging-api.rakinteriors.in/v1` |

All paths below are relative to `/v1`.

### Conventions

| Topic | Rule |
|-------|------|
| Protocol | HTTPS only |
| Format | `application/json; charset=utf-8` |
| Field names | `camelCase` (matches Dart entities) |
| IDs | Opaque strings (`acc_…`, `prj_…`, UUID, etc.) |
| Money | Integer **minor units** + ISO 4217 `currency` (INR paise: `1850000` = ₹18,500.00) |
| Date-time | ISO 8601 UTC, e.g. `2026-09-06T14:10:00.000Z` |
| Pagination | Cursor: `?cursor=` + `nextCursor` in the body |
| Auth | `Authorization: Bearer <accessToken>` |
| Idempotency | `Idempotency-Key` recommended on `POST /cart/items`, `POST /orders` |

---

## 2. Authentication

### 2.1 Access token

Protected routes require:

```http
Authorization: Bearer <accessToken>
```

Access tokens expire after **12 hours** (`LocalDemoConfig.accessTokenTtl`).

`accountId` is never taken from the client for ownership. The server resolves the account from the token.

Guest (unsigned) callers may use:

- Catalogue
- Shop branches
- Guest cart (`GET/POST /cart` without a token)
- Product enquiry (optional account)

### 2.2 Refresh token

`verifyOtp` returns `refreshToken`. Persist it in secure storage.

```
POST /auth/refresh
```

The domain layer does not yet call refresh; implement it so the app can add a remote adapter later.

### 2.3 OTP

| Rule | Value |
|------|--------|
| Phone format | E.164: `^\+[1-9]\d{7,14}$` (spaces stripped) |
| Code | Numeric, **6 digits** for delete-account; login accepts ≥ 4 digits client-side |
| Challenge TTL | 5 minutes |
| Resend cooldown | 30 seconds (`resendAfter`) |
| One-time | Challenge is consumed on successful verify/delete |
| Purposes | `login`, `delete_account` |

Demo (local only): OTP is always `123456`. Production must send SMS and never return the code.

---

## 3. Errors

Envelope:

```json
{
  "error": {
    "code": "validation",
    "message": "Enter a phone number with country code, like +91 98765 43210."
  }
}
```

| HTTP | `code` | App `Failure` | Typical cause |
|------|--------|---------------|---------------|
| 400 | `validation` | `ValidationFailure` | Bad phone, OTP, empty cart, quote-only add-to-cart |
| 401 | `unauthorized` | `UnauthorizedFailure` | Missing/expired token, checkout without session |
| 404 | `not_found` | `NotFoundFailure` | Product, project, order, ticket, asset withdrawn |
| 409 | `conflict` | `ConflictFailure` | Cart version mismatch (if optimistic locking is used) |
| 429 | `rate_limited` | `RateLimitedFailure` | OTP resend before `resendAfter` |
| 500 | `unknown` | `UnknownFailure` | Unhandled server error |

Do **not** leak whether a phone exists. Login OTP always returns a challenge.

---

## 4. Shared schemas

### Money

```json
{ "minorUnits": 1850000, "currency": "INR" }
```

Standalone money fields on cart/order lines also appear as `unitPriceMinor` + `currency`.

### Page result

```json
{
  "items": [],
  "nextCursor": "p5"
}
```

`nextCursor` is omitted or `null` when there is no next page.

### Account

| Field | Type | Notes |
|-------|------|--------|
| `id` | string | |
| `phone` | string | E.164 |
| `displayName` | string | New OTP users: `"Guest buyer"` |
| `hasProjects` | boolean | Gates project-tracking UI |

### Session

```json
{
  "account": { "id": "acc_projects", "phone": "+919876540001", "displayName": "Anjali Menon", "hasProjects": true },
  "accessToken": "…",
  "refreshToken": "…"
}
```

### OtpChallenge

```json
{
  "id": "8f3c…",
  "phone": "+919876540001",
  "expiresAt": "2026-09-22T00:14:00.000Z",
  "resendAfter": "2026-09-22T00:09:30.000Z"
}
```

Never return `code`.

---

## 5. Endpoints

### Auth

#### `POST /auth/otp`

Request OTP. Public.

```json
{ "phone": "+919876540001", "purpose": "login" }
```

`purpose`: `login` (default) or `delete_account`.

**200** `OtpChallenge`  
**400** invalid phone  
**429** if a live challenge’s `resendAfter` has not passed

---

#### `POST /auth/otp/verify`

Consume a **login** challenge. Creates the account if the phone is new (`displayName: "Guest buyer"`, `hasProjects: false`). Issues tokens.

```json
{ "challengeId": "8f3c…", "code": "123456" }
```

**200** `Session`  
**400** consumed, expired, wrong code, or purpose ≠ `login`

---

#### `POST /auth/refresh`

```json
{ "refreshToken": "…" }
```

**200** `Session` (new access + refresh; rotate refresh)  
**401** invalid refresh

---

#### `POST /auth/logout`

Auth required.

Revokes all sessions for the account (local demo deletes all `AuthSessions` for the account).

**204** empty

---

#### `POST /auth/account/delete`

Auth required. Consumes an OTP with `purpose: delete_account` for the **same phone** as the signed-in account.

```json
{ "challengeId": "8f3c…", "code": "123456", "phone": "+919876540001" }
```

**204** empty  
**400** OTP mismatch / not 6 digits  
**401** not signed in

---

#### `GET /me`

Auth required. Current account (equivalent to hydrating `currentSession`).

**200** `Account`

---

### Catalogue (public)

#### `GET /categories`

Ordered by `sortIndex`.

**200**

```json
{
  "items": [
    { "id": "cat_furniture", "name": "Furniture" },
    { "id": "cat_lighting", "name": "Lighting" },
    { "id": "cat_storage", "name": "Storage" },
    { "id": "cat_decor", "name": "Decor" }
  ]
}
```

---

#### `GET /products`

Query:

| Param | Notes |
|-------|--------|
| `categoryId` | Optional filter |
| `cursor` | Opaque; products ordered by `sortCursor` ascending |
| `limit` | Optional, default 50 |

Only `published: true` products.

**200** page of `CatalogueProduct`

```json
{
  "id": "prod_oak_table",
  "categoryId": "cat_furniture",
  "name": "Oak dining table",
  "description": "Solid European oak, seating eight. …",
  "salesMode": "fixed_price",
  "priceMinor": 1850000,
  "currency": "INR",
  "specs": "W 220cm · D 100cm · H 76cm",
  "imageHint": "table"
}
```

| `salesMode` | Cart | Price |
|-------------|------|--------|
| `fixed_price` | Can add | Required |
| `made_to_order` | Can add | Required |
| `quotation_only` | Enquiry only | `priceMinor` may be `null` |

`imageHint` is a visual key (`table`, `sofa`, `light`, `wardrobe`, `rug`, `pdf`, `joinery`, `kitchen`, `living`) until CDN URLs exist.

---

#### `GET /products/{productId}`

**200** `CatalogueProduct`  
**404** unpublished or missing (`This product is not available.`)

---

#### `POST /enquiries`

Public. Optional auth attaches `accountId`.

```json
{ "message": "Need this sofa in 3.2m for the Kochi villa.", "productId": "prod_linen_sofa" }
```

`productId` optional. If set, product must be published.

**201**

```json
{
  "id": "enq_…",
  "message": "Need this sofa…",
  "createdAt": "2026-09-22T00:10:00.000Z",
  "accountId": "acc_projects",
  "productId": "prod_linen_sofa"
}
```

**400** empty message (`Tell us about the piece and your space.`)  
**404** unknown product or unknown account

---

### Shop branches

Selection is currently **device-local**. The API should still list branches and answer stock so a remote adapter can replace `ShopBranchRepositoryImpl`.

#### `GET /branches`

**200**

```json
{
  "items": [
    { "id": "kochi", "name": "Kochi", "area": "Vyttila, Kerala" },
    { "id": "trivandrum", "name": "Trivandrum", "area": "Enjakkal, Kerala" },
    { "id": "calicut", "name": "Calicut", "area": "Pantheerankavu, Kerala" },
    { "id": "bangalore", "name": "Bangalore", "area": "HSR Layout, Karnataka" }
  ]
}
```

---

#### `GET /branches/{branchId}/availability/{productId}`

**200** `{ "available": true }`

Demo rule (must be replaced by real inventory):

- Bangalore: `prod_oak_table` and `prod_linen_sofa` → `available: false`
- All other combinations → `true`

**404** unknown branch (`That branch is not available.`)

Optional later: persist selected branch per account with `PUT /me/branch`.

---

### Cart

Guest cart: no `Authorization`. Server uses a guest cart cookie/device id, or a dedicated guest cart (local demo id `cart_guest`).  
Signed-in cart: one cart per account (`cart_{accountId}`).

Cart `version` increments on every mutation. Send `If-Match: <version>` if implementing optimistic concurrency.

#### `GET /cart`

**200** `ShoppingCart`

```json
{
  "id": "cart_acc_projects",
  "version": 4,
  "totalMinor": 2770000,
  "currency": "INR",
  "lines": [
    {
      "id": "line-uuid",
      "productId": "prod_oak_table",
      "name": "Oak dining table",
      "unitPriceMinor": 1850000,
      "currency": "INR",
      "quantity": 1,
      "unavailable": false,
      "repriced": false,
      "imageHint": "table"
    }
  ]
}
```

`totalMinor` is sum of `unitPriceMinor * quantity` (**does not** include delivery).  
`unavailable` / `repriced` flags are set by the server when stock or price changes after add.

---

#### `POST /cart/items`

```json
{ "productId": "prod_oak_table" }
```

Adds quantity 1, or increments an existing line for that product.

**200** full `ShoppingCart`  
**404** product missing  
**400** `quotation_only` or missing price (`This item is available by quote only.`)

---

#### `PATCH /cart/lines/{lineId}`

```json
{ "quantity": 2 }
```

`quantity <= 0` **deletes** the line.

**200** full `ShoppingCart`  
**404** `This cart item is no longer available.`

---

### Checkout (auth required)

Delivery charge: **₹500.00** (`50000` paise), added only when placing the order. Cart totals stay exclusive of delivery; UI adds it for display.

#### `GET /delivery-address`

**200** `DeliveryAddress` or **204** if none saved

```json
{
  "fullName": "Anjali Menon",
  "mobile": "+919876540001",
  "line": "12 Palm Avenue, Panampilly Nagar",
  "postcode": "682036"
}
```

---

#### `PUT /delivery-address`

One address per account (upsert).

```json
{
  "fullName": "Anjali Menon",
  "mobile": "+919876540001",
  "line": "12 Palm Avenue, Panampilly Nagar",
  "postcode": "682036"
}
```

**200** saved address  
**400** any field empty (`Fill in every delivery field.`)  
**401** not signed in

---

#### `POST /orders`

Places the current cart. Snapshot of address + line names/prices. Status starts as `confirmed`. Cart is then emptied (`totalMinor: 0`, version + 1).

Order total = cart `totalMinor` + `50000`.

**201** `ShopOrder`  
**400** empty cart, missing address, or any line `unavailable`  
**401** not signed in

`ShopOrder`:

```json
{
  "id": "ord_…",
  "accountId": "acc_projects",
  "status": "confirmed",
  "address": { "fullName": "…", "mobile": "…", "line": "…", "postcode": "…" },
  "lines": [
    {
      "id": "…",
      "productId": "prod_oak_table",
      "name": "Oak dining table",
      "imageHint": "table",
      "unitPriceMinor": 1850000,
      "currency": "INR",
      "quantity": 1
    }
  ],
  "totalMinor": 2820000,
  "currency": "INR",
  "createdAt": "2026-09-22T00:12:00.000Z"
}
```

`status` values used by the app: `confirmed` (treat as placed). Extend later (`processing`, `shipped`, `delivered`, `cancelled`) without breaking `isConfirmed`.

---

#### `GET /orders`

Auth. Newest first.

**200** `{ "items": [ ShopOrder, … ] }`

---

#### `GET /orders/{orderId}`

Must belong to the caller.

**200** `ShopOrder`  
**404** `This order is not available.`

---

### Projects (auth + ownership)

Only accounts with `hasProjects: true` typically have rows. Others get an empty list, not an error.

#### `GET /projects`

Query: `cursor` (ordered by `sortCursor` ascending).

**200** page of `InteriorProject` (include `milestones` on list **or** only on detail; local demo includes them on both).

---

#### `GET /projects/{projectId}`

**200** `InteriorProject`  
**404** `This project is not available.` (wrong account or missing)

```json
{
  "id": "prj_albarari",
  "name": "Panampilly Nagar villa",
  "siteLabel": "Panampilly Nagar, Kochi",
  "phaseCode": "FITOUT",
  "phaseLabel": "Interior fit-out",
  "progressPercent": 62,
  "targetHandoverAt": "2026-12-15T00:00:00.000Z",
  "forecastHandoverAt": "2027-01-20T00:00:00.000Z",
  "updatedAt": "2026-09-08T03:30:00.000Z",
  "milestones": [
    {
      "id": "ms_ab_1",
      "title": "Design freeze",
      "state": "completed",
      "sortIndex": 0,
      "plannedAt": "2026-03-10T00:00:00.000Z",
      "completedAt": "2026-03-08T00:00:00.000Z",
      "note": "Approved drawings issued to site."
    }
  ]
}
```

| Field | Notes |
|-------|--------|
| `progressPercent` | `null` allowed (app hides bar) |
| `targetHandoverAt` / `forecastHandoverAt` | nullable |
| `phaseCode` | e.g. `FITOUT`, `DESIGN_DEV` |
| `milestone.state` | `completed` or `planned` (completed iff `state == "completed"`) |

---

### Site updates

#### `GET /projects/{projectId}/updates`

Auth + project ownership. Only `published: true`.

Query: `cursor` (descending `sortCursor`), `limit` default **20**.

**200** page of `SiteUpdate`

```json
{
  "id": "upd_joinery",
  "projectId": "prj_albarari",
  "published": true,
  "note": "Joinery package delivered. Installation starts next week.",
  "eventAt": "2026-09-06T14:10:00.000Z",
  "sortCursor": "009",
  "assets": [
    { "assetId": "ast_joinery_1", "sortIndex": 0 },
    { "assetId": "ast_joinery_2", "sortIndex": 1 }
  ]
}
```

Draft updates must never appear. Withdrawn assets may still be listed; **access** then 404s.

---

### Finance

#### `GET /projects/{projectId}/finance`

Auth + ownership.

**200** `ProjectFinance`  
**204** project exists but no ledger yet (app shows empty finance)  
**404** project not owned

```json
{
  "projectId": "prj_albarari",
  "currency": "INR",
  "asOf": "2026-09-06T08:00:00.000Z",
  "totalContract": { "minorUnits": 185000000, "currency": "INR" },
  "approvedVariations": { "minorUnits": 12000000, "currency": "INR" },
  "netReceived": { "minorUnits": 98000000, "currency": "INR" },
  "outstandingTotal": { "minorUnits": 77700000, "currency": "INR" },
  "amountCurrentlyDue": { "minorUnits": 25000000, "currency": "INR" },
  "creditOverpayment": { "minorUnits": 1500000, "currency": "INR" },
  "entries": [
    {
      "id": "led_retainer",
      "description": "Design retainer",
      "state": "posted",
      "amount": { "minorUnits": 15000000, "currency": "INR" },
      "postedAt": "2026-02-10T00:00:00.000Z"
    }
  ],
  "dueSchedule": [
    {
      "id": "due_joinery",
      "label": "Stage 3 — joinery",
      "amount": { "minorUnits": 25000000, "currency": "INR" },
      "dueAt": "2026-10-01T00:00:00.000Z"
    }
  ]
}
```

`LedgerEntry.state`: `posted` | `reversed` (`isReversed` when `reversed`).  
Client treats finance as **stale** if `asOf` is older than **24 hours**.

---

### Documents

#### `GET /projects/{projectId}/documents`

Auth + ownership. Only published documents.

**200** `{ "items": [ ProjectDocument ] }` ordered by `createdAt` ascending.

```json
{
  "id": "doc_agreement",
  "projectId": "prj_albarari",
  "type": "agreement",
  "title": "Interior works agreement",
  "assetId": "ast_doc_agreement",
  "createdAt": "2026-03-09T00:00:00.000Z"
}
```

`type`: `agreement` | `quotation` | `invoice` (UI labels: Agreement / Quotation / Invoice).

---

### Designs

#### `GET /projects/{projectId}/designs`

Auth + ownership. Only `approved: true` **and** `published: true`.

**200** `{ "items": [ ApprovedDesign ] }` ordered by `sortIndex`.

```json
{
  "id": "dsn_living",
  "projectId": "prj_albarari",
  "title": "Living room",
  "versionLabel": "Rev C",
  "assetIds": ["ast_design_living"]
}
```

---

### Asset access (signed URLs)

Photos, PDFs, and design images are never returned as raw files on list endpoints. The client requests a short-lived URL.

TTL: **2 minutes**. Unpublished or `withdrawn` assets must 404.

Same payload for updates, documents, and designs:

```json
{
  "assetId": "ast_joinery_1",
  "signedUrl": "https://cdn.example/…?sig=…",
  "expiresAt": "2026-09-22T00:12:00.000Z",
  "visualHint": "joinery",
  "caption": "Wardrobe carcasses on site"
}
```

#### `POST /assets/{assetId}/access`

Auth. Prefer this single endpoint (shared `AssetAccessRepository`).

Also acceptable aliases the app can map:

- `POST /updates/assets/{assetId}/access` — 404 message: `This photo is no longer available.`
- `POST /documents/assets/{assetId}/access` / `POST /designs/assets/{assetId}/access` — `This file is no longer available.`

**200** `AssetAccess`  
**404** missing / unpublished / withdrawn

---

### Support (auth)

#### `GET /support/queries`

Owned tickets, newest first.

**200** `{ "items": [ SupportQuery ] }`

```json
{
  "id": "qry_ab_joinery",
  "accountId": "acc_projects",
  "projectId": "prj_albarari",
  "orderId": null,
  "subject": "Joinery delivery window",
  "message": "Please confirm the wardrobe install week.",
  "status": "open",
  "queueLabel": "Project coordination",
  "createdAt": "2026-09-05T10:00:00.000Z"
}
```

`status` used today: `open`. `queueLabel` optional (`Customer support`, `Project coordination`, `Order desk`).

Exactly one of `projectId` or `orderId` should be set.

---

#### `GET /support/queries/{queryId}`

**200** `SupportQuery`  
**404** `This ticket is not available.`

---

#### `GET /support/contexts`

Options the create-ticket UI can attach. Local demo returns **projects only**; include **orders** as well for shop-only buyers.

**200**

```json
{
  "options": [
    { "kind": "project", "id": "prj_albarari", "label": "Panampilly Nagar villa" },
    { "kind": "order", "id": "ord_…", "label": "Order ord_…" }
  ]
}
```

`kind`: `project` | `order`.

---

#### `POST /support/queries`

```json
{
  "subject": "Joinery delivery window",
  "message": "Please confirm the wardrobe install week.",
  "projectId": "prj_albarari"
}
```

or `{ "orderId": "ord_…" }` instead of `projectId`.

**201** `SupportQuery` (`status: "open"`, `queueLabel: "Customer support"`)  
**400** empty subject/message, or both/neither project and order (`Choose a project or an order, not both.`)  
**404** project/order not owned

---

### Notifications (auth)

#### `GET /notifications`

Newest first.

**200** `{ "items": [ InAppNotification ] }`

```json
{
  "id": "ntf_update",
  "title": "New site photos",
  "body": "Joinery package photos have been published.",
  "targetType": "project",
  "targetId": "prj_albarari",
  "read": false,
  "createdAt": "2026-09-06T14:15:00.000Z"
}
```

`targetType`: `none` | `project` | `document`  
If `none`, `targetId` is `""`. Deep-link only when `targetType != "none"` and `targetId` is non-empty.

---

#### `POST /notifications/{notificationId}/read`

**200** notification with `read: true`  
**404** `This notification is not available.`

---

#### `POST /notifications/{notificationId}/recheck`

Confirms the user may still open the target (project sold, document unpublished, etc.).

**200**

```json
{ "destination": "none" }
```

```json
{ "destination": "project", "projectId": "prj_albarari" }
```

```json
{ "destination": "denied" }
```

Rules:

| `targetType` | Result |
|--------------|--------|
| `none` / empty target | `none` |
| `project` and owned | `project` + `projectId` |
| `document` published and parent project owned | `project` + that project id |
| otherwise | `denied` |

---

#### `POST /devices`

Called after login. Upsert by `(accountId, installationId)`.

```json
{
  "platform": "ios",
  "installationId": "install-uuid",
  "pushToken": "fcm-or-apns",
  "pushPermissionGranted": true
}
```

If `pushPermissionGranted` is false, store `pushToken` as `null`.

**200**

```json
{
  "id": "dev_acc_projects_install-uuid",
  "accountId": "acc_projects",
  "platform": "ios",
  "installationId": "install-uuid",
  "pushToken": "fcm-or-apns"
}
```

---

#### `DELETE /devices/{installationId}`

Called on logout. Removes the device row for this account.

**204**

---

## 6. Endpoint index

| Method | Path | Auth | Use case |
|--------|------|------|----------|
| POST | `/auth/otp` | No | `RequestOtp` |
| POST | `/auth/otp/verify` | No | `VerifyOtp` |
| POST | `/auth/refresh` | Refresh | (future adapter) |
| POST | `/auth/logout` | Yes | `Logout` |
| POST | `/auth/account/delete` | Yes | `DeleteAccount` |
| GET | `/me` | Yes | `GetCurrentSession` |
| GET | `/categories` | No | `GetCategories` |
| GET | `/products` | No | `GetProducts` |
| GET | `/products/{id}` | No | `GetProduct` |
| POST | `/enquiries` | Optional | `SubmitProductEnquiry` |
| GET | `/branches` | No | `ListShopBranches` |
| GET | `/branches/{id}/availability/{productId}` | No | `IsProductAvailableAtBranch` |
| GET | `/cart` | Optional | `GetCart` |
| POST | `/cart/items` | Optional | `AddCartItem` |
| PATCH | `/cart/lines/{lineId}` | Optional | `UpdateCartLineQuantity` |
| GET | `/delivery-address` | Yes | `GetDeliveryAddress` |
| PUT | `/delivery-address` | Yes | `SaveDeliveryAddress` |
| POST | `/orders` | Yes | `PlaceOrder` |
| GET | `/orders` | Yes | `ListShopOrders` |
| GET | `/orders/{id}` | Yes | `GetShopOrder` |
| GET | `/projects` | Yes | `GetMyProjects` |
| GET | `/projects/{id}` | Yes | `GetProject` |
| GET | `/projects/{id}/updates` | Yes | `GetProjectUpdates` |
| GET | `/projects/{id}/finance` | Yes | `GetProjectFinance` |
| GET | `/projects/{id}/documents` | Yes | `GetProjectDocuments` |
| GET | `/projects/{id}/designs` | Yes | `GetApprovedDesigns` |
| POST | `/assets/{id}/access` | Yes | `RequestAssetAccess` / document / design access |
| GET | `/support/queries` | Yes | `GetSupportQueries` |
| GET | `/support/queries/{id}` | Yes | `GetSupportQuery` |
| GET | `/support/contexts` | Yes | `GetSupportContexts` |
| POST | `/support/queries` | Yes | `CreateSupportQuery` |
| GET | `/notifications` | Yes | `GetNotifications` |
| POST | `/notifications/{id}/read` | Yes | `MarkNotificationRead` |
| POST | `/notifications/{id}/recheck` | Yes | `RecheckNotificationAccess` |
| POST | `/devices` | Yes | `RegisterDevice` |
| DELETE | `/devices/{installationId}` | Yes | `UnregisterDevice` |

---

## 7. Authorization matrix

Every project-scoped GET/POST must verify `projects.accountId == token.accountId`. Same for orders, tickets, notifications, and delivery address.

Never return another account’s ticket (seed includes `qry_someone_else` for this invariant).

Assets: still require a valid session; additionally refuse unpublished / withdrawn files even if the id is guessed.

---

## 8. Feature flags (client)

`FeatureFlags`:

- `commerceEnabled` — shop, cart, checkout
- `trackingEnabled` — projects, updates, finance, documents, designs

The API may still expose all routes; the app hides surfaces when a flag is off.

---

## 9. Reference seed (local / staging)

Use these to test the customer app until production data exists.

| Role | Phone | Account id | Notes |
|------|-------|------------|--------|
| Project client | `+919876540001` | `acc_projects` | Anjali Menon, `hasProjects: true` |
| Shop-only buyer | `+919876540002` | `acc_buyer` | Rahul Nair |

OTP (demo only): `123456`

| Resource | Id |
|----------|-----|
| Projects | `prj_albarari` (Panampilly Nagar villa), `prj_difc` (HSR Layout apartment) |
| Products | `prod_oak_table`, `prod_linen_sofa`, `prod_brass_pendant`, `prod_wardrobe` (quotation), `prod_rug` |
| Guest cart | `cart_guest` |
| Finance | only `prj_albarari` |
| Sample ticket | `qry_ab_joinery` |
| Denied notification | `ntf_denied` → `prj_not_yours` |

Currency everywhere: **INR**.

---

## 10. Mapping to Flutter

When the remote API is live:

1. Keep domain entities and repository interfaces unchanged.
2. Add `*_remote_datasource.dart` under each feature’s `data/datasources/`.
3. Register the remote implementation in `lib/core/di/injection.dart` instead of `*_local_datasource.dart`.
4. Map HTTP status + `error.code` onto `Failure` subclasses in `lib/core/domain/failures/failure.dart`.
5. Store tokens with existing `SecureSessionStorage`.
6. Put `signedUrl` into the media viewer; do not persist expired URLs.

Do not import HTTP from `domain/`. Adapters live in `data/`.

---

## 11. Out of scope (not in the customer app)

Staff/admin CMS, payment capture/UPI, invoice PDF generation internals, SMS provider, push fan-out, inventory management, and multi-address books. Payment can be added later as `POST /orders/{id}/pay` without changing the current `confirmed` happy path.
