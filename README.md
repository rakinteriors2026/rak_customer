# RAK Interiors customer

Flutter app for the RAK Interiors shop and for following an interior project: timeline, site photos, payments, documents, designs, and approvals.

The shop works without an account. Projects, checkout, orders, and support need a signed-in phone number. This build stores everything on the device (SQLite). The demo OTP is `123456`.

Full walkthrough of screens, sign-in, data flow, and folder layout:

**[docs/HOW_THE_APP_WORKS.md](docs/HOW_THE_APP_WORKS.md)**

```bash
flutter pub get
flutter run
```

Demo accounts: `+919876540001` (projects) and `+919876540002` (shop only).

## Release builds (Android)

Release builds are signed with a real upload key, never the debug keystore
(F-06). Create `android/key.properties` (gitignored, never committed):

```properties
storeFile=/absolute/path/to/upload-keystore.jks
storePassword=••••••
keyAlias=upload
keyPassword=••••••
```

Without this file the release build fails fast with a clear message. Build the
obfuscated release artifact with:

```bash
flutter build appbundle --release --obfuscate --split-debug-info=build/symbols
```

Then verify the artifact is not debug-signed and backups are disabled:

```bash
tool/verify_release.sh
```

### Demo builds

Debug/profile builds enable the local demo (fixed OTP `123456`, seeded demo
accounts). A release build has the demo disabled unless you opt in explicitly
for a stakeholder/TestFlight demo:

```bash
flutter build appbundle --release --dart-define=ALLOW_DEMO=true \
  --obfuscate --split-debug-info=build/symbols
```

Demo release builds show a persistent **DEMO BUILD** banner so they can't be
mistaken for production.
