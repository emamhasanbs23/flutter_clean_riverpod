import 'package:dio/dio.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/error/failures.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/domain/entities/todo.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/domain/repositories/todo_repository.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/domain/usecases/get_todo_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockTodoRepository extends Mock implements TodoRepository {}

void main() {
  group('GetTodoUseCase', () {
    late _MockTodoRepository repository;
    late GetTodoUseCase useCase;

    setUp(() {
      repository = _MockTodoRepository();
      useCase = GetTodoUseCase(repository);
    });

    test('delegates to the repository and returns its success', () async {
      const todo = Todo(id: '1', title: 'a', completed: false);
      when(
        () => repository.getTodo('1', cancelToken: any(named: 'cancelToken')),
      ).thenAnswer((_) async => const Right<Failure, Todo>(todo));

      final result = await useCase('1');

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected success'),
        (value) => expect(value, equals(todo)),
      );
      verify(
        () => repository.getTodo('1', cancelToken: any(named: 'cancelToken')),
      ).called(1);
    });

    test('propagates NotFoundFailure from the repository', () async {
      when(
        () => repository.getTodo('999', cancelToken: any(named: 'cancelToken')),
      ).thenAnswer((_) async => const Left<Failure, Todo>(NotFoundFailure()));

      final result = await useCase('999');

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<NotFoundFailure>()),
        (_) => fail('Expected failure'),
      );
    });

    test('forwards cancelToken to the repository', () async {
      final token = CancelToken();
      when(() => repository.getTodo('1', cancelToken: token)).thenAnswer(
        (_) async => const Right<Failure, Todo>(
          Todo(id: '1', title: 'a', completed: false),
        ),
      );

      await useCase('1', cancelToken: token);

      verify(() => repository.getTodo('1', cancelToken: token)).called(1);
    });
  });
}
