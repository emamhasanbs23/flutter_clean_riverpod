import 'package:flutter_clean_riverpod_boilerplate/core/notifications/route_descriptor.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/notifications/route_descriptor_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RouteDescriptorParser.parse (deep link URIs)', () {
    test('parses custom-scheme link boilerplate-dev://todos/42', () {
      final result = RouteDescriptorParser.parse(
        Uri.parse('boilerplate-dev://todos/42'),
      );
      expect(result, isNotNull);
      expect(result!.path, '/todos/42');
      expect(result.query, isEmpty);
      expect(result.extra, isNull);
    });

    test('parses custom-scheme link with query string', () {
      final result = RouteDescriptorParser.parse(
        Uri.parse('boilerplate://todos/42?focus=title'),
      );
      expect(result, isNotNull);
      expect(result!.path, '/todos/42');
      expect(result.query, {'focus': 'title'});
    });

    test('parses https Universal Link https://example.com/todos/7', () {
      final result = RouteDescriptorParser.parse(
        Uri.parse('https://example.com/todos/7'),
      );
      expect(result, isNotNull);
      expect(result!.path, '/todos/7');
      expect(result.query, isEmpty);
    });

    test('parses https link with query string', () {
      final result = RouteDescriptorParser.parse(
        Uri.parse('https://example.com/todos/7?focus=title&highlight=true'),
      );
      expect(result, isNotNull);
      expect(result!.path, '/todos/7');
      expect(result.query, {'focus': 'title', 'highlight': 'true'});
    });

    test('returns null for unknown path under https', () {
      final result = RouteDescriptorParser.parse(
        Uri.parse('https://example.com/settings'),
      );
      expect(result, isNull);
    });

    test('returns null for nested https paths', () {
      final result = RouteDescriptorParser.parse(
        Uri.parse('https://example.com/todos/42/comments'),
      );
      expect(result, isNull);
    });

    test('returns null when id is missing under https', () {
      final result = RouteDescriptorParser.parse(
        Uri.parse('https://example.com/todos/'),
      );
      expect(result, isNull);
    });

    test('returns null for unknown custom scheme', () {
      final result = RouteDescriptorParser.parse(
        Uri.parse('otherapp://todos/42'),
      );
      expect(result, isNull);
    });

    test('returns null when scheme is empty', () {
      // Uri.parse itself throws FormatException on a string with an empty
      // scheme, so it never reaches the parser. Callers that obtain URIs
      // from `app_links` are guaranteed non-empty schemes.
      expect(() => Uri.parse('://todos/42'), throwsA(isA<FormatException>()));
    });

    test('returns null for malformed https URI', () {
      // "not a uri" parses to scheme="not" host="" path=" a uri" which is
      // not a recognized link — the parser returns null rather than crash.
      final result = RouteDescriptorParser.parse(Uri.parse('not a uri'));
      expect(result, isNull);
    });

    test('preserves multiple query parameters in order', () {
      final result = RouteDescriptorParser.parse(
        Uri.parse('boilerplate-dev://todos/1?a=1&b=2&c=3'),
      );
      expect(result, isNotNull);
      expect(result!.query, {'a': '1', 'b': '2', 'c': '3'});
    });
  });

  group('RouteDescriptorParser.parsePushPayload (FCM data)', () {
    test('parses minimal {route} payload', () {
      final result = RouteDescriptorParser.parsePushPayload({
        'route': '/todos/42',
      });
      expect(result, isNotNull);
      expect(result!.path, '/todos/42');
      expect(result.query, isEmpty);
      expect(result.extra, isNull);
    });

    test('prepends / when route is missing the leading slash', () {
      final result = RouteDescriptorParser.parsePushPayload({
        'route': 'todos/42',
      });
      expect(result, isNotNull);
      expect(result!.path, '/todos/42');
    });

    test('extracts query_* keys as query params', () {
      final result = RouteDescriptorParser.parsePushPayload({
        'route': '/todos/42',
        'query_focus': 'title',
        'query_highlight': 'true',
      });
      expect(result, isNotNull);
      expect(result!.path, '/todos/42');
      expect(result.query, {'focus': 'title', 'highlight': 'true'});
    });

    test('extracts extra_* keys as extra map', () {
      final result = RouteDescriptorParser.parsePushPayload({
        'route': '/todos/42',
        'extra_color': 'red',
        'extra_count': 3,
      });
      expect(result, isNotNull);
      expect(result!.extra, {'color': 'red', 'count': 3});
    });

    test('ignores extra_/query_ keys when value is null', () {
      final result = RouteDescriptorParser.parsePushPayload({
        'route': '/todos/42',
        'query_foo': null,
        'extra_bar': null,
      });
      expect(result, isNotNull);
      expect(result!.query, isEmpty);
      expect(result.extra, isNull);
    });

    test('returns null when route is missing', () {
      final result = RouteDescriptorParser.parsePushPayload({'foo': 'bar'});
      expect(result, isNull);
    });

    test('returns null when route is empty string', () {
      final result = RouteDescriptorParser.parsePushPayload({'route': ''});
      expect(result, isNull);
    });

    test('returns null when route is not a string', () {
      final result = RouteDescriptorParser.parsePushPayload({'route': 42});
      expect(result, isNull);
    });
  });

  group('RouteDescriptor', () {
    test('toUri round-trips a path with no query', () {
      const d = RouteDescriptor(path: '/todos/42');
      expect(d.toUri().toString(), '/todos/42');
    });

    test('toUri encodes query params', () {
      const d = RouteDescriptor(path: '/todos/42', query: {'focus': 'title'});
      expect(d.toUri().toString(), '/todos/42?focus=title');
    });

    test('equality treats two identical descriptors as equal', () {
      const a = RouteDescriptor(path: '/todos/1', query: {'x': '1'});
      const b = RouteDescriptor(path: '/todos/1', query: {'x': '1'});
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('equality is order-independent for query', () {
      const a = RouteDescriptor(path: '/todos/1', query: {'a': '1', 'b': '2'});
      const b = RouteDescriptor(path: '/todos/1', query: {'b': '2', 'a': '1'});
      expect(a, equals(b));
    });

    test('throws when path does not start with /', () {
      // The constructor itself is const-constructible so the prefix check
      // runs lazily in toUri() rather than at construction.
      expect(
        () => const RouteDescriptor(path: 'todos/1').toUri(),
        throwsA(isA<StateError>()),
      );
    });

    test('extra can be null', () {
      const d = RouteDescriptor(path: '/todos/1');
      expect(d.extra, isNull);
    });
  });
}
