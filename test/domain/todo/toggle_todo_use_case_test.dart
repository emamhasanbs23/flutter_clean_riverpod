import 'package:flutter_clean_riverpod_boilerplate/core/error/failures.dart';
import 'package:flutter_clean_riverpod_boilerplate/domain/todo/entities/todo.dart';
import 'package:flutter_clean_riverpod_boilerplate/domain/todo/repositories/todo_repository.dart';
import 'package:flutter_clean_riverpod_boilerplate/domain/todo/usecases/toggle_todo_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockTodoRepository extends Mock implements TodoRepository {}

void main() {
  group('ToggleTodoUseCase', () {
    late _MockTodoRepository repository;
    late ToggleTodoUseCase useCase;

    setUp(() {
      repository = _MockTodoRepository();
      useCase = ToggleTodoUseCase(repository);
    });

    test('forwards id and completed to the repository', () async {
      const toggled = Todo(id: '42', title: 'x', completed: true);
      when(
        () => repository.toggleTodo(
          '42',
          completed: true,
          cancelToken: any(named: 'cancelToken'),
        ),
      ).thenAnswer((_) async => const Right<Failure, Todo>(toggled));

      final result = await useCase('42', completed: true);

      expect(result, equals(const Right<Failure, Todo>(toggled)));
      verify(
        () => repository.toggleTodo(
          '42',
          completed: true,
          cancelToken: any(named: 'cancelToken'),
        ),
      ).called(1);
    });

    test('propagates repository failures', () async {
      when(
        () => repository.toggleTodo(
          'missing',
          completed: false,
          cancelToken: any(named: 'cancelToken'),
        ),
      ).thenAnswer((_) async => const Left<Failure, Todo>(NotFoundFailure()));

      final result = await useCase('missing', completed: false);

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<NotFoundFailure>()),
        (_) => fail('Expected failure'),
      );
    });
  });
}
