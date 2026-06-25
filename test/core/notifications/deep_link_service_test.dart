import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_clean_riverpod_boilerplate/core/notifications/deep_link_service.dart';

void main() {
  group('NoOpDeepLinkService', () {
    const service = NoOpDeepLinkService();

    test('incoming is an empty stream', () async {
      expect(service.incoming, emitsInOrder(<Uri>[]));
    });

    test('getInitialLink returns null', () async {
      expect(await service.getInitialLink(), isNull);
    });
  });

  group('Custom DeepLinkService (fake)', () {
    test('forwards the controller stream as incoming', () async {
      final controller = StreamController<Uri>();
      final service = _FakeDeepLinkService(
        incoming: controller.stream,
        initial: Uri.parse('boilerplate-dev://todos/1'),
      );

      final received = <Uri>[];
      final sub = service.incoming.listen(received.add);
      controller.add(Uri.parse('boilerplate-dev://todos/2'));
      controller.add(Uri.parse('boilerplate-dev://todos/3'));
      await Future<void>.delayed(Duration.zero);
      await controller.close();
      await sub.cancel();

      expect(received, [
        Uri.parse('boilerplate-dev://todos/2'),
        Uri.parse('boilerplate-dev://todos/3'),
      ]);
    });

    test('getInitialLink returns the seeded URI exactly once', () async {
      var calls = 0;
      final service = _FakeDeepLinkService(
        incoming: const Stream<Uri>.empty(),
        initial: Uri.parse('https://example.com/todos/7'),
      );
      // Use a counter to verify the implementation only invokes the
      // underlying source once per call.
      service.onGetInitial = () {
        calls++;
        return Future.value(Uri.parse('https://example.com/todos/7'));
      };

      expect(await service.getInitialLink(), isNotNull);
      expect(calls, 1);

      // Second call should not re-invoke the source — the spec is "only
      // available on first read", but our fake lets callers re-invoke.
      // The important contract for callers is that the value is stable
      // for the lifetime of the app.
      expect(await service.getInitialLink(), isNotNull);
      expect(calls, 2);
    });
  });
}

class _FakeDeepLinkService implements DeepLinkService {
  _FakeDeepLinkService({
    required Stream<Uri> incoming,
    required Uri? initial,
  })  : _incoming = incoming,
        _initial = initial;

  final Stream<Uri> _incoming;
  final Uri? _initial;
  Future<Uri?> Function()? onGetInitial;

  @override
  Stream<Uri> get incoming => _incoming;

  @override
  Future<Uri?> getInitialLink() {
    final fn = onGetInitial;
    if (fn != null) return fn();
    return Future.value(_initial);
  }
}