import 'package:flutter_clean_riverpod_boilerplate/core/error/failures.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/data/data_source/todo_mock_data_source.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/data/data_source/todo_remote_data_source.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/data/repository_impl/todo_repository_impl.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/domain/entities/todo.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TodoRepositoryImpl', () {
    late TodoDataSource dataSource;
    late TodoRepositoryImpl repository;

    setUp(() {
      // Zero latency so tests don't sleep.
      dataSource = TodoMockDataSource(latency: Duration.zero);
      repository = TodoRepositoryImpl(dataSource: dataSource);
    });

    test('getTodos returns the seeded list as domain entities', () async {
      final result = await repository.getTodos();

      expect(result.isRight(), isTrue);
      final todos = result.fold((_) => <Todo>[], (t) => t);
      expect(todos, isNotEmpty);
      expect(todos.any((t) => t.title == 'Wire up Riverpod providers'), isTrue);
    });

    test('createTodo prepends the new todo to the list', () async {
      final initialLength = await repository.getTodos().then(
        (r) => r.fold((_) => 0, (todos) => todos.length),
      );

      final result = await repository.createTodo('Buy milk');

      expect(result.isRight(), isTrue);
      result.fold((_) => fail('Expected success'), (todo) {
        expect(todo.title, 'Buy milk');
        expect(todo.completed, isFalse);
      });

      final after = await repository.getTodos();
      after.fold((_) => fail('Expected success'), (todos) {
        expect(todos.length, initialLength + 1);
        expect(todos.first.title, 'Buy milk');
      });
    });

    test('toggleTodo flips completion flag', () async {
      final loaded = await repository.getTodos();
      final original = loaded
          .fold((_) => throw StateError('no data'), (t) => t)
          .first;

      final result = await repository.toggleTodo(original.id);

      expect(result.isRight(), isTrue);
      result.fold((_) => fail('Expected success'), (todo) {
        expect(todo.id, original.id);
        expect(todo.completed, !original.completed);
      });
    });

    test('toggleTodo returns NotFoundFailure for unknown id', () async {
      final result = await repository.toggleTodo('does-not-exist');

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<NotFoundFailure>()),
        (_) => fail('Expected failure'),
      );
    });

    test('deleteTodo removes the item and returns Right(null)', () async {
      final loaded = await repository.getTodos();
      final target = loaded
          .fold((_) => throw StateError('no data'), (t) => t)
          .first;

      final result = await repository.deleteTodo(target.id);
      expect(result.isRight(), isTrue);

      final after = await repository.getTodos();
      after.fold(
        (_) => fail('Expected success'),
        (todos) => expect(todos.where((t) => t.id == target.id), isEmpty),
      );
    });
  });
}
