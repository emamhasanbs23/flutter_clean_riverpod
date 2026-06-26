import 'package:flutter_clean_riverpod_boilerplate/core/error/failures.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/domain/entities/todo.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/domain/repositories/todo_repository.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/presentation/riverpod/todo_providers.dart';
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
      // getTodos is called by the build() / _load() helpers; pre-stub.
      when(() => repository.getTodos()).thenAnswer(
        (_) async => const Right<Failure, List<Todo>>(_seed),
      );
      when(() => repository.createTodo(any())).thenAnswer(
        (_) async => const Right<Failure, Todo>(
          Todo(id: '3', title: 'new', completed: false),
        ),
      );
      when(() => repository.toggleTodo(any())).thenAnswer(
        (_) async => const Right<Failure, Todo>(
          Todo(id: '1', title: 'first', completed: true),
        ),
      );
      when(() => repository.deleteTodo(any())).thenAnswer(
        (_) async => const Right<Failure, void>(null),
      );

      container = ProviderContainer(
        overrides: [
          todoRepositoryProvider.overrideWithValue(repository),
        ],
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

    test('toggle re-fetches the list when successful', () async {
      await container.read(todoListControllerProvider.future);
      await container.read(todoListControllerProvider.notifier).toggle('1');
      // Initial load + post-toggle reload.
      verify(() => repository.toggleTodo('1')).called(1);
      verify(() => repository.getTodos()).called(2);
    });

    test('add re-fetches the list with the trimmed title', () async {
      await container.read(todoListControllerProvider.future);
      await container.read(todoListControllerProvider.notifier).add('  new  ');
      verify(() => repository.createTodo('new')).called(1);
      verify(() => repository.getTodos()).called(2);
    });

    test('delete re-fetches the list when successful', () async {
      await container.read(todoListControllerProvider.future);
      await container.read(todoListControllerProvider.notifier).delete('2');
      verify(() => repository.deleteTodo('2')).called(1);
      verify(() => repository.getTodos()).called(2);
    });

    test('build propagates a Failure as TodoError', () async {
      when(() => repository.getTodos()).thenAnswer(
        (_) async => const Left<Failure, List<Todo>>(NetworkFailure()),
      );
      final container2 = ProviderContainer(
        overrides: [
          todoRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container2.dispose);

      final state = await container2.read(todoListControllerProvider.future);
      expect(state, isA<TodoError>());
      expect((state as TodoError).failure, isA<NetworkFailure>());
    });
  });
}
