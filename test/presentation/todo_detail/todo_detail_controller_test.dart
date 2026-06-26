import 'package:flutter_clean_riverpod_boilerplate/core/error/failures.dart';
import 'package:flutter_clean_riverpod_boilerplate/domain/todo/entities/todo.dart';
import 'package:flutter_clean_riverpod_boilerplate/domain/todo/repositories/todo_repository.dart';
import 'package:flutter_clean_riverpod_boilerplate/presentation/todo_detail/riverpod/todo_detail_providers.dart';
import 'package:flutter_clean_riverpod_boilerplate/presentation/todo_list/riverpod/todo_list_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockTodoRepository extends Mock implements TodoRepository {}

const _todo = Todo(id: '1', title: 'buy milk', completed: false);

void main() {
  group('TodoDetailController', () {
    late _MockTodoRepository repository;
    late ProviderContainer container;

    setUp(() {
      repository = _MockTodoRepository();
      container = ProviderContainer(
        overrides: [todoRepositoryProvider.overrideWithValue(repository)],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('build loads the todo as TodoDetailLoaded', () async {
      when(
        () => repository.getTodo('1', cancelToken: any(named: 'cancelToken')),
      ).thenAnswer((_) async => const Right<Failure, Todo>(_todo));

      final state = await container.read(
        todoDetailControllerProvider('1').future,
      );

      expect(state, isA<TodoDetailLoaded>());
      expect((state as TodoDetailLoaded).todo, equals(_todo));
    });

    test(
      'build returns TodoDetailNotFound when repository fails with 404',
      () async {
        when(
          () =>
              repository.getTodo('999', cancelToken: any(named: 'cancelToken')),
        ).thenAnswer((_) async => const Left<Failure, Todo>(NotFoundFailure()));

        final state = await container.read(
          todoDetailControllerProvider('999').future,
        );

        expect(state, isA<TodoDetailNotFound>());
      },
    );

    test('build returns TodoDetailError for other failures', () async {
      when(
        () => repository.getTodo('1', cancelToken: any(named: 'cancelToken')),
      ).thenAnswer((_) async => const Left<Failure, Todo>(NetworkFailure()));

      final state = await container.read(
        todoDetailControllerProvider('1').future,
      );

      expect(state, isA<TodoDetailError>());
      expect((state as TodoDetailError).failure, isA<NetworkFailure>());
    });

    test('refresh reloads from the repository', () async {
      when(
        () => repository.getTodo('1', cancelToken: any(named: 'cancelToken')),
      ).thenAnswer((_) async => const Right<Failure, Todo>(_todo));

      await container.read(todoDetailControllerProvider('1').future);
      await container
          .read(todoDetailControllerProvider('1').notifier)
          .refresh();

      verify(
        () => repository.getTodo('1', cancelToken: any(named: 'cancelToken')),
      ).called(2);
    });
  });
}
