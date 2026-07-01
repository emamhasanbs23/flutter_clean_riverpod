import 'package:flutter/material.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/l10n/l10n_extension.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/notifications/pending_navigation_service.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/notifications/route_descriptor.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/router/todo_routes.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/theme/app_size.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/theme/theme_context_extension.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/presentation/login_page.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/presentation/riverpod/auth_providers.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/splash/presentation/splash_page.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/presentation/todo_detail/todo_detail_page.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/presentation/todo_list/todo_list_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

/// Strongly-typed route name constants. Use these instead of raw strings at
/// call sites to keep navigation refactor-safe.
class AuthRoutes {
  AuthRoutes._();
  static const splash = 'splash';
  static const login = 'login';
}

/// Cold-start gate shown while auth resolves. Not used for in-app navigation.
const _splashPath = '/splash';

/// Top-level [GoRouter] wired with the auth redirect AND the deep-link /
/// push-notification replay.
///
/// The router reads two things on every navigation:
/// - [isAuthenticatedProvider] — drives the login redirect.
/// - [pendingNavigationProvider] — when a deep link / push is queued and
///   the user is authed, the queued destination wins.
///
/// `refreshListenable` is the composition of both signals so a change in
/// either one triggers a redirect re-evaluation.
@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final authRefresh = _AuthRefreshNotifier(ref);
  final pendingBridge = ref.watch(pendingNavigationBridgeProvider);
  final combined = CombinedRefreshListenable([authRefresh, pendingBridge]);
  ref.onDispose(combined.dispose);

  return GoRouter(
    initialLocation: _splashPath,
    refreshListenable: combined,
    redirect: (context, state) => pendingNavigationAwareRedirect(
      matchedLocation: state.matchedLocation,
      auth: ref.read(isAuthenticatedProvider),
      pending: ref.read(pendingNavigationProvider),
    ),
    routes: [
      GoRoute(
        path: _splashPath,
        name: AuthRoutes.splash,
        builder: (_, _) => const SplashPage(),
      ),
      GoRoute(
        path: '/',
        name: TodoRoutes.list,
        builder: (_, _) => const TodoListPage(),
      ),
      GoRoute(
        path: '/todos/:id',
        name: TodoRoutes.detail,
        builder: (context, state) {
          final rawExtra = state.extra;
          return TodoDetailPage(
            id: state.pathParameters['id']!,
            extra: rawExtra is Map<String, Object?> ? rawExtra : null,
          );
        },
      ),
      GoRoute(
        path: '/login',
        name: AuthRoutes.login,
        builder: (_, _) => const LoginPage(),
      ),
    ],
    errorBuilder: (context, state) => UnknownRoutePage(error: state.error),
  );
}

/// Pure decision function used by the router's `redirect` callback.
///
/// Inputs:
/// - [matchedLocation]: the path the user is currently trying to land on.
/// - [auth]: the current auth state (loading → stay put; resolved → use
///   `value`).
/// - [pending]: the queued deep-link / push destination, if any.
///
/// Returns the path to redirect to, or `null` to stay put.
///
/// Rules (in priority order):
/// 1. While auth is still resolving (cold start), land on [_splashPath] so
///    protected pages (todo list, detail) are not built prematurely.
/// 2. If a destination is pending AND the user is authenticated, redirect
///    to it. **This is what makes push notifications land correctly even
///    while the router is still considering the cold-start route.**
/// 3. Otherwise apply the standard auth-guard rules (login redirect).
String? pendingNavigationAwareRedirect({
  required String matchedLocation,
  required AsyncValue<bool> auth,
  required RouteDescriptor? pending,
}) {
  if (auth.isLoading) {
    return matchedLocation == _splashPath ? null : _splashPath;
  }

  final isLoggedIn = auth.value ?? false;

  // (2) Pending destination: if the user is authed, deliver it; if not, the
  // auth guard below will bounce them to /login and the destination is
  // preserved on the pending provider for replay after login.
  if (pending != null && isLoggedIn) {
    return pending.toLocation();
  }

  // (3) Standard auth guard.
  return authRedirect(matchedLocation, auth);
}

/// Pure auth-only decision. Kept exported so it can be unit-tested
/// independently of the pending-navigation rule above.
String? authRedirect(String matchedLocation, AsyncValue<bool> authAsync) {
  if (authAsync.isLoading) {
    return matchedLocation == _splashPath ? null : _splashPath;
  }

  final isLoggedIn = authAsync.value ?? false;
  final goingToLogin = matchedLocation == '/login';
  final onSplash = matchedLocation == _splashPath;

  if (onSplash) {
    return isLoggedIn ? '/' : '/login';
  }

  if (!isLoggedIn && !goingToLogin) return '/login';
  if (isLoggedIn && goingToLogin) return '/';
  return null;
}

/// Bridges Riverpod's [isAuthenticatedProvider] into GoRouter's
/// [Listenable]-based refresh mechanism.
class _AuthRefreshNotifier extends ChangeNotifier {
  _AuthRefreshNotifier(this._ref) {
    _subscription = _ref.listen<AsyncValue<bool>>(
      isAuthenticatedProvider,
      (_, _) => notifyListeners(),
    );
  }

  final Ref _ref;
  late final ProviderSubscription<AsyncValue<bool>> _subscription;

  @override
  void dispose() {
    _subscription.close();
    super.dispose();
  }
}

/// 404 / unknown-route page. Renders the same error widget used by failed
/// data loads so the visual language is consistent, with an extra
/// "Go home" affordance.
class UnknownRoutePage extends StatelessWidget {
  const UnknownRoutePage({super.key, this.error});

  final Object? error;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.errorNotFound)),
      body: Center(
        child: Padding(
          padding: AppSize.pagePadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.help_outline,
                size: AppSize.iconLg,
                color: context.colors.outline,
              ),
              SizedBox(height: AppSize.spaceLg),
              Text(
                l10n.errorNotFound,
                textAlign: TextAlign.center,
                style: context.textTheme.bodyLarge,
              ),
              SizedBox(height: AppSize.spaceLg),
              ElevatedButton(
                onPressed: () => context.go('/'),
                child: Text(l10n.todoListTitle),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
