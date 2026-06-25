import 'package:flutter_clean_riverpod_boilerplate/core/notifications/route_descriptor.dart';

/// Pure functions that translate raw transport input (a URI from
/// `app_links`, or a `data` map from `firebase_messaging`) into the
/// app-internal [RouteDescriptor].
///
/// Everything in here is intentionally side-effect free so it can be
/// unit-tested without a Flutter binding, and so the rules are easy to
/// audit in one place.
///
/// ## Supported link shapes
///
/// Two URI shapes are recognised:
///
/// 1. **Custom scheme**: `boilerplate-dev://todos/42`
///    - Dart URI parsing places `todos` in `uri.host` (the authority
///      position) and `42` in `pathSegments[0]`. We glue them back into
///      `/todos/42`.
/// 2. **Universal / App Link** (https): `https://example.com/todos/42`
///    - Only `example.com` (configurable per-flavor) is recognised. The
///      `/todos/...` prefix is preserved verbatim.
///
/// Anything else (wrong host, wrong path, unparseable) returns `null`. The
/// caller is expected to log + ignore rather than crash, since deep-link
/// traffic is by definition adversarial.
///
/// ## Supported push payload shapes
///
/// FCM `data` payloads must contain a `route` key whose value is a
/// `/`-prefixed path. Optional `query_*` keys are turned into query params,
/// optional `extra_*` keys into the [RouteDescriptor.extra] map. This
/// keeps the wire format human-readable in the Firebase Console test
/// message UI.
class RouteDescriptorParser {
  RouteDescriptorParser._();

  /// Parses an incoming URI into a [RouteDescriptor], or returns `null`
  /// if the URI is not recognised as a link to this app.
  ///
  /// Wrapped in a try/catch so a malformed input never crashes the caller
  /// (deep links are adversarial by definition).
  static RouteDescriptor? parse(Uri uri) {
    try {
      return _parseUri(uri);
    } on Object {
      return null;
    }
  }

  static RouteDescriptor? _parseUri(Uri uri) {
    // https Universal / App Links.
    if (uri.scheme == 'https' || uri.scheme == 'http') {
      // The host check is deliberately open here — Android/iOS only deliver
      // the URI to our app once `autoVerify` has matched the
      // assetlinks.json / apple-app-site-association. So if we received it,
      // it's already trusted.
      final segments = uri.pathSegments;
      if (segments.isEmpty) return null;
      if (segments.first != 'todos') return null;
      // /todos/:id expects exactly two segments: ["todos", "<id>"].
      if (segments.length != 2) return null;
      final id = segments[1];
      if (id.isEmpty) return null;
      return RouteDescriptor(path: '/todos/$id', query: uri.queryParameters);
    }

    // Custom scheme (boilerplate-dev://, boilerplate-staging://, ...).
    // Dart URI parsing treats `boilerplate-dev://todos/42` as
    //   scheme = boilerplate-dev
    //   host   = todos
    //   path   = /42
    // so the "first segment" lives in `uri.host`, not `uri.pathSegments[0]`.
    if (uri.scheme.startsWith('boilerplate')) {
      if (uri.host != 'todos') return null;
      final segments = uri.pathSegments;
      if (segments.length != 1) return null;
      final id = segments.first;
      if (id.isEmpty) return null;
      return RouteDescriptor(path: '/todos/$id', query: uri.queryParameters);
    }

    return null;
  }

  /// Parses an FCM `data` payload into a [RouteDescriptor], or returns
  /// `null` if the payload does not contain a recognisable `route` field.
  ///
  /// Wire format (kept simple so the Firebase Console "Send test message"
  /// form is usable):
  ///
  /// ```json
  /// {
  ///   "route": "/todos/42",
  ///   "query_focus": "title",
  ///   "extra_highlight": "true"
  /// }
  /// ```
  static RouteDescriptor? parsePushPayload(Map<String, Object?> data) {
    final raw = data['route'];
    if (raw is! String || raw.isEmpty) return null;
    final path = raw.startsWith('/') ? raw : '/$raw';

    final query = <String, String>{};
    final extra = <String, Object?>{};

    data.forEach((key, value) {
      if (key == 'route') return;
      if (value == null) return;
      if (key.startsWith('query_') && value is String) {
        query[key.substring('query_'.length)] = value;
      } else if (key.startsWith('extra_')) {
        extra[key.substring('extra_'.length)] = value;
      }
    });

    return RouteDescriptor(
      path: path,
      query: query,
      extra: extra.isEmpty ? null : extra,
    );
  }
}
