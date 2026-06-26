import 'package:flutter/material.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/error/failures.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/domain/entities/auth_user.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/presentation/riverpod/auth_providers.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/presentation/widgets/login_page.dart';
import 'package:flutter_clean_riverpod_boilerplate/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

Widget _wrap({
  required Widget child,
  required _MockAuthRepository repository,
}) {
  return ProviderScope(
    overrides: [
      authRepositoryProvider.overrideWithValue(repository),
    ],
    child: ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, screenChild) => MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: child,
      ),
    ),
  );
}

void main() {
  late _MockAuthRepository repository;

  setUp(() {
    repository = _MockAuthRepository();
    // Default: no auth needed for these tests.
    when(repository.isAuthenticated).thenAnswer((_) async => false);
  });

  testWidgets('shows validation errors when fields are empty',
      (tester) async {
    await tester.pumpWidget(
      _wrap(child: const LoginPage(), repository: repository),
    );

    // Clear the pre-filled fields.
    await tester.enterText(find.byType(TextFormField).at(0), '');
    await tester.enterText(find.byType(TextFormField).at(1), '');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter your password'), findsOneWidget);
  });

  testWidgets('rejects a short password before calling the repository',
      (tester) async {
    await tester.pumpWidget(
      _wrap(child: const LoginPage(), repository: repository),
    );

    await tester.enterText(find.byType(TextFormField).at(0), 'a@b.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'short');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(find.text('Password must be at least 6 characters'), findsOneWidget);
    verifyNever(() => repository.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ));
  });

  testWidgets('successful login calls repository and shows no error',
      (tester) async {
    when(() => repository.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenAnswer(
      (_) async => const Right<Failure, AuthUser>(
        AuthUser(id: '1', email: 'a@b.com'),
      ),
    );

    await tester.pumpWidget(
      _wrap(child: const LoginPage(), repository: repository),
    );

    // The page pre-fills the demo email + password, so just submit.
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    await tester.pump();

    verify(() => repository.login(
          email: 'demo@example.com',
          password: 'password',
        )).called(1);
  });

  testWidgets('failed login shows a snackbar with a localized message',
      (tester) async {
    when(() => repository.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenAnswer(
      (_) async => const Left<Failure, AuthUser>(UnauthorizedFailure()),
    );

    await tester.pumpWidget(
      _wrap(child: const LoginPage(), repository: repository),
    );

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 750));

    expect(find.byType(SnackBar), findsOneWidget);
    expect(
      find.textContaining('Session expired'),
      findsOneWidget,
    );
  });
}
