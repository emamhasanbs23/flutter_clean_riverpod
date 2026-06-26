import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_clean_riverpod_boilerplate/core/error/failures.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/domain/entities/auth_user.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/domain/usecases/get_current_user_use_case.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  group('GetCurrentUserUseCase', () {
    late _MockAuthRepository repository;
    late GetCurrentUserUseCase useCase;

    setUp(() {
      repository = _MockAuthRepository();
      useCase = GetCurrentUserUseCase(repository);
    });

    test('returns the persisted user on success', () async {
      const user = AuthUser(id: 'usr_1', email: 'demo@example.com');
      when(() => repository.getCurrentUser()).thenAnswer(
        (_) async => const Right<Failure, AuthUser?>(user),
      );

      final result = await useCase();

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected success'),
        (loaded) {
          expect(loaded, isNotNull);
          expect(loaded!.id, 'usr_1');
          expect(loaded.email, 'demo@example.com');
        },
      );
    });

    test('returns Right(null) when no user is persisted', () async {
      when(() => repository.getCurrentUser()).thenAnswer(
        (_) async => const Right<Failure, AuthUser?>(null),
      );

      final result = await useCase();

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected success'),
        (loaded) => expect(loaded, isNull),
      );
    });

    test('propagates repository failures', () async {
      when(() => repository.getCurrentUser()).thenAnswer(
        (_) async => const Left<Failure, AuthUser?>(UnexpectedFailure()),
      );

      final result = await useCase();

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<UnexpectedFailure>()),
        (_) => fail('Expected failure'),
      );
    });
  });
}