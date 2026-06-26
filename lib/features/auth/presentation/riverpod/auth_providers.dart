import 'package:flutter_clean_riverpod_boilerplate/core/error/failures.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/network/auth_interceptor.dart'
    show AuthInterceptor;
import 'package:flutter_clean_riverpod_boilerplate/core/network/dio_client.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/storage/secure_storage_service.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/data/api/auth_api.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/data/data_source/auth_remote_data_source_impl.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/data/repository_impl/auth_repository_impl.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/domain/entities/auth_user.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/domain/usecases/get_current_user_use_case.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/domain/usecases/login_use_case.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/domain/usecases/logout_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_providers.g.dart';

/// Broadcast stream of "session expired" events.
///
/// Emitted by the auth layer (e.g. when the [AuthInterceptor] exhausts its
/// refresh retry) so the router can react: invalidate
/// [isAuthenticatedProvider] and the redirect will fire on the next
/// navigation.
@Riverpod(keepAlive: true)
class SessionExpired extends _$SessionExpired {
  @override
  bool build() => false;

  /// Flips the session-expired flag so auth providers and the router react.
  void markExpired() => state = true;
}

/// Retrofit-generated `AuthApi` bound to the configured `Dio`.
///
/// Shares the same Dio instance (and therefore the same
/// [AuthInterceptor]) with the rest of the app, so the 401 -> dedup ->
/// refresh -> retry funnel keeps working unchanged.
@Riverpod(keepAlive: true)
AuthApi authApi(Ref ref) {
  return AuthApi(ref.watch(dioProvider));
}

/// Dio-backed [AuthRemoteDataSource] driven by [authApiProvider].
///
/// Tests can override this provider with a fake implementation.
@Riverpod(keepAlive: true)
AuthRemoteDataSource authRemoteDataSource(Ref ref) {
  return AuthRemoteDataSourceImpl(ref.watch(authApiProvider));
}

/// Singleton repository bound to the active storage implementation.
@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  final storage = ref.watch(secureStorageServiceProvider);
  final remote = ref.watch(authRemoteDataSourceProvider);
  return AuthRepositoryImpl(remoteDataSource: remote, storage: storage);
}

/// Domain-layer use case wrapping the repository's login.
@Riverpod(keepAlive: true)
LoginUseCase loginUseCase(Ref ref) {
  return LoginUseCase(ref.watch(authRepositoryProvider));
}

/// Reads the persisted user from secure storage. Returns `null` when no user
/// is logged in. Invalidated whenever [logoutControllerProvider] runs.
@Riverpod(keepAlive: true)
GetCurrentUserUseCase getCurrentUserUseCase(Ref ref) {
  return GetCurrentUserUseCase(ref.watch(authRepositoryProvider));
}

/// Domain-layer use case wrapping the repository's logout.
@Riverpod(keepAlive: true)
LogoutUseCase logoutUseCase(Ref ref) {
  return LogoutUseCase(ref.watch(authRepositoryProvider));
}

/// Async snapshot of the currently logged-in user. `null` inside the data
/// means "no user" (logged-out) — `AsyncValue.error` means the storage read
/// itself failed.
@Riverpod(keepAlive: true)
Future<AuthUser?> currentUser(Ref ref) async {
  final result = await ref.watch(getCurrentUserUseCaseProvider).call();
  return result.fold((failure) => throw failure, (user) => user);
}

/// Synchronous view of whether the user is authenticated.
///
/// The router reads this provider on every redirect, so we keep it cheap:
/// a single secure storage read at construction time, then it stays in
/// memory for the lifetime of the provider.
@Riverpod(keepAlive: true)
Future<bool> isAuthenticated(Ref ref) async {
  // When the [AuthInterceptor] gives up on a refresh, it flips
  // [sessionExpiredProvider]. We listen here so the auth state re-evaluates
  // and the router redirects to the login screen.
  ref.listen<bool>(sessionExpiredProvider, (previous, isExpired) {
    if (isExpired) {
      ref.invalidateSelf();
    }
  });
  final repository = ref.watch(authRepositoryProvider);
  return repository.isAuthenticated();
}

/// Sealed view of the login submission lifecycle so the UI can render
/// appropriate loading / error states without parsing nullable values.
sealed class LoginState {
  const LoginState();
}

class LoginIdle extends LoginState {
  const LoginIdle();
}

class LoginSubmitting extends LoginState {
  const LoginSubmitting();
}

/// Carries the domain [Failure] so the page can render a localized message
/// via `failure.toMessage(context)` at the render site. We do NOT store a
/// pre-localized string here because BuildContext is unavailable inside
/// the controller and we want one source of truth for failure text.
class LoginError extends LoginState {
  const LoginError(this.failure);
  final Failure failure;
}

class LoginSuccess extends LoginState {
  const LoginSuccess();
}

/// Holds the current submission state plus simple form controllers.
@Riverpod(keepAlive: true)
class LoginController extends _$LoginController {
  @override
  LoginState build() => const LoginIdle();

  /// Attempts to log in. Returns the success value or null on failure so the
  /// caller can decide whether to navigate.
  Future<bool> submit({required String email, required String password}) async {
    state = const LoginSubmitting();
    final result = await ref
        .read(loginUseCaseProvider)
        .call(email: email, password: password);
    return result.fold(
      (failure) {
        state = LoginError(failure);
        return false;
      },
      (_) {
        // Invalidate the auth provider so the router picks up the new state.
        ref.invalidate(isAuthenticatedProvider);
        state = const LoginSuccess();
        return true;
      },
    );
  }
}

/// Triggers a logout and refreshes the auth provider so the router redirects
/// back to the login screen.
@Riverpod(keepAlive: true)
Future<void> Function() logoutController(Ref ref) {
  return () async {
    await ref.read(logoutUseCaseProvider).call();
    ref
      ..invalidate(isAuthenticatedProvider)
      ..invalidate(currentUserProvider);
    // Force an immediate recompute so the router sees the new state now.
    await ref.read(isAuthenticatedProvider.future);
  };
}
