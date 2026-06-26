import 'package:flutter_clean_riverpod_boilerplate/core/error/failures.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/storage/secure_storage_service.dart';
import 'package:flutter_clean_riverpod_boilerplate/data/auth/data_source/auth_data_source.dart';
import 'package:flutter_clean_riverpod_boilerplate/data/auth/model/auth_me_response.dart';
import 'package:flutter_clean_riverpod_boilerplate/data/auth/model/login_request.dart';
import 'package:flutter_clean_riverpod_boilerplate/data/auth/model/login_response.dart';
import 'package:flutter_clean_riverpod_boilerplate/data/auth/model/refresh_token_request.dart';
import 'package:flutter_clean_riverpod_boilerplate/data/auth/model/refresh_token_response.dart';
import 'package:flutter_clean_riverpod_boilerplate/data/auth/repository_impl/auth_repository_impl.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

class _MockAuthDataSource extends Mock implements AuthDataSource {}

void main() {
  setUpAll(() {
    registerFallbackValue(const LoginRequest(username: '', password: ''));
    registerFallbackValue(const RefreshTokenRequest(refreshToken: ''));
  });

  group('AuthRepositoryImpl', () {
    late _MockFlutterSecureStorage storage;
    late _MockAuthDataSource dataSource;
    late SecureStorageService service;
    late AuthRepositoryImpl repository;

    setUp(() {
      storage = _MockFlutterSecureStorage();
      dataSource = _MockAuthDataSource();
      service = SecureStorageService(storage: storage);
      repository = AuthRepositoryImpl(dataSource: dataSource, storage: service);

      when(
        () => storage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((_) async {});
      when(
        () => storage.read(key: any(named: 'key')),
      ).thenAnswer((_) async => null);
      when(
        () => storage.delete(key: any(named: 'key')),
      ).thenAnswer((_) async {});
    });

    test('login persists tokens and returns AuthUser', () async {
      when(() => dataSource.login(request: any(named: 'request'))).thenAnswer(
        (_) async => const LoginResponse(
          accessToken: 'fake.access',
          refreshToken: 'fake.refresh',
          userId: 'usr_server_42',
          userEmail: 'demo@example.com',
        ),
      );

      final result = await repository.login(
        username: 'emilys',
        password: 'emilyspass',
      );

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Expected success, got ${failure.message}'),
        (user) {
          expect(user.email, 'demo@example.com');
          expect(user.id, 'usr_server_42');
        },
      );

      verify(
        () => storage.write(key: 'access_token', value: 'fake.access'),
      ).called(1);
      verify(
        () => storage.write(key: 'refresh_token', value: 'fake.refresh'),
      ).called(1);
      verify(
        () => storage.write(key: 'user_email', value: 'demo@example.com'),
      ).called(1);
    });

    test(
      'login falls back to deterministic id when server omits user fields',
      () async {
        when(() => dataSource.login(request: any(named: 'request'))).thenAnswer(
          (_) async => const LoginResponse(accessToken: 'fake.access'),
        );

        final result = await repository.login(
          username: 'emilys',
          password: 'emilyspass',
        );

        expect(result.isRight(), isTrue);
        result.fold(
          (failure) => fail('Expected success, got ${failure.message}'),
          (user) {
            expect(user.email, 'emilys');
            expect(user.id, startsWith('usr_'));
          },
        );
      },
    );

    test('login maps ValidationFailure to InvalidCredentialsFailure', () async {
      when(
        () => dataSource.login(request: any(named: 'request')),
      ).thenThrow(const ValidationFailure());

      final result = await repository.login(
        username: 'emilys',
        password: 'wrongpass',
      );

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<InvalidCredentialsFailure>()),
        (_) => fail('Expected failure'),
      );
      verifyNever(
        () => storage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      );
    });

    test(
      'login maps UnauthorizedFailure to InvalidCredentialsFailure',
      () async {
        when(
          () => dataSource.login(request: any(named: 'request')),
        ).thenThrow(const UnauthorizedFailure());

        final result = await repository.login(
          username: 'emilys',
          password: 'wrongpass',
        );

        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) => expect(failure, isA<InvalidCredentialsFailure>()),
          (_) => fail('Expected failure'),
        );
      },
    );

    test('logout deletes all persisted auth keys', () async {
      when(
        () => storage.read(key: 'access_token'),
      ).thenAnswer((_) async => 'fake.token.value');

      final loggedOut = await repository.logout();

      expect(loggedOut.isRight(), isTrue);
      verify(() => storage.delete(key: 'access_token')).called(1);
      verify(() => storage.delete(key: 'refresh_token')).called(1);
      verify(() => storage.delete(key: 'user_id')).called(1);
      verify(() => storage.delete(key: 'user_email')).called(1);
    });

    test('refreshAccessToken swaps stored tokens on success', () async {
      when(
        () => storage.read(key: 'refresh_token'),
      ).thenAnswer((_) async => 'old.refresh');
      when(() => dataSource.refresh(request: any(named: 'request'))).thenAnswer(
        (_) async => const RefreshTokenResponse(
          accessToken: 'new.access',
          refreshToken: 'new.refresh',
        ),
      );

      final result = await repository.refreshAccessToken();

      expect(result.isRight(), isTrue);
      verify(
        () => storage.write(key: 'access_token', value: 'new.access'),
      ).called(1);
      verify(
        () => storage.write(key: 'refresh_token', value: 'new.refresh'),
      ).called(1);
    });

    test('refreshAccessToken returns Unauthorized when no refresh token is '
        'stored', () async {
      when(
        () => storage.read(key: 'refresh_token'),
      ).thenAnswer((_) async => null);

      final result = await repository.refreshAccessToken();

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<UnauthorizedFailure>()),
        (_) => fail('Expected failure'),
      );
    });

    test('isAuthenticated returns true when a token is present', () async {
      when(
        () => storage.read(key: 'access_token'),
      ).thenAnswer((_) async => 'fake.token.value');

      expect(await repository.isAuthenticated(), isTrue);
    });

    test('isAuthenticated returns false when no token is stored', () async {
      when(
        () => storage.read(key: 'access_token'),
      ).thenAnswer((_) async => null);

      expect(await repository.isAuthenticated(), isFalse);
    });

    group('getCurrentUser', () {
      test('returns Right(null) when no access token is stored', () async {
        final result = await repository.getCurrentUser();

        expect(result.isRight(), isTrue);
        result.fold(
          (_) => fail('Expected success'),
          (user) => expect(user, isNull),
        );
        verifyNever(() => dataSource.getMe());
      });

      test('fetches user from network when access token is present', () async {
        when(
          () => storage.read(key: 'access_token'),
        ).thenAnswer((_) async => 'fake.access');
        when(() => dataSource.getMe()).thenAnswer(
          (_) async => const AuthMeResponse(
            id: 1,
            email: 'emily.johnson@x.dummyjson.com',
            username: 'emilys',
          ),
        );

        final result = await repository.getCurrentUser();

        expect(result.isRight(), isTrue);
        result.fold((_) => fail('Expected success'), (user) {
          expect(user, isNotNull);
          expect(user!.id, '1');
          expect(user.email, 'emily.johnson@x.dummyjson.com');
        });
        verify(() => dataSource.getMe()).called(1);
        verify(
          () => storage.write(
            key: 'user_email',
            value: 'emily.johnson@x.dummyjson.com',
          ),
        ).called(1);
      });

      test('falls back to cached user when network fails', () async {
        when(
          () => storage.read(key: 'access_token'),
        ).thenAnswer((_) async => 'fake.access');
        when(() => dataSource.getMe()).thenThrow(const NetworkFailure());
        when(
          () => storage.read(key: 'user_id'),
        ).thenAnswer((_) async => 'usr_42');
        when(
          () => storage.read(key: 'user_email'),
        ).thenAnswer((_) async => 'demo@example.com');

        final result = await repository.getCurrentUser();

        expect(result.isRight(), isTrue);
        result.fold((_) => fail('Expected success'), (user) {
          expect(user, isNotNull);
          expect(user!.id, 'usr_42');
          expect(user.email, 'demo@example.com');
        });
      });

      test(
        'returns Left when network fails and no cached user exists',
        () async {
          when(
            () => storage.read(key: 'access_token'),
          ).thenAnswer((_) async => 'fake.access');
          when(() => dataSource.getMe()).thenThrow(const NetworkFailure());

          final result = await repository.getCurrentUser();

          expect(result.isLeft(), isTrue);
          result.fold(
            (failure) => expect(failure, isA<NetworkFailure>()),
            (_) => fail('Expected failure'),
          );
        },
      );

      test('InvalidCredentialsFailure is a Failure', () {
        expect(const InvalidCredentialsFailure(), isA<Failure>());
      });
    });
  });
}
