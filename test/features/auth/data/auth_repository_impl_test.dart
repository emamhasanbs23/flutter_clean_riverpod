import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_clean_riverpod_boilerplate/core/error/failures.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/storage/secure_storage_service.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/data/model/login_request.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/data/model/login_response.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/data/model/refresh_token_request.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/data/model/refresh_token_response.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/data/repository_impl/auth_repository_impl.dart';

class _MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

class _MockAuthRemoteDataSource extends Mock
    implements AuthRemoteDataSource {}

void main() {
  setUpAll(() {
    // mocktail needs fallback values for non-primitive named arguments.
    registerFallbackValue(const LoginRequest(email: '', password: ''));
    registerFallbackValue(const RefreshTokenRequest(refreshToken: ''));
  });

  group('AuthRepositoryImpl', () {
    late _MockFlutterSecureStorage storage;
    late _MockAuthRemoteDataSource remote;
    late SecureStorageService service;
    late AuthRepositoryImpl repository;

    setUp(() {
      storage = _MockFlutterSecureStorage();
      remote = _MockAuthRemoteDataSource();
      service = SecureStorageService(storage: storage);
      repository = AuthRepositoryImpl(
        remoteDataSource: remote,
        storage: service,
      );

      when(() => storage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          )).thenAnswer((_) async {});
      when(() => storage.read(key: any(named: 'key')))
          .thenAnswer((_) async => null);
      when(() => storage.delete(key: any(named: 'key')))
          .thenAnswer((_) async {});
    });

    test('login persists tokens and returns AuthUser', () async {
      when(() => remote.login(request: any(named: 'request'))).thenAnswer(
        (_) async => const LoginResponse(
          accessToken: 'fake.access',
          refreshToken: 'fake.refresh',
          userId: 'usr_server_42',
          userEmail: 'demo@example.com',
        ),
      );

      final result = await repository.login(
        email: 'demo@example.com',
        password: 'password123',
      );

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Expected success, got ${failure.message}'),
        (user) {
          expect(user.email, 'demo@example.com');
          expect(user.id, 'usr_server_42');
        },
      );

      // Token + user metadata should be persisted.
      verify(() => storage.write(
            key: 'access_token',
            value: 'fake.access',
          )).called(1);
      verify(() => storage.write(
            key: 'refresh_token',
            value: 'fake.refresh',
          )).called(1);
      verify(() => storage.write(
            key: 'user_email',
            value: 'demo@example.com',
          )).called(1);
    });

    test(
        'login falls back to deterministic id when server omits the nested '
        'user object', () async {
      when(() => remote.login(request: any(named: 'request'))).thenAnswer(
        (_) async => const LoginResponse(
          accessToken: 'fake.access',
        ),
      );

      final result = await repository.login(
        email: 'demo@example.com',
        password: 'password123',
      );

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Expected success, got ${failure.message}'),
        (user) {
          expect(user.email, 'demo@example.com');
          expect(user.id, startsWith('usr_'));
        },
      );
    });

    test('login returns UnauthorizedFailure when remote rejects', () async {
      when(() => remote.login(request: any(named: 'request')))
          .thenThrow(const UnauthorizedFailure());

      final result = await repository.login(
        email: 'demo@example.com',
        password: 'password123',
      );

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<UnauthorizedFailure>()),
        (_) => fail('Expected failure'),
      );
      verifyNever(() => storage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          ));
    });

    test('logout deletes all persisted auth keys', () async {
      when(() => storage.read(key: 'access_token'))
          .thenAnswer((_) async => 'fake.token.value');

      final loggedOut = await repository.logout();

      expect(loggedOut.isRight(), isTrue);
      verify(() => storage.delete(key: 'access_token')).called(1);
      verify(() => storage.delete(key: 'refresh_token')).called(1);
      verify(() => storage.delete(key: 'user_id')).called(1);
      verify(() => storage.delete(key: 'user_email')).called(1);
    });

    test('refreshAccessToken swaps stored tokens on success', () async {
      when(() => storage.read(key: 'refresh_token'))
          .thenAnswer((_) async => 'old.refresh');
      when(() => remote.refresh(request: any(named: 'request'))).thenAnswer(
        (_) async => const RefreshTokenResponse(
          accessToken: 'new.access',
          refreshToken: 'new.refresh',
        ),
      );

      final result = await repository.refreshAccessToken();

      expect(result.isRight(), isTrue);
      verify(() => storage.write(
            key: 'access_token',
            value: 'new.access',
          )).called(1);
      verify(() => storage.write(
            key: 'refresh_token',
            value: 'new.refresh',
          )).called(1);
    });

    test('refreshAccessToken returns Unauthorized when no refresh token is '
        'stored', () async {
      when(() => storage.read(key: 'refresh_token'))
          .thenAnswer((_) async => null);

      final result = await repository.refreshAccessToken();

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<UnauthorizedFailure>()),
        (_) => fail('Expected failure'),
      );
    });

    test('isAuthenticated returns true when a token is present', () async {
      when(() => storage.read(key: 'access_token'))
          .thenAnswer((_) async => 'fake.token.value');

      expect(await repository.isAuthenticated(), isTrue);
    });

    test('isAuthenticated returns false when no token is stored', () async {
      when(() => storage.read(key: 'access_token'))
          .thenAnswer((_) async => null);

      expect(await repository.isAuthenticated(), isFalse);
    });

    group('getCurrentUser', () {
      test('returns Right(user) when both id and email are persisted',
          () async {
        when(() => storage.read(key: 'user_id'))
            .thenAnswer((_) async => 'usr_42');
        when(() => storage.read(key: 'user_email'))
            .thenAnswer((_) async => 'demo@example.com');

        final result = await repository.getCurrentUser();

        expect(result.isRight(), isTrue);
        result.fold(
          (_) => fail('Expected success'),
          (user) {
            expect(user, isNotNull);
            expect(user!.id, 'usr_42');
            expect(user.email, 'demo@example.com');
          },
        );
      });

      test('returns Right(null) when no user is persisted', () async {
        final result = await repository.getCurrentUser();

        expect(result.isRight(), isTrue);
        result.fold(
          (_) => fail('Expected success'),
          (user) => expect(user, isNull),
        );
      });

      test('returns Right(null) when only one of id/email is persisted',
          () async {
        when(() => storage.read(key: 'user_id'))
            .thenAnswer((_) async => 'usr_42');
        when(() => storage.read(key: 'user_email'))
            .thenAnswer((_) async => null);

        final result = await repository.getCurrentUser();

        expect(result.isRight(), isTrue);
        result.fold(
          (_) => fail('Expected success'),
          (user) => expect(user, isNull),
        );
      });

      test('InvalidCredentialsFailure is a Failure', () {
        // Smoke test ensuring the auth failure subtype satisfies the domain.
        expect(const InvalidCredentialsFailure(), isA<Failure>());
      });
    });
  });
}