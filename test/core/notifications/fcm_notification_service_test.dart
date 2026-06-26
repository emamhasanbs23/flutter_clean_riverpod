import 'package:flutter_clean_riverpod_boilerplate/core/notifications/fcm_notification_service.dart' show FcmNotificationService;
import 'package:flutter_clean_riverpod_boilerplate/core/notifications/route_descriptor.dart' show RouteDescriptor;
import 'package:flutter_clean_riverpod_boilerplate/core/notifications/route_descriptor_parser.dart';
import 'package:flutter_test/flutter_test.dart';

/// Exercises the [FcmNotificationService] -> [RouteDescriptorParser] boundary
/// without needing to mock the Firebase plugin (which has many statics).
///
/// The FCM service's `_emitFor` method extracts `message.data`, runs it
/// through `parsePushPayload`, and forwards the resulting
/// [RouteDescriptor] on the `onTap` stream. We assert that
/// `parsePushPayload` handles the same shape FCM will deliver in
/// production (`String` keys and `Object?` values).
void main() {
  group('FcmNotificationService payload translation', () {
    test('parses a payload with route + query + extra keys', () {
      final data = <String, Object?>{
        'route': '/todos/42',
        'query_focus': 'title',
        'extra_color': 'red',
      };
      final result = RouteDescriptorParser.parsePushPayload(data);
      expect(result, isNotNull);
      expect(result!.path, '/todos/42');
      expect(result.query, {'focus': 'title'});
      expect(result.extra, {'color': 'red'});
    });

    test('ignores payload without a route key', () {
      final data = <String, Object?>{
        'title': 'Reminder',
        'body': 'Tap to view',
      };
      expect(RouteDescriptorParser.parsePushPayload(data), isNull);
    });

    test('accepts a payload whose route is a string with no extras', () {
      final data = <String, Object?>{'route': '/todos/1'};
      final result = RouteDescriptorParser.parsePushPayload(data);
      expect(result, isNotNull);
      expect(result!.path, '/todos/1');
      expect(result.query, isEmpty);
      expect(result.extra, isNull);
    });
  });
}
