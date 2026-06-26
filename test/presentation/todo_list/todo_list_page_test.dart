import 'package:flutter/material.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/error/failures.dart';
import 'package:flutter_clean_riverpod_boilerplate/domain/auth/repositories/auth_repository.dart';
import 'package:flutter_clean_riverpod_boilerplate/domain/todo/entities/todo.dart';
import 'package:flutter_clean_riverpod_boilerplate/domain/todo/repositories/todo_repository.dart';
import 'package:flutter_clean_riverpod_boilerplate/l10n/generated/app_localizations.dart';
import 'package:flutter_clean_riverpod_boilerplate/presentation/auth/riverpod/auth_providers.dart';
import 'package:flutter_clean_riverpod_boilerplate/presentation/todo_list/riverpod/todo_list_providers.dart';
import 'package:flutter_clean_riverpod_boilerplate/presentation/todo_list/todo_list_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

class _MockTodoRepository extends Mock implements TodoRepository {}

Widget _wrap({
  required Widget child,
  required _MockAuthRepository authRepository,
  required _MockTodoRepository todoRepository,
}) {
  return ProviderScope(
    overrides: [
      authRepositoryProvider.overrideWithValue(authRepository),
      todoRepositoryProvider.overrideWithValue(todoRepository),
    ],
    child: ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, _) => MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: child,
      ),
    ),
  );
}

const _seed = [
  Todo(id: '1', title: 'buy milk', completed: false),
  Todo(id: '2', title: 'write tests', completed: true),
];

void main() {
  late _MockAuthRepository authRepository;
  late _MockTodoRepository todoRepository;

  setUp(() {
    authRepository = _MockAuthRepository();
    when(
      authRepository.logout,
    ).thenAnswer((_) async => const Right<Failure, void>(null));
    when(authRepository.isAuthenticated).thenAnswer((_) async => true);

    todoRepository = _MockTodoRepository();
    when(
      () => todoRepository.getTodos(cancelToken: any(named: 'cancelToken')),
    ).thenAnswer((_) async => const Right<Failure, List<Todo>>(_seed));
    when(
      () => todoRepository.toggleTodo(
        any(),
        completed: any(named: 'completed'),
        cancelToken: any(named: 'cancelToken'),
      ),
    ).thenAnswer(
      (_) async => const Right<Failure, Todo>(
        Todo(id: '1', title: 'buy milk', completed: true),
      ),
    );
    when(
      () => todoRepository.createTodo(
        any(),
        cancelToken: any(named: 'cancelToken'),
      ),
    ).thenAnswer(
      (_) async => const Right<Failure, Todo>(
        Todo(id: '3', title: 'new', completed: false),
      ),
    );
    when(
      () => todoRepository.deleteTodo(
        any(),
        cancelToken: any(named: 'cancelToken'),
      ),
    ).thenAnswer((_) async => const Right<Failure, void>(null));
  });

  testWidgets('renders the seeded list with strikethrough on completed items', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        child: const TodoListPage(),
        authRepository: authRepository,
        todoRepository: todoRepository,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('buy milk'), findsOneWidget);
    expect(find.text('write tests'), findsOneWidget);
    expect(find.byType(Checkbox), findsNWidgets(2));
  });

  testWidgets('tapping a checkbox toggles the todo via the repository', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        child: const TodoListPage(),
        authRepository: authRepository,
        todoRepository: todoRepository,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(Checkbox).first);
    await tester.pumpAndSettle();

    verify(
      () => todoRepository.toggleTodo(
        '1',
        completed: true,
        cancelToken: any(named: 'cancelToken'),
      ),
    ).called(1);
  });

  testWidgets('shows an error widget when the repository fails', (
    tester,
  ) async {
    when(
      () => todoRepository.getTodos(cancelToken: any(named: 'cancelToken')),
    ).thenAnswer(
      (_) async => const Left<Failure, List<Todo>>(NetworkFailure()),
    );

    await tester.pumpWidget(
      _wrap(
        child: const TodoListPage(),
        authRepository: authRepository,
        todoRepository: todoRepository,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.error_outline), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets(
    'shows the empty state when the repository returns an empty list',
    (tester) async {
      when(
        () => todoRepository.getTodos(cancelToken: any(named: 'cancelToken')),
      ).thenAnswer((_) async => const Right<Failure, List<Todo>>(<Todo>[]));

      await tester.pumpWidget(
        _wrap(
          child: const TodoListPage(),
          authRepository: authRepository,
          todoRepository: todoRepository,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('No todos yet'), findsOneWidget);
    },
  );
}
