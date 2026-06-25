import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Abstraction for product analytics.
///
/// Concrete implementations forward events to Firebase Analytics, Segment,
/// Mixpanel, etc. The default [NoOpAnalytics] silently discards events so
/// the app works without any backend configured.
abstract interface class Analytics {
  /// Records a named event with optional parameters.
  void logEvent(String name, {Map<String, Object?>? parameters});

  /// Records a screen view.
  void logScreenView(String screenName);

  /// Sets user properties (called after sign-in).
  void setUserProperty(String name, {String? value});
}

class NoOpAnalytics implements Analytics {
  const NoOpAnalytics();

  @override
  void logEvent(String name, {Map<String, Object?>? parameters}) {}

  @override
  void logScreenView(String screenName) {}

  @override
  void setUserProperty(String name, {String? value}) {}
}

final analyticsProvider = Provider<Analytics>((ref) {
  return const NoOpAnalytics();
});