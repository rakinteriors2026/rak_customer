# How the RAK Interiors customer app works

RAK Interiors customer (`rak_customer`) is a Flutter app for two jobs:

1. **Shop** — browse furniture and finishes, visualise a piece, add it to a cart, and place an order.
2. **Interior projects** — follow a RAK fit-out: timeline, site photos, payments, documents, designs, and approvals.

The shop works without an account. Projects, checkout, orders, saved addresses, notifications, and support require a signed-in phone number.

Everything in this build runs **on the device**. There is no live backend. Data lives in a local SQLite database (Drift). Sign-in uses a fixed demo code. Payment, consultant replies, and order status changes are simulated so the screens can be exercised end to end.

## Try it

```bash
flutter pub get
flutter run
```

The app opens on **Shop** (`/shop`).

### Demo phones

The OTP screen accepts one code for every number: **`123456`**.

| Phone | Name | What you get |
| --- | --- | --- |
| `+919876540001` | Anjali Menon | Two interior projects, site updates, finance, documents, designs, and notifications |
| `+919876540002` | Rahul Nair | Shop buyer only. No linked project |
| Any other `+` number | Guest buyer | A new account is created on first successful code. No project |

Enter the number with a country code, for example `+91 98765 40001`. The code expires after 5 minutes. Resend waits 30 seconds. A session lasts 12 hours and is restored from secure storage on the next launch.

## What the customer sees

Five tabs stay at the bottom. They hide on product, checkout, visualise, sales-kit, and review screens.

| Tab | Route | Signed in? | What it does |
| --- | --- | --- | --- |
| Home | `/home` | Optional | Storefront plus a project progress card when this account has interior work |
| Shop | `/shop` | No | Categories, search, filters, favourites, branch, product detail |
| Cart | `/cart` | No to browse, yes to pay | Lines, quantities, then checkout |
| Orders | `/orders` | Yes | Shop orders and tracking |
| Account | `/account` | Optional | Profile, favourites, enquiries, addresses, notifications, projects, support |

### Shop

Products belong to Furniture, Lighting, Storage, or Decor. Each product has a sales mode:

- **Fixed price** and **made to order** can go in the cart.
- **Quotation only** (the walk-in wardrobe) cannot. The customer sends an enquiry instead.

A product page can also open:

- **AR camera** (`/shop/products/:id/ar`) — place the piece with the device camera.
- **360** (`/shop/products/:id/360`) — spin the product.
- **Visualise** (`/shop/products/:id/visualise`) — a guided AI or AR walkthrough, plus saved looks.

The selected **branch** starts as Kochi. Trivandrum, Calicut, and Bangalore are also listed. In this demo the oak dining table and the linen sofa are unavailable in Bangalore. Adding one of those while Bangalore is selected returns “not available at this branch.”

Favourites are kept in memory for the current app session (`FavouritesCubit`). They are not written to the database.

### Enquiry (not an order)

`/enquiry` records a message, optionally tied to a product and the signed-in account. Guests can send one too. Status moves only inside the demo:

`submitted` → `contacted` → `quote_prepared` → `accepted` or `declined` → `closed`

An accepted quote is still not a shop order.

### Cart and checkout

A guest cart exists before sign-in. Checkout, payment, and the address book require a session. If a signed-out customer opens one of those routes, the app sends them to `/login` and returns them afterward.

Checkout path:

1. `/checkout` — review the cart and delivery details.
2. `/address` — save name, mobile, line, and postcode. One address per account.
3. `/checkout/pay` — demo payment.
4. `/checkout/confirmed` — order created and cart cleared.
5. `/checkout/pending` or `/checkout/failed` — the bank has not confirmed, or the demo payment was declined. The cart stays as it was.

Money is stored in minor units (paise) with currency `INR`.

### Orders

An order status is one of:

`confirmed` → `preparing` → `dispatched` → `delivered`

Cancellation is offered while the order is `confirmed` or `preparing`. After dispatch the customer can request a return. Later demo states are `cancellation_requested`, `under_review`, `cancellation_rejected`, `cancelled`, `return_requested`, `refund_initiated`, and `refund_completed`. Tracking is `/orders/:id`.

### Interior projects

Project screens are outside the tab shell and require sign-in. Anjali’s account (`hasProjects: true`) is the one with data.

| Route | Screen |
| --- | --- |
| `/projects/overview` | Welcome home: project cards and next steps |
| `/projects` | Project list |
| `/projects/:id/timeline` | Milestones |
| `/projects/:id/updates` | Published site photos and notes |
| `/projects/:id/payments` | Contract, received, due, and ledger |
| `/projects/:id/documents` | Quotations, agreements, invoices |
| `/projects/:id/designs` | Approved drawings |
| `/projects/:id/handover` | Handover |
| `/projects/:id/review/...` | Approve or reject a quotation or a design |

Seeded projects:

- **Panampilly Nagar villa** — interior fit-out, 62% , target handover 15 Dec 2026.
- **HSR Layout apartment** — design development.

Unpublished and withdrawn photos, draft documents, and unapproved designs stay out of the customer lists. Opening a photo, document, or design asks for a short-lived access grant (2 minutes in the demo) before the viewer shows it.

The review centre walks through confirm, reject, closed, and result screens. Those decision screens are presentation flows over the seeded project; they are not a second order system.

Home (`/home`) shows a compact progress card for an interior account by reading `HomeProjectRepository`. That contract lives in `core/domain` so the shop home does not import the projects feature.

### Support and notifications

- `/support` lists queries. `/support/new` creates one and can be prefilled with `projectId` or `orderId`.
- Status labels are Sent, Consultant replied, and Closed. The reply text in this build is a fixed demo sentence.
- `/notifications` lists in-app messages for the account. Tapping a target the account cannot open goes to `/access-denied`.
- On sign-in the app registers a local device record. On sign-out it unregisters it. Push permission is off in the demo identity.

### Account

Signed-in account links: favourites, quote enquiries, saved addresses, notifications, project home, projects, support, about, terms, sign out, and delete account.

Delete account sends a second OTP (`purpose: delete_account`) and then removes the session. Sign-out clears the secure session and auth rows, then opens `/login`.

## How a screen gets its data

```
Page  →  Cubit  →  Use case  →  Repository  →  Local datasource  →  Drift (SQLite)
```

- **Pages** draw UI and call the cubit. They do not talk to the database.
- **Cubits** (`flutter_bloc`) hold loading, loaded, empty, and error states.
- **Use cases** are the actions: `GetProducts`, `AddCartItem`, `PlaceOrder`, `VerifyOtp`, and so on. They check simple rules (empty id, phone shape) and then call a repository.
- **Repositories** are abstract in `domain/` and implemented in `data/`. They return `Result<T>`: `Success(value)` or `Err(Failure)`.
- **Datasources** run Drift queries.

Failures the UI can show: network, unauthorized, validation, not found, conflict, rate limited, and unknown. In this local build most failures are validation, not found, or unauthorized.

Three cubits are created once at startup and shared by the whole app:

- `SessionCubit` — unknown, signed out, or signed in.
- `FavouritesCubit` — saved product ids for this run.
- `ShopBranchCubit` — selected showroom.

Other cubits are created when their page opens.

## Startup

`main.dart` does four things:

1. Locks the status-bar style.
2. `configureDependencies()` builds the GetIt graph (`sl`) and opens the database.
3. `SessionCubit.restore()` reads the saved session.
4. `RakCustomerApp` mounts the theme, those three cubits, and the router.

`AppDatabase.seedIfNeeded()` fills the database the first time, then tops up updates, finance, tracking, and India locale rows if an older install is missing them. Schema version is 5.

## Routing and sign-in gates

`lib/app/router.dart` builds a `GoRouter`. The initial location is `/shop`.

The router listens to `SessionCubit`. While the session is still `SessionUnknown` it does not redirect, so a cold start does not bounce the user. After that, these paths require a session:

`/projects`, `/notifications`, `/checkout`, `/orders`, `/address`, `/access-denied`, `/account/delete`, `/support/` (a specific ticket or new query).

The support list itself (`/support`) can open signed out; creating or opening a ticket cannot.

`AuthReturn` remembers the page the customer was trying to open (`/login?from=...`) and sends them back after the code is accepted. Cancelling sign-in lands on a safe tab: cart for checkout, account for projects, shop otherwise.

## Where code lives

```
lib/
  main.dart                 app entry
  app/                      RakCustomerApp, GoRouter, bottom tabs
  core/
    config/                 demo timings, feature flags
    di/                     GetIt registration
    domain/                 shared entities and repository contracts
    data/db/                Drift tables, database, seed
    storage/                secure session
    theme/                  colors, type, spacing
    navigation/             return-after-login
  features/
    auth/                   phone, OTP, session, account
    catalogue/              shop, product, branch, enquiry, AR, visualise
    cart/                   cart, checkout, orders
    home/                   project overview and sales kit
    projects/               list, timeline, handover, approvals
    updates/                site photos
    finance/                balances and ledger
    documents/              project files
    designs/                approved drawings
    support/                consultant queries
    notifications/          in-app messages and device register
  shared/                   buttons, page chrome, photos, formatters
```

Each feature is split the same way:

```
features/<name>/
  domain/     entities, repository interfaces, use cases   (pure Dart)
  data/       Drift datasources and repository implementations
  presentation/  cubits, pages, widgets
```

Features do not import each other. Shared reads go through `core/domain`:

- `AuthRepository` — session contract used outside auth.
- `CartCountRepository` — shop badge count.
- `HomeProjectRepository` — progress card on the storefront home.
- `ShopBranchRepository` — selected branch, also checked before add-to-cart.
- `AssetAccessRepository` — short-lived grants for photos and files.

`FeatureFlags` has `trackingEnabled` and `commerceEnabled`, both true.

## Local data

The database file is `rak_customer`. Tables cover accounts, OTP challenges, auth sessions, projects, milestones, categories, products, carts, cart lines, site updates, assets, balances, ledger, due dates, documents, designs, support queries, devices, notifications, delivery addresses, shop orders, order lines, product enquiries, and an `app_meta` seed marker.

Demo constants live in `lib/core/config/local_demo_config.dart`. Seed content lives in `lib/core/data/db/seed.dart`.

## What is real and what is still a demo

| Real in this app | Simulated |
| --- | --- |
| Navigation, validation, local persistence, session restore | SMS delivery — the code is always `123456` |
| Cart math, branch availability, enquiry records | Card payment and bank confirmation |
| Project, finance, document, and design lists from SQLite | Consultant replies and enquiry status changes |
| Signed-out vs signed-in route guards | Push notifications (`pushPermissionGranted` is false) |

Replacing a local repository with a network one means implementing the same domain interface and changing the GetIt registration in `lib/core/di/injection.dart`. Pages and use cases stay as they are.
