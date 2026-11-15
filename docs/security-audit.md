# RAK Customer — Frontend Security Audit

**Scope:** `lib/**`, `android/**`, `ios/**`, `pubspec.yaml`, `pubspec.lock`, build configs, assets.
**Type:** Read-only review. No code was changed.
**Context:** No backend yet. Everything runs on local Drift/SQLite with a simulated OTP (`123456`), simulated payments, support replies and order-status changes. Findings are split into **real weaknesses today** and **demo shortcuts** that become vulnerabilities once they ship or are carried into the API integration.

Line numbers are from the files as read during this audit. Where something could not be confirmed, it is marked **not verified**.

---

## 1. Executive summary — top 5 risks

1. **Fixed OTP (`123456`) and demo accounts are not gated behind any flavor/debug flag.** The demo code is used by the live auth path and the demo phones are always seeded, so a release build would ship a universal login bypass. (`F-01`)
2. **Asset access is not scoped to the signed-in account.** `requestAccess(assetId)` only checks `published`/`withdrawn`, never ownership. This is a textbook IDOR the moment a real file API is wired in, and today it lets any signed-in account open any published asset by ID. (`F-02`)
3. **Session access/refresh tokens are persisted in plaintext Drift/SQLite** (`AuthSessions` table) in addition to secure storage, and the DB has no backup protection. (`F-03`)
4. **The client decides payment success.** `placeOrder` writes `status: 'confirmed'` directly, with no pending→confirmed transition and no idempotency key. (`F-04`)
5. **OTP verification has no attempt limit or lockout, and a challenge stays valid for its full 5-minute TTL after a wrong guess** — brute-forceable once the OTP is real. (`F-05`)

Honorable mentions: Android release is signed with the **debug keystore** and `allowBackup` defaults to on (`F-06`); in-memory caches (`FavouritesCubit`, asset-access cache) survive logout/account switch (`F-07`).

**Positives worth keeping:** project/finance/document/design/support/notification/order reads all funnel through `getOwned(...)`-style queries scoped by `accountId` (`project_local_datasource.dart:19`, `finance_local_datasource.dart:11`, `documents_local_datasource.dart:18`, `designs_local_datasource.dart:18`, `support_local_datasource.dart:24`, `notifications_local_datasource.dart:19`, `checkout_local_datasource.dart:159`). Notification taps re-check access before navigating (`notifications_local_datasource.dart:38`). Money is stored and computed in integer minor units. No `print`/`debugPrint` logging of secrets anywhere in `lib/`.

---

## 2. Findings table

| ID | Severity | Category | File:line | What's wrong | Why it matters | Recommended fix | Classification |
|----|----------|----------|-----------|--------------|----------------|-----------------|----------------|
| F-01 | Critical | Auth | `lib/core/config/local_demo_config.dart:2`; `lib/features/auth/data/datasources/auth_local_datasource.dart:38`; `lib/core/data/db/app_database.dart:92`; `lib/core/data/db/seed.dart:21,33` | Fixed OTP `123456` is used by the live `requestOtp` path; demo phones `+919876540001/2` are always seeded via `seedIfNeeded()`. No `kDebugMode`/flavor/`--dart-define` gate exists anywhere. | A release build would accept `123456` for every number and ship two real login identities. Universal auth bypass. | Gate demo OTP + seeding behind a build flag (`kReleaseMode`/flavor); in release, demo code path must be unreachable and demo accounts not seeded. | Fix before API integration / demo shortcut to remove |
| F-02 | High | AuthZ / IDOR | `lib/core/data/datasources/asset_access_local_datasource.dart:23-47`; `lib/features/updates/data/datasources/updates_local_datasource.dart:82-107` | `requestAccess(assetId)` validates only `published` and `withdrawn`; it never checks the asset belongs to a project the account owns. | Lists are ownership-scoped, but access-by-raw-ID is not. A buyer-only account (Rahul) that learns/guesses an asset ID (e.g. `ast_doc_agreement`) can open another customer's file. Becomes a classic IDOR against the real file API. | Require `accountId` + `projectId` and verify ownership before issuing access; server must sign URLs scoped to the caller. | Fix now (isolation) + Fix before API integration |
| F-03 | High | Local data / secrets | `lib/core/data/db/tables.dart:31-41`; `lib/features/auth/data/datasources/auth_local_datasource.dart:123-133` | Access + refresh tokens are written to the plaintext `AuthSessions` Drift table, not only to `flutter_secure_storage`. | Tokens in a plain SQLite file (plus Android default backup, F-06) are recoverable off-device. The question "tokens only in secure storage?" is **answered: no**. | Stop persisting real tokens in Drift; keep them only in secure storage. If a local sessions table is needed for the demo, store opaque non-secret IDs. Encrypt the DB (F-08). | Fix before API integration |
| F-04 | High | Payments | `lib/features/cart/data/datasources/checkout_local_datasource.dart:109,118,57-70` | Client writes `status: 'confirmed'` on order insert; order ID is `ord_<microseconds>`; the only idempotency guard is an in-process `_placing` bool on a singleton. | Client-decided success cannot be trusted. No pending→confirmed state and no client-generated idempotency key means the API integration can't dedupe retries or reconcile real payment state. | Introduce `pending`→`confirmed` states; generate an idempotency key before the call; let the server set final state. Keep money in minor units (already done). | Fix before API integration / demo shortcut |
| F-05 | High | Auth / session | `lib/features/auth/presentation/cubit/otp_entry_cubit.dart:79-104`; `lib/features/auth/data/datasources/auth_local_datasource.dart:52-78` | No verify-attempt counter or lockout; `consumeOtp` marks `consumed` only on success, so a wrong code leaves the challenge usable for the full `otpTtl` (5 min). | Once OTP is real, a 6-digit code is brute-forceable within the TTL. Resend cooldown is enforced but attempt count is not. | Add per-challenge attempt limit + lockout; invalidate challenge after N failures; enforce server-side rate limiting. | Fix before API integration |
| F-06 | High | Platform (Android) | `android/app/build.gradle.kts:36-38`; `android/app/src/main/AndroidManifest.xml` (no `allowBackup`) | Release build is signed with the debug keystore; `android:allowBackup` is unset (defaults to **true**); no R8/minify; no `dataExtractionRules`/`fullBackupContent`; Dart obfuscation not configured. | Debug-signed release is untrusted/unupgradable; default backup lets the plaintext DB (F-03/F-08) be extracted via `adb`/cloud backup. | Add a real release signing config; set `allowBackup="false"` (or `dataExtractionRules`); enable R8 + `--obfuscate --split-debug-info` for release. | Fix before release |
| F-07 | Medium | Session / data isolation | `lib/core/di/injection.dart:185`; `lib/app/app.dart:22`; `lib/features/auth/presentation/cubit/session_cubit.dart:60-67`; `lib/core/data/datasources/asset_access_local_datasource.dart:19`; `lib/features/updates/data/datasources/updates_local_datasource.dart:22` | `FavouritesCubit` is an app-wide lazy singleton never reset on `signOut`; asset-access in-memory caches (`_sessionAccess`) are singletons not cleared on logout. | Favourites and any still-valid in-memory asset grants survive into the **next** account in the same process. Stale cross-account data. | On logout/switch, clear `FavouritesCubit`, drop asset-access caches, and reset per-account cubits (notifications/cart already keyed by accountId). | Fix now |
| F-08 | Medium | Local data protection | `lib/core/data/db/app_database.dart:43`; `lib/core/data/db/tables.dart:16-28,255-325` | Drift uses plain SQLite. It holds accounts, phone numbers, delivery addresses, ledger/finance, orders, device/push tokens, support messages, auth tokens (F-03) and **OTP challenge codes in plaintext** (`OtpChallenges.code:21`). | A rooted/jailbroken or backed-up device exposes all of it. Plaintext OTP codes + tokens are the most sensitive. | Use an encrypted executor (SQLCipher via drift) with the key in `flutter_secure_storage`; stop storing OTP codes in clear (hash, or don't persist). | Fix before API integration |
| F-09 | Medium | Payments / state | `lib/features/cart/domain/usecases/update_shop_order_status.dart:10-28`; `lib/features/cart/presentation/cubit/order_tracking_cubit.dart:48-58`; `lib/features/support/data/datasources/support_local_datasource.dart:124-139` | Order status and support ticket status are client-authoritative and changeable from the UI (`advance(status)`, `updateStatus`). Both are account-scoped, but the client sets the value. | A user can drive order/support state transitions locally. Acceptable for demo; must not be the source of truth once APIs exist. | Make status server-owned; client only requests transitions. Keep the existing account scoping. | Demo-only, acceptable → Fix before API integration |
| F-10 | Medium | Dependencies | `pubspec.lock` (`sqlite3_flutter_libs 0.6.0+eol`, `ar_flutter_plugin_2 0.0.3`) | `sqlite3_flutter_libs` is pinned to an **EOL** build (`+eol`); `ar_flutter_plugin_2` is a `0.0.x` pre-release with uncertain maintenance. | EOL/unmaintained native deps stop getting security fixes. | Run `flutter pub outdated`; move off the EOL `sqlite3_flutter_libs`; re-evaluate `ar_flutter_plugin_2` maintenance before release. | Fix before release |
| F-11 | Medium | Input validation | `lib/features/support/presentation/pages/create_query_page.dart:118-138`; `lib/features/cart/presentation/cubit/address_form_cubit.dart`; `lib/features/cart/domain/usecases/save_delivery_address.dart:20-42` | Support subject/message have no length cap (only `minLines/maxLines`). Address name/mobile/line are only trimmed + non-empty (mobile has no format/length check); pincode is validated (6-digit + demo-region regex). | Unbounded free text risks storage/DoS and injection once sent to an API/HTML. Mobile with no validation produces bad data. | Add `maxLength` and server-side length caps; validate/normalize mobile (E.164). | Fix before API integration |
| F-12 | Low | Platform / privacy | `lib/features/auth/presentation/pages/otp_entry_page.dart:106-121`; `lib/features/support/presentation/pages/create_query_page.dart`; whole app (no `FLAG_SECURE`) | OTP/address/support `TextField`s don't disable keyboard suggestions/autocorrect or use autofill hints; no screenshot/app-switcher protection on payment, ledger or document screens. | Keyboard caches sensitive text; OS app-switcher snapshots can expose finance/documents. | Set `autocorrect:false`, `enableSuggestions:false` on sensitive fields; add `autofillHints: [oneTimeCode]`; apply secure-flag/snapshot blur on payment/ledger/document routes. | Fix before release |
| F-13 | Low | Platform (iOS keychain) | `lib/core/storage/secure_session_storage.dart:6` | `const FlutterSecureStorage()` uses library defaults — no `IOSOptions` accessibility or explicit `AndroidOptions`. | Default keychain accessibility may be more permissive than needed; **not verified** which class applies. | Set `IOSOptions(accessibility: first_unlock_this_device)` and confirm Android encrypted storage. No ATS override exists, which is the secure default (keep it). | Fix before release |
| F-14 | Low | Navigation / redirect | `lib/core/navigation/auth_return.dart:3-7`; `lib/features/auth/presentation/pages/otp_entry_page.dart:71-74`; `lib/app/router.dart:140-143` | The remembered `from` location is an arbitrary in-app path (+ query) that is navigated to after sign-in. | After signing in as a different account, a crafted `?from=/projects/x/documents` lands on a gated screen. Impact is bounded because those screens re-check ownership via `getOwned` — **except** asset access (see F-02). `extra` cannot be injected via URL; this is in-app `go()` only, not an external open-redirect. | Allowlist return paths; rely on ownership checks at the datasource (already present) and fix F-02. | Fix before API integration |
| F-15 | Low | Asset expiry | `lib/features/updates/presentation/pages/asset_viewer_page.dart:36-78` vs `lib/features/documents/presentation/pages/document_viewer_page.dart:67-100` | Document viewer re-checks `isExpiredAt(now)` at build and shows an expired-link message; the photo/asset viewer renders `SitePhoto` without an at-view expiry check (only re-checks on reopen/`_recheck`). | A photo already on screen stays visible past the 2-minute grant until the page rebuilds. Grants are **not** persisted to Drift/disk (good), so exposure is in-memory only. | Mirror the document viewer's at-view expiry check in the asset viewer; show the withdrawn/expired placeholder when elapsed. | Fix before API integration |
| F-16 | Low | Session restore window | `lib/app/router.dart:125-126`; `lib/main.dart:12-14` | Redirect returns `null` for `SessionUnknown`, i.e. gated routes would render during the unknown state. | Today this is mitigated: `main.dart` **awaits** `sessionCubit.restore()` before `runApp`, so the UI never starts in `SessionUnknown`. If restore ever becomes async-after-start, the window reopens. | Keep awaiting restore; consider rendering a splash/guard for `SessionUnknown` instead of allowing through. | Demo-only, acceptable (monitor) |
| F-17 | Info | Injection (SQL) | `lib/core/data/db/seed.dart:699-707` | Only raw SQL is `customStatement` with hardcoded constant strings (no interpolation of user input). | No SQL injection vector today; all user-facing queries use drift's typed builders. | None required; keep avoiding string interpolation in `customStatement`/`customSelect`. | Demo-only, acceptable |
| F-18 | Info | API-integration readiness | repo-wide (no `dio`/`http` dependency in `pubspec.yaml`) | No HTTP client, auth/refresh interceptor, request IDs, cert-pinning decision, or 401/403/404/409/429 mapping exists yet. | These must be built before the backend is wired in; absence now is expected but must be tracked. | See §5. | Fix before API integration |
| F-19 | Info | Secrets | `lib/features/auth/presentation/pages/account_extra_pages.dart:30` | Only non-secret constant is a public website URL. No API keys, credentials, keystores, or tokens hardcoded in code/assets/config. | No secret leakage today. | None; keep secrets out of the repo when APIs arrive. | Demo-only, acceptable |

---

## 3. Critical/High — code-level fix sketches + the test that catches it

### F-01 Gate the fixed OTP and demo seeding
**Fix (sketch):**
```dart
// local_demo_config.dart — demo values only usable in non-release builds
static bool get demoAuthEnabled => !const bool.fromEnvironment('dart.vm.product');
```
Guard `AuthLocalDatasource.requestOtp` so that in release it never writes `LocalDemoConfig.demoOtpCode`, and guard `AppDatabase.seedIfNeeded()` so demo accounts/phones are not seeded in release.
**Test (unit):** with the release flag set, `requestOtp` must not store `123456` and `seedIfNeeded()` must not create `acc_projects`/`acc_buyer`. With debug flag, the demo path still works.

### F-02 Scope asset access to the owner
**Fix (sketch):** change `requestAccess` to take `accountId` + `projectId`, and join through `project_documents`/`design_assets`/`site_update_assets` → `projects.accountId == accountId` before issuing an `AssetAccess`; otherwise throw `NotFoundFailure`.
```dart
Future<AssetAccess> requestAccess({required String accountId, required String assetId}) async {
  final owned = await _ownsAsset(accountId, assetId); // ownership join
  if (!owned) throw const NotFoundFailure('This file is no longer available.');
  // ...existing published/withdrawn + TTL logic...
}
```
**Test (unit/data):** Rahul (`acc_buyer`) requesting `ast_doc_agreement` (Anjali's) → `NotFoundFailure`. Owner requesting their own published asset → success. Withdrawn/unpublished → failure (already covered).

### F-03 Keep tokens out of Drift
**Fix (sketch):** remove `accessToken`/`refreshToken` from `AuthSessions` (or store a random session handle), and keep real tokens only in `SecureSessionStorage`.
**Test (data):** after `verifyOtp` + `createSession`, assert the `AuthSessions` row contains no value equal to the issued access/refresh token; assert the tokens are present in the (mocked) `SessionStorage`.

### F-04 Server-confirmable payment state + idempotency
**Fix (sketch):** add an `idempotencyKey` (UUID generated before the call) and an initial `pending` status; a confirmation step moves `pending → confirmed`. Keep the `_placing`/single-flight guard but make it key-based, not an instance bool.
**Test (bloc):** `PlaceOrderCubit.submit()` twice with the same idempotency key creates exactly one order; the order starts `pending` and only becomes `confirmed` on explicit confirmation.

### F-05 OTP attempt limit + invalidate on failure
**Fix (sketch):** add an attempt counter to `OtpChallenges`; in `consumeOtp`, increment on mismatch and throw a lockout failure after N; mark the challenge unusable once the limit is hit.
**Test (unit):** N wrong codes → `(N+1)`th attempt returns a lockout error even if the correct code is then supplied; counter resets on a fresh challenge.

### F-06 Release signing / backup / obfuscation
**Fix (sketch):** add a `release` signing config reading from `key.properties`; set `allowBackup="false"` (or add `dataExtractionRules`); enable `isMinifyEnabled = true` + `isShrinkResources = true`; build release with `--obfuscate --split-debug-info=...`.
**Test (CI check, not unit):** CI assertion that the release APK/AAB is not signed with the debug key and that `allowBackup` is false in the merged manifest.

---

## 4. Demo shortcuts to remove before release (checklist)

- [ ] **Fixed OTP `123456`** — `local_demo_config.dart:2`, consumed at `auth_local_datasource.dart:38`. (F-01)
- [ ] **Demo account seeding** — `+919876540001`/`+919876540002`, Anjali/Rahul and their projects/finance/docs/tickets: `seed.dart` + `app_database.dart:92`. (F-01)
- [ ] **Deliberate cross-account seed rows** used for isolation testing (`qry_someone_else`, `ntf_denied`, `prj_not_yours`) — `seed.dart:472-474,635-672`. Remove before release.
- [ ] **Client-side `status:'confirmed'` order creation** and timestamp order IDs — `checkout_local_datasource.dart:109,118`. (F-04)
- [ ] **Client-driven order/support status transitions** — `update_shop_order_status.dart`, `support_local_datasource.dart:124`. (F-09)
- [ ] **Local demo timings as security behaviour** — `accessTokenTtl`, `assetAccessTtl`, `resendCooldown`, `otpTtl` in `local_demo_config.dart:3-7` must be server-owned, not client constants.
- [ ] **Tokens persisted in Drift** — `tables.dart:31-41`. (F-03)
- [ ] **Plaintext OTP codes in Drift** — `tables.dart:21`. (F-08)
- [ ] **Debug keystore for release** + default backup — `build.gradle.kts:36-38`. (F-06)
- [ ] **`local-asset://` fake "signed" URLs** — `asset_access_local_datasource.dart:41`, `updates_local_datasource.dart:100`; replace with real signed URLs. (F-02)
- [ ] **All `*_local_datasource.dart` demo datasources/repositories** must be swapped for API-backed implementations (they are DI-wired in `core/di/injection.dart` and are the only impls today). (F-18)
- [ ] **`sqlite3_flutter_libs 0.6.0+eol`** EOL pin. (F-10)

---

## 5. Prioritised remediation plan

**P0 — before any release build exists (do now):**
1. F-01 Gate demo OTP + seeding behind release flag.
2. F-06 Real release signing, `allowBackup=false`, R8 + Dart obfuscation.
3. F-07 Clear in-memory state (favourites, asset-access caches) on logout/switch.

**P1 — before the backend is wired in:**
4. F-02 Scope asset access to owner (and replace fake signed URLs).
5. F-03 / F-08 Remove tokens from Drift; encrypt the DB (SQLCipher + secure-storage key); stop storing plaintext OTP codes.
6. F-04 Pending→confirmed payment state + pre-generated idempotency key.
7. F-05 OTP attempt limit/lockout and challenge invalidation.
8. F-18 Build the API layer: `dio` client with auth + single-flight token-refresh interceptor, forced logout on refresh failure, request IDs, 401/403/404/409/429 mapping, a certificate-pinning decision, and a guarantee tokens never reach logs.
9. F-09 Make order/support status server-owned.
10. F-11 Input length caps + mobile normalization.
11. F-15 At-view expiry check in the asset viewer.

**P2 — hardening before public release:**
12. F-10 Resolve EOL/`0.0.x` dependencies; run `flutter pub outdated`.
13. F-12 Disable keyboard suggestions/autofill on sensitive fields; add screenshot/app-switcher protection on payment/ledger/document screens.
14. F-13 Set explicit keychain accessibility (`first_unlock_this_device`) and confirm Android encrypted storage.
15. F-14 Allowlist `AuthReturn` return paths.
16. F-16 Keep awaiting `restore()`; add a guard/splash for `SessionUnknown`.

---

### Verification notes
- `flutter pub outdated` and `flutter analyze` were **not run** (read-only audit). F-10 relies on the pinned versions in `pubspec.lock`.
- iOS keychain accessibility class (F-13) and the exact Android default-backup behaviour on the target OS version are **not verified** at runtime; recommendations are based on library/platform defaults and the absence of explicit configuration.
- No dynamic/runtime testing was performed; all findings are from static review of the cited files.
