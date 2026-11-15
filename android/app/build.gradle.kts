import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// F-06: real release signing. The keystore is described in key.properties,
// which is gitignored and never committed. If it is missing we fail the
// release build instead of silently falling back to the debug keystore.
val keystorePropertiesFile = rootProject.file("key.properties")
val hasKeystore = keystorePropertiesFile.exists()
val keystoreProperties = Properties()
if (hasKeystore) {
    FileInputStream(keystorePropertiesFile).use { keystoreProperties.load(it) }
}

android {
    namespace = "com.rakinteriors.rak_customer"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.rakinteriors.rak_customer"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        // ARCore scene view requires API 28. Phones without ARCore can still install.
        minSdk = maxOf(flutter.minSdkVersion, 28)
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        if (hasKeystore) {
            create("release") {
                keyAlias = keystoreProperties["keyAlias"] as String?
                keyPassword = keystoreProperties["keyPassword"] as String?
                storeFile = (keystoreProperties["storeFile"] as String?)?.let { file(it) }
                storePassword = keystoreProperties["storePassword"] as String?
            }
        }
    }

    buildTypes {
        release {
            // Use the real upload key. Never the debug keystore (F-06).
            signingConfig = if (hasKeystore) signingConfigs.getByName("release") else null

            // R8: shrink + obfuscate. Keeps live in proguard-rules.pro.
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro",
            )
        }
    }
}

// Fail a release assembly/bundle early and clearly if signing is not configured,
// rather than shipping an unsigned or debug-signed artifact (F-06). This only
// trips when a release task is actually in the graph, so debug builds and tests
// are unaffected.
gradle.taskGraph.whenReady {
    val buildingRelease = allTasks.any { task ->
        task.name.contains("Release") &&
            (
                task.name.startsWith("assemble") ||
                    task.name.startsWith("bundle") ||
                    task.name.startsWith("package")
            )
    }
    if (buildingRelease && !hasKeystore) {
        throw GradleException(
            "Release signing is not configured: android/key.properties is missing. " +
                "Create it (gitignored) with storeFile/storePassword/keyAlias/keyPassword " +
                "pointing at your upload keystore. The release build must not use the debug keystore. " +
                "See README.md.",
        )
    }
}

flutter {
    source = "../.."
}
