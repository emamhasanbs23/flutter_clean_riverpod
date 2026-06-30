import 'package:flutter_clean_riverpod_boilerplate/core/error/failures.dart';
import 'package:flutter_clean_riverpod_boilerplate/data/todo/data_source/todo_data_source.dart';
import 'package:flutter_clean_riverpod_boilerplate/data/todo/mock/todo_mock_source.dart';
import 'package:flutter_clean_riverpod_boilerplate/data/todo/repository_impl/todo_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TodoRepositoryImpl', () {
    late TodoDataSource dataSource;
    late TodoRepositoryImpl repository;

    setUp(() {
      // Zero latency so tests don't sleep.
      dataSource = TodoMockSource(latency: Duration.zero);
      repository = TodoRepositoryImpl(dataSource: dataSource);
    });

    test('getTodos returns the seeded list as domain entities', () async {
      final result = await repository.getTodos();

      expect(result.isRight(), isTrue);
      final page = result.fold((_) => null, (p) => p);
      expect(page, isNotNull);
      expect(page!.todos, isNotEmpty);
      expect(
        page.todos.any((t) => t.title == 'Wire up Riverpod providers'),
        isTrue,
      );
      expect(page.hasMore, isFalse);
    });

    test('getTodo returns a single domain entity by id', () async {
      final result = await repository.getTodo('1');

      expect(result.isRight(), isTrue);
      result.fold((_) => fail('Expected success'), (todo) {
        expect(todo.id, '1');
        expect(todo.title, 'Read the Clean Architecture book');
      });
    });

    test('getTodo returns NotFoundFailure for unknown id', () async {
      final result = await repository.getTodo('does-not-exist');

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<NotFoundFailure>()),
        (_) => fail('Expected failure'),
      );
    });

    test('getTodos paginates through the mock source', () async {
      final first = await repository.getTodos(limit: 2);
      final second = await repository.getTodos(limit: 2, skip: 2);

      first.fold((_) => fail('Expected success'), (page) {
        expect(page.todos.length, 2);
        expect(page.hasMore, isTrue);
      });
      second.fold((_) => fail('Expected success'), (page) {
        expect(page.todos.length, 1);
        expect(page.hasMore, isFalse);
      });
    });

    test('createTodo prepends the new todo to the list', () async {
      final initialLength = await repository.getTodos().then(
        (r) => r.fold((_) => 0, (page) => page.todos.length),
      );

      final result = await repository.createTodo('Buy milk');

      expect(result.isRight(), isTrue);
      result.fold((_) => fail('Expected success'), (todo) {
        expect(todo.title, 'Buy milk');
        expect(todo.completed, isFalse);
      });

      final after = await repository.getTodos();
      after.fold((_) => fail('Expected success'), (page) {
        expect(page.todos.length, initialLength + 1);
        expect(page.todos.first.title, 'Buy milk');
      });
    });

    test('toggleTodo flips completion flag', () async {
      final loaded = await repository.getTodos();
      final original = loaded
          .fold((_) => throw StateError('no data'), (page) => page.todos)
          .first;

      final result = await repository.toggleTodo(
        original.id,
        completed: !original.completed,
      );

      expect(result.isRight(), isTrue);
      result.fold((_) => fail('Expected success'), (todo) {
        expect(todo.id, original.id);
        expect(todo.completed, !original.completed);
      });
    });

    test('toggleTodo returns NotFoundFailure for unknown id', () async {
      final result = await repository.toggleTodo(
        'does-not-exist',
        completed: true,
      );

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<NotFoundFailure>()),
        (_) => fail('Expected failure'),
      );
    });

    test('deleteTodo removes the item and returns Right(null)', () async {
      final loaded = await repository.getTodos();
      final target = loaded
          .fold((_) => throw StateError('no data'), (page) => page.todos)
          .first;

      final result = await repository.deleteTodo(target.id);
      expect(result.isRight(), isTrue);

      final after = await repository.getTodos();
      after.fold(
        (_) => fail('Expected success'),
        (page) => expect(page.todos.where((t) => t.id == target.id), isEmpty),
      );
    });
  });
}
