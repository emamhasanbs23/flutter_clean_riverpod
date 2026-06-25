import 'package:flutter/foundation.dart';

/// Value type representing a target destination inside the app, decoupled
/// from any transport (deep link URI, push notification payload, in-app
/// trigger, ...).
///
/// Both transports reduce incoming events to a [RouteDescriptor];
/// downstream consumers (router, login flow) never need to know which
/// transport produced it.
///
/// Construction is intentionally constrained:
/// - `path` MUST start with `/` (validated at [toUri] time). The path is
///   the canonical GoRouter path.
/// - `query` is a flat `Map<String, String>` mirroring URI query params.
/// - `extra` is the opaque `GoRouter.state.extra` payload. For push payloads,
///   this lets the backend hand the app things like
///   `{"focus": "title", "scroll_to": "comments"}` without baking them into
///   the URL.
@immutable
class RouteDescriptor {
  /// The constructor is `const` so callers can build descriptors in
  /// `const` contexts (lists, default values, etc.).
  ///
  /// Validates at [toUri] time that [path] starts with `/`. Returning a
  /// nullable from callers (parsers) is the way to reject destinations;
  /// this constructor is only used when the caller has already decided the
  /// input is well-formed.
  const RouteDescriptor({
    required this.path,
    this.query = const {},
    this.extra,
  });

  /// The GoRouter-style path, e.g. `/todos/42`. Always starts with `/`.
  final String path;

  /// Flat query parameter map (strings only). Empty by default.
  final Map<String, String> query;

  /// Opaque payload forwarded as `GoRouter.state.extra`. Allowed to be any
  /// `Map<String, Object?>`; use sparingly and document expected keys.
  final Map<String, Object?>? extra;

  /// Renders this descriptor back to a URI-style string suitable for
  /// `context.go(...)`. Query params are encoded using [Uri].
  Uri toUri() {
    if (!path.startsWith('/')) {
      throw StateError('RouteDescriptor.path must start with "/"; got "$path"');
    }
    final base = Uri.parse(path);
    final mergedQuery = <String, String>{...base.queryParameters, ...query};
    return base.replace(
      queryParameters: mergedQuery.isEmpty ? null : mergedQuery,
    );
  }

  /// Convenience: the same as `toUri().toString()`.
  String toLocation() => toUri().toString();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! RouteDescriptor) return false;
    if (other.path != path) return false;
    if (other.query.length != query.length) return false;
    for (final entry in query.entries) {
      if (other.query[entry.key] != entry.value) return false;
    }
    // extra is compared by reference + key/value equality for primitive
    // types. Pushing nested maps through is fine as long as callers don't
    // mutate the maps after construction.
    if (other.extra == null && extra == null) return true;
    if (other.extra == null || extra == null) return false;
    if (other.extra!.length != extra!.length) return false;
    for (final entry in extra!.entries) {
      if (other.extra![entry.key] != entry.value) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(
    path,
    Object.hashAllUnordered(
      query.entries.map((e) => Object.hash(e.key, e.value)),
    ),
    Object.hashAll(
      (extra ?? const <String, Object?>{}).entries.map(
        (e) => Object.hash(e.key, e.value),
      ),
    ),
  );

  @override
  String toString() =>
      'RouteDescriptor(path: $path, query: $query, extra: $extra)';
}
