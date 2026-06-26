import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_clean_riverpod_boilerplate/core/error/failures.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/presentation/riverpod/auth_providers.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/domain/entities/todo.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/domain/repositories/todo_repository.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/presentation/widgets/todo_detail_page.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/presentation/riverpod/todo_providers.dart';
import 'package:flutter_clean_riverpod_boilerplate/l10n/generated/app_localizations.dart';

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
    when(authRepository.logout).thenAnswer(
      (_) async => const Right<Failure, void>(null),
    );
    when(authRepository.isAuthenticated).thenAnswer((_) async => true);

    todoRepository = _MockTodoRepository();
    when(() => todoRepository.getTodos()).thenAnswer(
      (_) async => const Right<Failure, List<Todo>>(_seed),
    );
  });

  testWidgets('renders the matching todo with id and title', (tester) async {
    await tester.pumpWidget(
      _wrap(
        child: const TodoDetailPage(id: '1'),
        authRepository: authRepository,
        todoRepository: todoRepository,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('buy milk'), findsOneWidget);
    expect(find.text('Todo #1'), findsOneWidget);
    expect(find.text('Pending'), findsOneWidget);
  });

  testWidgets('renders completed state for completed todos', (tester) async {
    await tester.pumpWidget(
      _wrap(
        child: const TodoDetailPage(id: '2'),
        authRepository: authRepository,
        todoRepository: todoRepository,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('write tests'), findsOneWidget);
    expect(find.text('Completed'), findsOneWidget);
  });

  testWidgets('shows an error widget when the id is unknown', (tester) async {
    await tester.pumpWidget(
      _wrap(
        child: const TodoDetailPage(id: '999'),
        authRepository: authRepository,
        todoRepository: todoRepository,
      ),
    );
    await tester.pumpAndSettle();

    // Falls back to the localized "Not found" message.
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    expect(find.text(l10n.errorNotFound), findsOneWidget);
  });

  testWidgets('accepts a `extra` map (used by push notifications)',
      (tester) async {
    await tester.pumpWidget(
      _wrap(
        child: const TodoDetailPage(
          id: '1',
          extra: {'focus': 'title'},
        ),
        authRepository: authRepository,
        todoRepository: todoRepository,
      ),
    );
    await tester.pumpAndSettle();

    // The page is happy with the extra map; the title still renders.
    expect(find.text('buy milk'), findsOneWidget);
  });
}