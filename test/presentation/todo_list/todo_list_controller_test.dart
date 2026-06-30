import 'package:flutter_clean_riverpod_boilerplate/core/error/failures.dart';
import 'package:flutter_clean_riverpod_boilerplate/domain/todo/entities/todo.dart';
import 'package:flutter_clean_riverpod_boilerplate/domain/todo/entities/todo_page.dart';
import 'package:flutter_clean_riverpod_boilerplate/domain/todo/repositories/todo_repository.dart';
import 'package:flutter_clean_riverpod_boilerplate/presentation/todo_list/riverpod/todo_list_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockTodoRepository extends Mock implements TodoRepository {}

const _seed = [
  Todo(id: '1', title: 'first', completed: false),
  Todo(id: '2', title: 'second', completed: true),
  Todo(id: '3', title: 'third', completed: false),
];

TodoPage _page(List<Todo> todos, {required int total, int skip = 0}) =>
    TodoPage(
      todos: todos,
      total: total,
      skip: skip,
      limit: TodoListPageSize.defaultLimit,
    );

void main() {
  group('TodoListController', () {
    late _MockTodoRepository repository;
    late ProviderContainer container;

    setUp(() {
      repository = _MockTodoRepository();
      when(
        () => repository.getTodos(
          limit: any(named: 'limit'),
          skip: any(named: 'skip'),
          cancelToken: any(named: 'cancelToken'),
        ),
      ).thenAnswer(
        (_) async =>
            Right<Failure, TodoPage>(_page(_seed, total: _seed.length)),
      );
      when(
        () => repository.createTodo(
          any(),
          cancelToken: any(named: 'cancelToken'),
        ),
      ).thenAnswer(
        (_) async => const Right<Failure, Todo>(
          Todo(id: '4', title: 'new', completed: false),
        ),
      );
      when(
        () => repository.toggleTodo(
          any(),
          completed: any(named: 'completed'),
          cancelToken: any(named: 'cancelToken'),
        ),
      ).thenAnswer(
        (_) async => const Right<Failure, Todo>(
          Todo(id: '1', title: 'first', completed: true),
        ),
      );
      when(
        () => repository.deleteTodo(
          any(),
          cancelToken: any(named: 'cancelToken'),
        ),
      ).thenAnswer((_) async => const Right<Failure, void>(null));

      container = ProviderContainer(
        overrides: [todoRepositoryProvider.overrideWithValue(repository)],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('build loads the list as TodoLoaded', () async {
      final state = await container.read(todoListControllerProvider.future);
      expect(state, isA<TodoLoaded>());
      expect((state as TodoLoaded).todos, equals(_seed));
      expect(state.hasMore, isFalse);
    });

    test('loadMore appends the next page when hasMore is true', () async {
      const pageSize = TodoListPageSize.defaultLimit;
      final firstPage = List.generate(
        pageSize,
        (index) => Todo(id: '$index', title: 'todo $index', completed: false),
      );
      final secondPage = [
        const Todo(id: 'last', title: 'last todo', completed: false),
      ];
      const total = pageSize + 1;

      when(
        () => repository.getTodos(
          cancelToken: any(named: 'cancelToken'),
        ),
      ).thenAnswer(
        (_) async => Right<Failure, TodoPage>(_page(firstPage, total: total)),
      );
      when(
        () => repository.getTodos(
          skip: pageSize,
          cancelToken: any(named: 'cancelToken'),
        ),
      ).thenAnswer(
        (_) async => Right<Failure, TodoPage>(
          _page(secondPage, total: total, skip: pageSize),
        ),
      );

      final container2 = ProviderContainer(
        overrides: [todoRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container2.dispose);

      await container2.read(todoListControllerProvider.future);
      await container2.read(todoListControllerProvider.notifier).loadMore();

      final state = container2.read(todoListControllerProvider).value!;
      expect(state, isA<TodoLoaded>());
      expect((state as TodoLoaded).todos.length, total);
      expect(state.hasMore, isFalse);
      verify(
        () => repository.getTodos(
          skip: pageSize,
          cancelToken: any(named: 'cancelToken'),
        ),
      ).called(1);
    });

    test('toggle updates the list optimistically without re-fetch', () async {
      await container.read(todoListControllerProvider.future);
      await container.read(todoListControllerProvider.notifier).toggle('1');

      verify(
        () => repository.toggleTodo(
          '1',
          completed: true,
          cancelToken: any(named: 'cancelToken'),
        ),
      ).called(1);
      verify(
        () => repository.getTodos(
          limit: any(named: 'limit'),
          skip: any(named: 'skip'),
          cancelToken: any(named: 'cancelToken'),
        ),
      ).called(1);

      final state = container.read(todoListControllerProvider).value!;
      expect(state, isA<TodoLoaded>());
      final todos = (state as TodoLoaded).todos;
      expect(todos.firstWhere((t) => t.id == '1').completed, isTrue);
    });

    test('add prepends the new todo without re-fetch', () async {
      await container.read(todoListControllerProvider.future);
      await container.read(todoListControllerProvider.notifier).add('  new  ');

      verify(
        () => repository.createTodo(
          'new',
          cancelToken: any(named: 'cancelToken'),
        ),
      ).called(1);
      verify(
        () => repository.getTodos(
          limit: any(named: 'limit'),
          skip: any(named: 'skip'),
          cancelToken: any(named: 'cancelToken'),
        ),
      ).called(1);

      final state = container.read(todoListControllerProvider).value!;
      expect(state, isA<TodoLoaded>());
      expect((state as TodoLoaded).todos.first.id, '4');
    });

    test('delete removes the item without re-fetch', () async {
      await container.read(todoListControllerProvider.future);
      await container.read(todoListControllerProvider.notifier).delete('2');

      verify(
        () =>
            repository.deleteTodo('2', cancelToken: any(named: 'cancelToken')),
      ).called(1);
      verify(
        () => repository.getTodos(
          limit: any(named: 'limit'),
          skip: any(named: 'skip'),
          cancelToken: any(named: 'cancelToken'),
        ),
      ).called(1);

      final state = container.read(todoListControllerProvider).value!;
      expect(state, isA<TodoLoaded>());
      expect((state as TodoLoaded).todos.where((t) => t.id == '2'), isEmpty);
    });

    test('refresh reloads from the repository', () async {
      await container.read(todoListControllerProvider.future);
      await container.read(todoListControllerProvider.notifier).refresh();

      verify(
        () => repository.getTodos(
          limit: any(named: 'limit'),
          skip: any(named: 'skip'),
          cancelToken: any(named: 'cancelToken'),
        ),
      ).called(2);
    });

    test('build propagates a Failure as TodoError', () async {
      when(
        () => repository.getTodos(
          limit: any(named: 'limit'),
          skip: any(named: 'skip'),
          cancelToken: any(named: 'cancelToken'),
        ),
      ).thenAnswer(
        (_) async => const Left<Failure, TodoPage>(NetworkFailure()),
      );
      final container2 = ProviderContainer(
        overrides: [todoRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container2.dispose);

      final state = await container2.read(todoListControllerProvider.future);
      expect(state, isA<TodoError>());
      expect((state as TodoError).failure, isA<NetworkFailure>());
    });
  });
}
