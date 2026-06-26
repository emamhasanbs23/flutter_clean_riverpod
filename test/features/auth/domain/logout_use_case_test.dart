import 'package:flutter_clean_riverpod_boilerplate/core/error/failures.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/domain/usecases/logout_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  group('LogoutUseCase', () {
    late _MockAuthRepository repository;
    late LogoutUseCase useCase;

    setUp(() {
      repository = _MockAuthRepository();
      useCase = LogoutUseCase(repository);
    });

    test('delegates to repository.logout and returns its success', () async {
      when(() => repository.logout()).thenAnswer(
        (_) async => const Right<Failure, void>(null),
      );

      final result = await useCase();

      expect(result.isRight(), isTrue);
      verify(() => repository.logout()).called(1);
    });

    test('propagates repository failures', () async {
      when(() => repository.logout()).thenAnswer(
        (_) async => const Left<Failure, void>(UnexpectedFailure()),
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
