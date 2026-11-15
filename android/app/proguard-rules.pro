# F-06 — R8 keep rules for release builds.
# Keep what Flutter, drift/sqlite3 and the AR/camera plugins need so shrinking
# and obfuscation don't strip classes reached only via JNI/reflection.
# Verify a release build still runs after changing these:
#   flutter build appbundle --release --obfuscate --split-debug-info=build/symbols

# --- Flutter engine / embedding ---
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.** { *; }
-dontwarn io.flutter.**

# --- sqlite3 / sqlite3_flutter_libs (drift native backend) ---
# Native SQLite is reached over JNI; keep its loader and any native methods.
-keep class com.github.requery.** { *; }
-keep class org.sqlite.** { *; }
-keepclasseswithmembernames class * {
    native <methods>;
}
-dontwarn org.sqlite.**

# --- ARCore + Filament / SceneView (ar_flutter_plugin_2, AR camera) ---
-keep class com.google.ar.** { *; }
-keep class com.google.android.filament.** { *; }
-keep class io.github.sceneview.** { *; }
-keep class io.github.plugins.** { *; }
-dontwarn com.google.ar.**
-dontwarn com.google.android.filament.**
-dontwarn io.github.sceneview.**

# --- flutter_secure_storage (Android Keystore / EncryptedSharedPreferences) ---
-keep class androidx.security.crypto.** { *; }
-dontwarn androidx.security.crypto.**

# Keep annotations / generic signatures used for reflection.
-keepattributes *Annotation*,Signature,InnerClasses,EnclosingMethod
