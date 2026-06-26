import 'package:flutter_clean_riverpod_boilerplate/core/error/failures.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/domain/entities/todo.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/domain/repositories/todo_repository.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/domain/usecases/create_todo_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockTodoRepository extends Mock implements TodoRepository {}

void main() {
  group('CreateTodoUseCase', () {
    late _MockTodoRepository repository;
    late CreateTodoUseCase useCase;

    setUp(() {
      repository = _MockTodoRepository();
      useCase = CreateTodoUseCase(repository);
    });

    test('rejects empty/whitespace titles without touching the repository',
        () async {
      final result = await useCase('   ');

      expect(
        result,
        equals(const Left<Failure, Todo>(NotFoundFailure('Title is required'))),
      );
      verifyNever(() => repository.createTodo(any()));
    });

    test('trims titles before delegating to the repository', () async {
      const newTodo = Todo(id: '1', title: 'write tests', completed: false);
      when(() => repository.createTodo('write tests')).thenAnswer(
        (_) async => const Right<Failure, Todo>(newTodo),
      );

      final result = await useCase('  write tests  ');

      expect(result.isRight(), isTrue);
      verify(() => repository.createTodo('write tests')).called(1);
      verifyNever(() => repository.createTodo('  write tests  '));
    });

    test('propagates repository failures', () async {
      when(() => repository.createTodo('x')).thenAnswer(
        (_) async => const Left<Failure, Todo>(NetworkFailure()),
      );

      final result = await useCase('x');

      expect(result, equals(const Left<Failure, Todo>(NetworkFailure())));
    });
  });
}
