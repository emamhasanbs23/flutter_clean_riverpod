import 'package:flutter_clean_riverpod_boilerplate/core/error/failures.dart';
import 'package:flutter_clean_riverpod_boilerplate/domain/auth/entities/auth_user.dart';
import 'package:flutter_clean_riverpod_boilerplate/domain/auth/repositories/auth_repository.dart';
import 'package:flutter_clean_riverpod_boilerplate/presentation/auth/riverpod/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

const _stubUser = AuthUser(id: '1', email: 'a@b.com');

void main() {
  group('LoginController', () {
    late _MockAuthRepository repository;
    late ProviderContainer container;

    setUp(() {
      repository = _MockAuthRepository();
      container = ProviderContainer(
        overrides: [authRepositoryProvider.overrideWithValue(repository)],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('starts in LoginIdle', () {
      expect(container.read(loginControllerProvider), isA<LoginIdle>());
    });

    test('submit flips to LoginSuccess on a successful login', () async {
      when(
        () => repository.login(
          username: any(named: 'username'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => const Right<Failure, AuthUser>(_stubUser));
      when(repository.isAuthenticated).thenAnswer((_) async => true);

      final success = await container
          .read(loginControllerProvider.notifier)
          .submit(username: 'emilys', password: 'emilyspass');

      expect(success, isTrue);
      expect(container.read(loginControllerProvider), isA<LoginSuccess>());
    });

    test(
      'submit flips to LoginError carrying the Failure on a bad login',
      () async {
        when(
          () => repository.login(
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),
        ).thenAnswer(
          (_) async =>
              const Left<Failure, AuthUser>(InvalidCredentialsFailure()),
        );

        final success = await container
            .read(loginControllerProvider.notifier)
            .submit(username: 'emilys', password: 'wrongpass');

        expect(success, isFalse);
        final state = container.read(loginControllerProvider);
        expect(state, isA<LoginError>());
        expect((state as LoginError).failure, isA<InvalidCredentialsFailure>());
      },
    );

    test(
      'logoutControllerProvider delegates to AuthRepository.logout',
      () async {
        when(
          repository.logout,
        ).thenAnswer((_) async => const Right<Failure, void>(null));
        when(repository.isAuthenticated).thenAnswer((_) async => false);

        await container.read(logoutControllerProvider).call();

        verify(repository.logout).called(1);
      },
    );
  });
}
