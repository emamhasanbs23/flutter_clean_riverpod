import java.io.FileInputStream
import java.util.Locale
import java.util.Properties

plugins {
    id("com.android.application")
    id("dev.flutter.flutter-gradle-plugin")
}

val googleServicesFlavors = listOf("dev", "staging", "prod")
fun googleServicesJsonFor(flavor: String) = file("src/$flavor/google-services.json")
val hasGoogleServicesConfig =
    googleServicesFlavors.any { googleServicesJsonFor(it).exists() }

// Apply the Google Services plugin only when at least one flavor's
// google-services.json is present. Variants for flavors without a file
// disable their process*GoogleServices task in afterEvaluate below.
if (hasGoogleServicesConfig) {
    apply(plugin = "com.google.gms.google-services")
}

// Release signing config. The keystore path/credentials live in
// `android/key.properties` (gitignored). When the file is missing the build
// falls back to the debug keystore so first-run / CI debug builds still
// succeed. Production releases must populate key.properties — see
// `android/key.properties.example`.
val keystoreProperties = Properties().apply {
    val file = rootProject.file("key.properties")
    if (file.exists()) {
        load(FileInputStream(file))
    }
}

android {
    namespace = "com.example.flutter_clean_riverpod_boilerplate"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "com.example.flutter_clean_riverpod_boilerplate"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // --- Flavors ---
    // dev and staging get unique applicationIdSuffixes so they can coexist
    // on a single device. prod uses the default applicationId from
    // defaultConfig. The `deepLinkScheme` and `deepLinkHost` placeholders
    // are wired into AndroidManifest.xml so each flavor owns a distinct
    // custom-scheme (e.g. `boilerplate-dev://`) and Universal/App Link host.
    flavorDimensions += "environment"
    productFlavors {
        create("dev") {
            dimension = "environment"
            applicationIdSuffix = ".dev"
            versionNameSuffix = "-dev"
            resValue("string", "app_name", "Boilerplate (Dev)")
            manifestPlaceholders["deepLinkScheme"] = "boilerplate-dev"
            manifestPlaceholders["deepLinkHost"] = "dev.example.com"
        }
        create("staging") {
            dimension = "environment"
            applicationIdSuffix = ".staging"
            versionNameSuffix = "-staging"
            resValue("string", "app_name", "Boilerplate (Staging)")
            manifestPlaceholders["deepLinkScheme"] = "boilerplate-staging"
            manifestPlaceholders["deepLinkHost"] = "staging.example.com"
        }
        create("prod") {
            dimension = "environment"
            resValue("string", "app_name", "Boilerplate")
            manifestPlaceholders["deepLinkScheme"] = "boilerplate"
            manifestPlaceholders["deepLinkHost"] = "example.com"
        }
    }

    signingConfigs {
        create("release") {
            if (keystoreProperties.isNotEmpty()) {
                keyAlias = keystoreProperties["keyAlias"] as String?
                keyPassword = keystoreProperties["keyPassword"] as String?
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String?
            }
        }
    }

    buildTypes {
        release {
            // Sign with the release keystore when key.properties is
            // populated; otherwise fall back to the debug key so the build
            // doesn't break for contributors who haven't set one up yet.
            signingConfig = if (keystoreProperties.isNotEmpty()) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }

            // Enable code shrinking + obfuscation. ProGuard rules are
            // loaded from android/app/proguard-rules.pro (keeps Flutter,
            // Riverpod, fpdart, dio, etc.).
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro",
            )
        }
    }
}

flutter {
    source = "../.."
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

afterEvaluate {
    if (!hasGoogleServicesConfig) {
        return@afterEvaluate
    }
    android.applicationVariants.configureEach {
        val flavorName =
            productFlavors
                .firstOrNull { flavor -> flavor.dimension == "environment" }
                ?.name
                ?: return@configureEach
        if (googleServicesJsonFor(flavorName).exists()) {
            return@configureEach
        }
        val taskName =
            "process${name.replaceFirstChar { char ->
                if (char.isLowerCase()) char.titlecase(Locale.getDefault()) else char.toString()
            }}GoogleServices"
        tasks.findByName(taskName)?.enabled = false
    }
}