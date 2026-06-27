import 'package:flutter/material.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/error/failures.dart';
import 'package:flutter_clean_riverpod_boilerplate/domain/auth/repositories/auth_repository.dart';
import 'package:flutter_clean_riverpod_boilerplate/domain/todo/entities/todo.dart';
import 'package:flutter_clean_riverpod_boilerplate/domain/todo/repositories/todo_repository.dart';
import 'package:flutter_clean_riverpod_boilerplate/l10n/generated/app_localizations.dart';
import 'package:flutter_clean_riverpod_boilerplate/presentation/auth/riverpod/auth_providers.dart';
import 'package:flutter_clean_riverpod_boilerplate/presentation/todo_detail/todo_detail_page.dart';
import 'package:flutter_clean_riverpod_boilerplate/presentation/todo_list/riverpod/todo_list_providers.dart';
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

const _todo1 = Todo(id: '1', title: 'buy milk', completed: false);
const _todo2 = Todo(id: '2', title: 'write tests', completed: true);

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
      () => todoRepository.getTodo('1', cancelToken: any(named: 'cancelToken')),
    ).thenAnswer((_) async => const Right<Failure, Todo>(_todo1));
    when(
      () => todoRepository.getTodo('2', cancelToken: any(named: 'cancelToken')),
    ).thenAnswer((_) async => const Right<Failure, Todo>(_todo2));
    when(
      () =>
          todoRepository.getTodo('999', cancelToken: any(named: 'cancelToken')),
    ).thenAnswer((_) async => const Left<Failure, Todo>(NotFoundFailure()));
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
    verify(
      () => todoRepository.getTodo('1', cancelToken: any(named: 'cancelToken')),
    ).called(1);
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

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    expect(find.text(l10n.errorNotFound), findsOneWidget);
  });

  testWidgets('shows an error widget with retry on network failure', (
    tester,
  ) async {
    when(
      () => todoRepository.getTodo('7', cancelToken: any(named: 'cancelToken')),
    ).thenAnswer((_) async => const Left<Failure, Todo>(NetworkFailure()));

    await tester.pumpWidget(
      _wrap(
        child: const TodoDetailPage(id: '7'),
        authRepository: authRepository,
        todoRepository: todoRepository,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.error_outline), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets('accepts a `extra` map (used by push notifications)', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        child: const TodoDetailPage(id: '1', extra: {'focus': 'title'}),
        authRepository: authRepository,
        todoRepository: todoRepository,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('buy milk'), findsOneWidget);
  });
}
