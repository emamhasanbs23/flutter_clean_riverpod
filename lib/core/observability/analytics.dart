import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'analytics.g.dart';

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

@Riverpod(keepAlive: true)
Analytics analytics(Ref ref) {
  return const NoOpAnalytics();
}
