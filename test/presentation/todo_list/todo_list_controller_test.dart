import 'package:flutter_clean_riverpod_boilerplate/core/error/failures.dart';
import 'package:flutter_clean_riverpod_boilerplate/domain/todo/entities/todo.dart';
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
];

void main() {
  group('TodoListController', () {
    late _MockTodoRepository repository;
    late ProviderContainer container;

    setUp(() {
      repository = _MockTodoRepository();
      when(
        () => repository.getTodos(cancelToken: any(named: 'cancelToken')),
      ).thenAnswer((_) async => const Right<Failure, List<Todo>>(_seed));
      when(
        () => repository.createTodo(
          any(),
          cancelToken: any(named: 'cancelToken'),
        ),
      ).thenAnswer(
        (_) async => const Right<Failure, Todo>(
          Todo(id: '3', title: 'new', completed: false),
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
        () => repository.getTodos(cancelToken: any(named: 'cancelToken')),
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
        () => repository.getTodos(cancelToken: any(named: 'cancelToken')),
      ).called(1);

      final state = container.read(todoListControllerProvider).value!;
      expect(state, isA<TodoLoaded>());
      expect((state as TodoLoaded).todos.first.id, '3');
    });

    test('delete removes the item without re-fetch', () async {
      await container.read(todoListControllerProvider.future);
      await container.read(todoListControllerProvider.notifier).delete('2');

      verify(
        () =>
            repository.deleteTodo('2', cancelToken: any(named: 'cancelToken')),
      ).called(1);
      verify(
        () => repository.getTodos(cancelToken: any(named: 'cancelToken')),
      ).called(1);

      final state = container.read(todoListControllerProvider).value!;
      expect(state, isA<TodoLoaded>());
      expect((state as TodoLoaded).todos.where((t) => t.id == '2'), isEmpty);
    });

    test('refresh reloads from the repository', () async {
      await container.read(todoListControllerProvider.future);
      await container.read(todoListControllerProvider.notifier).refresh();

      verify(
        () => repository.getTodos(cancelToken: any(named: 'cancelToken')),
      ).called(2);
    });

    test('build propagates a Failure as TodoError', () async {
      when(
        () => repository.getTodos(cancelToken: any(named: 'cancelToken')),
      ).thenAnswer(
        (_) async => const Left<Failure, List<Todo>>(NetworkFailure()),
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
