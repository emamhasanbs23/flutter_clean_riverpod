import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_clean_riverpod_boilerplate/core/error/failures.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/domain/delete_todo_use_case.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/domain/todo_repository.dart';

class _MockTodoRepository extends Mock implements TodoRepository {}

void main() {
  group('DeleteTodoUseCase', () {
    late _MockTodoRepository repository;
    late DeleteTodoUseCase useCase;

    setUp(() {
      repository = _MockTodoRepository();
      useCase = DeleteTodoUseCase(repository);
    });

    test('forwards the id to the repository and returns its success',
        () async {
      when(() => repository.deleteTodo('42')).thenAnswer(
        (_) async => const Right<Failure, void>(null),
      );

      final result = await useCase('42');

      expect(result.isRight(), isTrue);
      verify(() => repository.deleteTodo('42')).called(1);
    });

    test('propagates repository failures', () async {
      when(() => repository.deleteTodo('missing')).thenAnswer(
        (_) async => const Left<Failure, void>(NotFoundFailure()),
      );

      final result = await useCase('missing');

      expect(result, equals(const Left<Failure, void>(NotFoundFailure())));
    });
  });
}