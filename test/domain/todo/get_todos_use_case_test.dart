import 'package:flutter_clean_riverpod_boilerplate/core/error/failures.dart';
import 'package:flutter_clean_riverpod_boilerplate/domain/todo/entities/todo.dart';
import 'package:flutter_clean_riverpod_boilerplate/domain/todo/entities/todo_page.dart';
import 'package:flutter_clean_riverpod_boilerplate/domain/todo/repositories/todo_repository.dart';
import 'package:flutter_clean_riverpod_boilerplate/domain/todo/usecases/get_todos_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockTodoRepository extends Mock implements TodoRepository {}

TodoPage _todoPage(List<Todo> todos, {int total = 0, int skip = 0}) => TodoPage(
  todos: todos,
  total: total == 0 ? todos.length : total,
  skip: skip,
  limit: TodoListPageSize.defaultLimit,
);

void main() {
  group('GetTodosUseCase', () {
    late _MockTodoRepository repository;
    late GetTodosUseCase useCase;

    setUp(() {
      repository = _MockTodoRepository();
      useCase = GetTodosUseCase(repository);
    });

    test('delegates to the repository and returns its success', () async {
      final page = _todoPage([
        const Todo(id: '1', title: 'a', completed: false),
      ]);
      when(
        () => repository.getTodos(
          limit: any(named: 'limit'),
          skip: any(named: 'skip'),
          cancelToken: any(named: 'cancelToken'),
        ),
      ).thenAnswer((_) async => Right<Failure, TodoPage>(page));

      final result = await useCase();

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected success'),
        (loaded) => expect(loaded.todos, equals(page.todos)),
      );
      verify(
        () => repository.getTodos(
          cancelToken: any(named: 'cancelToken'),
        ),
      ).called(1);
    });

    test('propagates repository failures', () async {
      when(
        () => repository.getTodos(
          limit: any(named: 'limit'),
          skip: any(named: 'skip'),
          cancelToken: any(named: 'cancelToken'),
        ),
      ).thenAnswer(
        (_) async => const Left<Failure, TodoPage>(UnexpectedFailure()),
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
