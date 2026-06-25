import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_clean_riverpod_boilerplate/core/error/failures.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/network/dio_client.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/storage/secure_storage_service.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/data/auth_remote_data_source.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/data/auth_repository_impl.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/domain/auth_repository.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/domain/login_use_case.dart';

/// Broadcast stream of "session expired" events.
///
/// Emitted by the auth layer (e.g. when the [AuthInterceptor] exhausts its
/// refresh retry) so the router can react: invalidate
/// [isAuthenticatedProvider] and the redirect will fire on the next
/// navigation.
///
/// Default value is `null`, meaning no session has ever been invalidated.
final sessionExpiredProvider = StateProvider<bool>((ref) => false);

/// Dio-backed [AuthRemoteDataSource] driven by [dioProvider].
///
/// Tests can override this provider with a fake implementation.
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthRemoteDataSourceImpl(dio);
});

/// Singleton repository bound to the active storage implementation.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final storage = ref.watch(secureStorageServiceProvider);
  final remote = ref.watch(authRemoteDataSourceProvider);
  return AuthRepositoryImpl(
    remoteDataSource: remote,
    storage: storage,
  );
});

/// Domain-layer use case wrapping the repository's login.
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(ref.watch(authRepositoryProvider));
});

/// Synchronous view of whether the user is authenticated.
///
/// The router reads this provider on every redirect, so we keep it cheap:
/// a single secure storage read at construction time, then it stays in
/// memory for the lifetime of the provider.
final isAuthenticatedProvider = FutureProvider<bool>((ref) async {
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
});

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
class LoginController extends Notifier<LoginState> {
  @override
  LoginState build() => const LoginIdle();

  /// Attempts to log in. Returns the success value or null on failure so the
  /// caller can decide whether to navigate.
  Future<bool> submit({required String email, required String password}) async {
    state = const LoginSubmitting();
    final result = await ref.read(loginUseCaseProvider).call(
          email: email,
          password: password,
        );
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

final loginControllerProvider =
    NotifierProvider<LoginController, LoginState>(LoginController.new);

/// Triggers a logout and refreshes the auth provider so the router redirects
/// back to the login screen.
final logoutControllerProvider = Provider<Future<void> Function()>((ref) {
  return () async {
    await ref.read(authRepositoryProvider).logout();
    ref.invalidate(isAuthenticatedProvider);
    // Force an immediate recompute so the router sees the new state now.
    await ref.read(isAuthenticatedProvider.future);
  };
});