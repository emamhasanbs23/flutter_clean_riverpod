import 'package:dio/dio.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/config/flavor.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/network/auth_interceptor.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/storage/secure_storage_service.dart';
import 'package:flutter_clean_riverpod_boilerplate/domain/auth/repositories/auth_repository.dart'
    show AuthRepository;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_client.g.dart';

/// Builds a configured [Dio] instance for the active [FlavorConfig].
///
/// The `authRepositoryBuilder` is a callback that returns the auth repository
/// at request time, so the `AuthInterceptor` can refresh expired tokens via
/// the same repository singleton the rest of the app uses. The callback is
/// deferred (not invoked here) to avoid an import cycle: `core/network` does
/// not import `data/auth`.
///
/// The `onSessionExpired` callback is invoked when the interceptor gives up
/// on refreshing an expired token (network error or revoked refresh token).
/// Bootstrap uses this to flip `sessionExpiredProvider` so the router can
/// redirect to the login screen.
class DioClient {
  static Dio create({
    required FlavorConfig config,
    required SecureStorageService storage,
    required DioAuthRepositoryBuilder authRepositoryBuilder,
    void Function()? onSessionExpired,
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: config.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        headers: const {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      AuthInterceptor(
        dio,
        storage,
        authRepositoryBuilder: authRepositoryBuilder,
        onSessionExpired: onSessionExpired,
      ),
    );

    if (config.enableDioLogging) {
      dio.interceptors.add(PrettyDioLogger(requestBody: true));
    }

    return dio;
  }
}

/// Lazy accessor for the active [AuthRepository]. Defined in `core/network`
/// so that the dio layer can depend on it without dragging in
/// `data/auth`. Concrete implementations are wired by callers
/// (e.g. `bootstrap`) before [dioProvider] is first read.
///
/// Throws by default; tests and `bootstrap` should override with
/// `dioAuthRepositoryBuilderProvider.overrideWithValue(...)`.
typedef DioAuthRepositoryBuilder = Object Function();

/// Provider for the deferred auth-repository accessor consumed by
/// [dioProvider].
///
/// Implementations return whatever the interceptor needs (typically the
/// `AuthRepository` instance). The default throws so a misconfigured app
/// fails fast instead of silently skipping refresh.
@Riverpod(keepAlive: true)
DioAuthRepositoryBuilder dioAuthRepositoryBuilder(Ref ref) {
  throw UnimplementedError(
    'dioAuthRepositoryBuilderProvider must be overridden in ProviderScope.',
  );
}

/// Riverpod entry point for the configured Dio instance.
@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final flavor = ref.watch(flavorConfigProvider);
  final storage = ref.watch(secureStorageServiceProvider);
  final onSessionExpired = ref.watch(sessionExpiredSignalProvider);
  return DioClient.create(
    config: flavor,
    storage: storage,
    authRepositoryBuilder: ref.watch(dioAuthRepositoryBuilderProvider),
    onSessionExpired: onSessionExpired,
  );
}

/// Provider exposing a callback that the [AuthInterceptor] invokes when it
/// gives up on a token refresh. Default is a no-op so the dio can be used
/// without Riverpod wiring (e.g. tests).
@Riverpod(keepAlive: true)
void Function() sessionExpiredSignal(Ref ref) {
  return () {};
}

/// Riverpod entry point for the active [FlavorConfig].
///
/// Overridden at app startup with the value chosen by the entrypoint.
@Riverpod(keepAlive: true)
FlavorConfig flavorConfig(Ref ref) {
  throw UnimplementedError(
    'flavorConfigProvider must be overridden in ProviderScope.',
  );
}
