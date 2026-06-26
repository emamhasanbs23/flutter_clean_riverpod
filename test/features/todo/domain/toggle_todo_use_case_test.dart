import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_clean_riverpod_boilerplate/core/error/failures.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/domain/entities/todo.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/domain/repositories/todo_repository.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/domain/usecases/toggle_todo_use_case.dart';

class _MockTodoRepository extends Mock implements TodoRepository {}

void main() {
  group('ToggleTodoUseCase', () {
    late _MockTodoRepository repository;
    late ToggleTodoUseCase useCase;

    setUp(() {
      repository = _MockTodoRepository();
      useCase = ToggleTodoUseCase(repository);
    });

    test('forwards the id to the repository and returns its success',
        () async {
      const toggled = Todo(id: '42', title: 'x', completed: true);
      when(() => repository.toggleTodo('42')).thenAnswer(
        (_) async => const Right<Failure, Todo>(toggled),
      );

      final result = await useCase('42');

      expect(result, equals(const Right<Failure, Todo>(toggled)));
      verify(() => repository.toggleTodo('42')).called(1);
    });

    test('propagates repository failures', () async {
      when(() => repository.toggleTodo('missing')).thenAnswer(
        (_) async => const Left<Failure, Todo>(NotFoundFailure()),
      );

      final result = await useCase('missing');

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<NotFoundFailure>()),
        (_) => fail('Expected failure'),
      );
    });
  });
}