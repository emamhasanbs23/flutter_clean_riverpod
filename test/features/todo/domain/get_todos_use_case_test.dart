import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_clean_riverpod_boilerplate/core/error/failures.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/domain/get_todos_use_case.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/domain/todo.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/domain/todo_repository.dart';

class _MockTodoRepository extends Mock implements TodoRepository {}

void main() {
  group('GetTodosUseCase', () {
    late _MockTodoRepository repository;
    late GetTodosUseCase useCase;

    setUp(() {
      repository = _MockTodoRepository();
      useCase = GetTodosUseCase(repository);
    });

    test('delegates to the repository and returns its success', () async {
      final todos = [
        const Todo(id: '1', title: 'a', completed: false),
      ];
      when(() => repository.getTodos())
          .thenAnswer((_) async => Right<Failure, List<Todo>>(todos));

      final result = await useCase();

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected success'),
        (list) => expect(list, equals(todos)),
      );
      verify(() => repository.getTodos()).called(1);
    });

    test('propagates repository failures', () async {
      when(() => repository.getTodos()).thenAnswer(
        (_) async => const Left<Failure, List<Todo>>(UnexpectedFailure()),
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