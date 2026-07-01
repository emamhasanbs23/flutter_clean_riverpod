import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/error/failures.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/network/auth_interceptor.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/storage/secure_storage_service.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  group('AuthInterceptor', () {
    late _MockFlutterSecureStorage storage;
    late SecureStorageService service;
    late _MockAuthRepository repository;
    late bool sessionExpired;
    late AuthInterceptor interceptor;
    late Dio dio;

    setUpAll(() {
      registerFallbackValue(<String>['']);
    });

    setUp(() {
      storage = _MockFlutterSecureStorage();
      service = SecureStorageService(storage: storage);
      repository = _MockAuthRepository();
      sessionExpired = false;

      when(
        () => storage.read(key: any(named: 'key')),
      ).thenAnswer((_) async => null);
      when(
        () => storage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((_) async {});
      when(
        () => storage.delete(key: any(named: 'key')),
      ).thenAnswer((_) async {});

      dio = Dio(BaseOptions(baseUrl: 'https://example.com'));
      interceptor = AuthInterceptor(
        dio,
        service,
        authRepositoryBuilder: () => repository,
        onSessionExpired: () => sessionExpired = true,
      );
      dio.interceptors.add(interceptor);
    });

    test(
      'attaches Authorization header when an access token is present',
      () async {
        when(
          () => storage.read(key: 'access_token'),
        ).thenAnswer((_) async => 'fake.access');

        final captured = Completer<RequestOptions>();
        dio.interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              captured.complete(options);
              handler.resolve(
                Response<dynamic>(requestOptions: options, statusCode: 200),
              );
            },
          ),
        );

        await dio.get<dynamic>('/me');

        final options = await captured.future;
        expect(options.headers['Authorization'], 'Bearer fake.access');
      },
    );

    test(
      'triggers a refresh on 401 and retries once with the new token',
      () async {
        when(
          () => storage.read(key: 'refresh_token'),
        ).thenAnswer((_) async => 'old.refresh');
        when(
          () => repository.refreshAccessToken(),
        ).thenAnswer((_) async => const Right<Failure, String>('new.access'));

        var attempts = 0;
        final retriedWith = Completer<String?>();
        dio.httpClientAdapter = _CountingAdapter(
          onAttempt: (options) {
            attempts++;
            if (attempts == 1) {
              return ResponseBody.fromString(
                '{"error":"expired"}',
                401,
                headers: {
                  Headers.contentTypeHeader: ['application/json'],
                },
              );
            }
            retriedWith.complete(options.headers['Authorization'] as String?);
            return ResponseBody.fromString(
              '{"ok":true}',
              200,
              headers: {
                Headers.contentTypeHeader: ['application/json'],
              },
            );
          },
        );

        final response = await dio.get<dynamic>('/protected');

        expect(attempts, 2);
        expect(response.statusCode, 200);
        expect(await retriedWith.future, 'Bearer new.access');
        expect(sessionExpired, isFalse);
        verify(
          () => storage.write(key: 'access_token', value: 'new.access'),
        ).called(1);
      },
    );

    test('clears stored tokens and notifies when refresh fails', () async {
      when(
        () => storage.read(key: 'refresh_token'),
      ).thenAnswer((_) async => 'old.refresh');
      when(() => repository.refreshAccessToken()).thenAnswer(
        (_) async => const Left<Failure, String>(UnauthorizedFailure()),
      );

      var attempts = 0;
      dio.httpClientAdapter = _CountingAdapter(
        onAttempt: (options) {
          attempts++;
          return ResponseBody.fromString(
            '{"error":"expired"}',
            401,
            headers: {
              Headers.contentTypeHeader: ['application/json'],
            },
          );
        },
      );

      await expectLater(
        dio.get<dynamic>('/protected'),
        throwsA(isA<DioException>()),
      );

      expect(attempts, 1);
      expect(sessionExpired, isTrue);
      verify(() => storage.delete(key: 'access_token')).called(1);
      verify(() => storage.delete(key: 'refresh_token')).called(1);
    });

    test('forwards the error as-is when no refresh token is stored', () async {
      when(
        () => storage.read(key: 'refresh_token'),
      ).thenAnswer((_) async => null);

      var attempts = 0;
      dio.httpClientAdapter = _CountingAdapter(
        onAttempt: (options) {
          attempts++;
          return ResponseBody.fromString(
            '{"error":"expired"}',
            401,
            headers: {
              Headers.contentTypeHeader: ['application/json'],
            },
          );
        },
      );

      await expectLater(
        dio.get<dynamic>('/protected'),
        throwsA(isA<DioException>()),
      );

      expect(attempts, 1);
      expect(sessionExpired, isTrue);
      verifyNever(() => repository.refreshAccessToken());
    });
  });
}

/// Minimal adapter that returns a pre-canned response for each attempt.
/// Lets us count retry attempts and inspect headers on retry.
class _CountingAdapter implements HttpClientAdapter {
  _CountingAdapter({required this.onAttempt});

  final ResponseBody Function(RequestOptions options) onAttempt;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    return onAttempt(options);
  }

  @override
  void close({bool force = false}) {}
}
