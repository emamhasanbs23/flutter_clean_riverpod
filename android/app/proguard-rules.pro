# ProGuard / R8 rules for release builds.
#
# Flutter and most plugins ship consumer ProGuard rules of their own, so
# this file only needs to cover rules specific to our app's third-party
# dependencies. Add new rules here when you add a dependency whose
# symbols get stripped during release.

# --- Flutter ---
# Flutter's embedding keeps its own rules; nothing extra is needed here.

# --- Dio ---
# Dio uses reflection in places; keep its public surface so deserialization
# keeps working after R8.
-keep class com.google.gson.** { *; }
-keep class io.ktor.** { *; }
-dontwarn org.bouncycastle.**
-dontwarn org.conscrypt.**
-dontwarn org.openjsse.**

# --- fpdart ---
# Sealed unions rely on RTTI; keep them intact.
-keep class io.github.aparnachidambaram.** { *; }

# --- Riverpod ---
# Riverpod's generated providers are accessed via reflection in some
# patterns; keep them.
-keep class * extends androidx.lifecycle.ViewModel { *; }
-keep class * implements io.flutter.embedding.engine.plugins.FlutterPlugin { *; }

# --- Keep line numbers so crash reports (Sentry/Crashlytics) stay useful ---
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile