// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Broadcast stream of "session expired" events.
///
/// Emitted by the auth layer (e.g. when the [AuthInterceptor] exhausts its
/// refresh retry) so the router can react: invalidate
/// [isAuthenticatedProvider] and the redirect will fire on the next
/// navigation.

@ProviderFor(SessionExpired)
final sessionExpiredProvider = SessionExpiredProvider._();

/// Broadcast stream of "session expired" events.
///
/// Emitted by the auth layer (e.g. when the [AuthInterceptor] exhausts its
/// refresh retry) so the router can react: invalidate
/// [isAuthenticatedProvider] and the redirect will fire on the next
/// navigation.
final class SessionExpiredProvider
    extends $NotifierProvider<SessionExpired, bool> {
  /// Broadcast stream of "session expired" events.
  ///
  /// Emitted by the auth layer (e.g. when the [AuthInterceptor] exhausts its
  /// refresh retry) so the router can react: invalidate
  /// [isAuthenticatedProvider] and the redirect will fire on the next
  /// navigation.
  SessionExpiredProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionExpiredProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionExpiredHash();

  @$internal
  @override
  SessionExpired create() => SessionExpired();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$sessionExpiredHash() => r'946fa6deb10a32ffadd3d4fd17160e34b7a78ed0';

/// Broadcast stream of "session expired" events.
///
/// Emitted by the auth layer (e.g. when the [AuthInterceptor] exhausts its
/// refresh retry) so the router can react: invalidate
/// [isAuthenticatedProvider] and the redirect will fire on the next
/// navigation.

abstract class _$SessionExpired extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Retrofit-generated `AuthApi` bound to the configured `Dio`.
///
/// Shares the same Dio instance (and therefore the same
/// [AuthInterceptor]) with the rest of the app, so the 401 -> dedup ->
/// refresh -> retry funnel keeps working unchanged.

@ProviderFor(authApi)
final authApiProvider = AuthApiProvider._();

/// Retrofit-generated `AuthApi` bound to the configured `Dio`.
///
/// Shares the same Dio instance (and therefore the same
/// [AuthInterceptor]) with the rest of the app, so the 401 -> dedup ->
/// refresh -> retry funnel keeps working unchanged.

final class AuthApiProvider
    extends $FunctionalProvider<AuthApi, AuthApi, AuthApi>
    with $Provider<AuthApi> {
  /// Retrofit-generated `AuthApi` bound to the configured `Dio`.
  ///
  /// Shares the same Dio instance (and therefore the same
  /// [AuthInterceptor]) with the rest of the app, so the 401 -> dedup ->
  /// refresh -> retry funnel keeps working unchanged.
  AuthApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authApiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authApiHash();

  @$internal
  @override
  $ProviderElement<AuthApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthApi create(Ref ref) {
    return authApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthApi>(value),
    );
  }
}

String _$authApiHash() => r'fe97432bc17461ebde4a232f1f399cd20c5aa5e4';

/// Dio-backed [AuthRemoteDataSource] driven by [authApiProvider].
///
/// Tests can override this provider with a fake implementation.

@ProviderFor(authRemoteDataSource)
final authRemoteDataSourceProvider = AuthRemoteDataSourceProvider._();

/// Dio-backed [AuthRemoteDataSource] driven by [authApiProvider].
///
/// Tests can override this provider with a fake implementation.

final class AuthRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          AuthRemoteDataSource,
          AuthRemoteDataSource,
          AuthRemoteDataSource
        >
    with $Provider<AuthRemoteDataSource> {
  /// Dio-backed [AuthRemoteDataSource] driven by [authApiProvider].
  ///
  /// Tests can override this provider with a fake implementation.
  AuthRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authRemoteDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<AuthRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AuthRemoteDataSource create(Ref ref) {
    return authRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthRemoteDataSource>(value),
    );
  }
}

String _$authRemoteDataSourceHash() =>
    r'08908677f752fe5d6953f18f935c6de558ffdf24';

/// Singleton repository bound to the active storage implementation.

@ProviderFor(authRepository)
final authRepositoryProvider = AuthRepositoryProvider._();

/// Singleton repository bound to the active storage implementation.

final class AuthRepositoryProvider
    extends $FunctionalProvider<AuthRepository, AuthRepository, AuthRepository>
    with $Provider<AuthRepository> {
  /// Singleton repository bound to the active storage implementation.
  AuthRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authRepositoryHash();

  @$internal
  @override
  $ProviderElement<AuthRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthRepository create(Ref ref) {
    return authRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthRepository>(value),
    );
  }
}

String _$authRepositoryHash() => r'd0288d4114cfa1654735dbd917a95cb8a563c0f8';

/// Domain-layer use case wrapping the repository's login.

@ProviderFor(loginUseCase)
final loginUseCaseProvider = LoginUseCaseProvider._();

/// Domain-layer use case wrapping the repository's login.

final class LoginUseCaseProvider
    extends $FunctionalProvider<LoginUseCase, LoginUseCase, LoginUseCase>
    with $Provider<LoginUseCase> {
  /// Domain-layer use case wrapping the repository's login.
  LoginUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loginUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loginUseCaseHash();

  @$internal
  @override
  $ProviderElement<LoginUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LoginUseCase create(Ref ref) {
    return loginUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LoginUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LoginUseCase>(value),
    );
  }
}

String _$loginUseCaseHash() => r'24ad3f2ba64f0eabe574926ed647b61cd5651291';

/// Reads the persisted user from secure storage. Returns `null` when no user
/// is logged in. Invalidated whenever [logoutControllerProvider] runs.

@ProviderFor(getCurrentUserUseCase)
final getCurrentUserUseCaseProvider = GetCurrentUserUseCaseProvider._();

/// Reads the persisted user from secure storage. Returns `null` when no user
/// is logged in. Invalidated whenever [logoutControllerProvider] runs.

final class GetCurrentUserUseCaseProvider
    extends
        $FunctionalProvider<
          GetCurrentUserUseCase,
          GetCurrentUserUseCase,
          GetCurrentUserUseCase
        >
    with $Provider<GetCurrentUserUseCase> {
  /// Reads the persisted user from secure storage. Returns `null` when no user
  /// is logged in. Invalidated whenever [logoutControllerProvider] runs.
  GetCurrentUserUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getCurrentUserUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getCurrentUserUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetCurrentUserUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetCurrentUserUseCase create(Ref ref) {
    return getCurrentUserUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetCurrentUserUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetCurrentUserUseCase>(value),
    );
  }
}

String _$getCurrentUserUseCaseHash() =>
    r'5cd5426118c793aa603d1d80a0567f9ed1313557';

/// Domain-layer use case wrapping the repository's logout.

@ProviderFor(logoutUseCase)
final logoutUseCaseProvider = LogoutUseCaseProvider._();

/// Domain-layer use case wrapping the repository's logout.

final class LogoutUseCaseProvider
    extends $FunctionalProvider<LogoutUseCase, LogoutUseCase, LogoutUseCase>
    with $Provider<LogoutUseCase> {
  /// Domain-layer use case wrapping the repository's logout.
  LogoutUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'logoutUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$logoutUseCaseHash();

  @$internal
  @override
  $ProviderElement<LogoutUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LogoutUseCase create(Ref ref) {
    return logoutUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LogoutUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LogoutUseCase>(value),
    );
  }
}

String _$logoutUseCaseHash() => r'9caaf0cb8d2a39bd5b99e8fae9e36c716e1fd83a';

/// Async snapshot of the currently logged-in user. `null` inside the data
/// means "no user" (logged-out) — `AsyncValue.error` means the storage read
/// itself failed.

@ProviderFor(currentUser)
final currentUserProvider = CurrentUserProvider._();

/// Async snapshot of the currently logged-in user. `null` inside the data
/// means "no user" (logged-out) — `AsyncValue.error` means the storage read
/// itself failed.

final class CurrentUserProvider
    extends
        $FunctionalProvider<
          AsyncValue<AuthUser?>,
          AuthUser?,
          FutureOr<AuthUser?>
        >
    with $FutureModifier<AuthUser?>, $FutureProvider<AuthUser?> {
  /// Async snapshot of the currently logged-in user. `null` inside the data
  /// means "no user" (logged-out) — `AsyncValue.error` means the storage read
  /// itself failed.
  CurrentUserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentUserProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentUserHash();

  @$internal
  @override
  $FutureProviderElement<AuthUser?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<AuthUser?> create(Ref ref) {
    return currentUser(ref);
  }
}

String _$currentUserHash() => r'fa244603a7d92aef91ded8a57b73a28d3f078e57';

/// Synchronous view of whether the user is authenticated.
///
/// The router reads this provider on every redirect, so we keep it cheap:
/// a single secure storage read at construction time, then it stays in
/// memory for the lifetime of the provider.

@ProviderFor(isAuthenticated)
final isAuthenticatedProvider = IsAuthenticatedProvider._();

/// Synchronous view of whether the user is authenticated.
///
/// The router reads this provider on every redirect, so we keep it cheap:
/// a single secure storage read at construction time, then it stays in
/// memory for the lifetime of the provider.

final class IsAuthenticatedProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Synchronous view of whether the user is authenticated.
  ///
  /// The router reads this provider on every redirect, so we keep it cheap:
  /// a single secure storage read at construction time, then it stays in
  /// memory for the lifetime of the provider.
  IsAuthenticatedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isAuthenticatedProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isAuthenticatedHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return isAuthenticated(ref);
  }
}

String _$isAuthenticatedHash() => r'81ccbcf1d92ea9f131ede4ce1680fb65062c3d21';

/// Holds the current submission state plus simple form controllers.

@ProviderFor(LoginController)
final loginControllerProvider = LoginControllerProvider._();

/// Holds the current submission state plus simple form controllers.
final class LoginControllerProvider
    extends $NotifierProvider<LoginController, LoginState> {
  /// Holds the current submission state plus simple form controllers.
  LoginControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loginControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loginControllerHash();

  @$internal
  @override
  LoginController create() => LoginController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LoginState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LoginState>(value),
    );
  }
}

String _$loginControllerHash() => r'9056fb8e390ca62c6e18543a73f009db8830cb65';

/// Holds the current submission state plus simple form controllers.

abstract class _$LoginController extends $Notifier<LoginState> {
  LoginState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<LoginState, LoginState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LoginState, LoginState>,
              LoginState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Triggers a logout and refreshes the auth provider so the router redirects
/// back to the login screen.

@ProviderFor(logoutController)
final logoutControllerProvider = LogoutControllerProvider._();

/// Triggers a logout and refreshes the auth provider so the router redirects
/// back to the login screen.

final class LogoutControllerProvider
    extends
        $FunctionalProvider<
          Future<void> Function(),
          Future<void> Function(),
          Future<void> Function()
        >
    with $Provider<Future<void> Function()> {
  /// Triggers a logout and refreshes the auth provider so the router redirects
  /// back to the login screen.
  LogoutControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'logoutControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$logoutControllerHash();

  @$internal
  @override
  $ProviderElement<Future<void> Function()> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Future<void> Function() create(Ref ref) {
    return logoutController(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Future<void> Function() value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Future<void> Function()>(value),
    );
  }
}

String _$logoutControllerHash() => r'31ef253825043153af3f7505ff5e6a13c5e9bce8';
