// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authApiHash() => r'fe97432bc17461ebde4a232f1f399cd20c5aa5e4';

/// Retrofit-generated `AuthApi` bound to the configured `Dio`.
///
/// Shares the same Dio instance (and therefore the same
/// [AuthInterceptor]) with the rest of the app, so the 401 -> dedup ->
/// refresh -> retry funnel keeps working unchanged.
///
/// Copied from [authApi].
@ProviderFor(authApi)
final authApiProvider = Provider<AuthApi>.internal(
  authApi,
  name: r'authApiProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authApiHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthApiRef = ProviderRef<AuthApi>;
String _$authRemoteSourceHash() => r'38d71db3eac60c41a044aaaf501390e6b700a099';

/// Dio-backed [AuthRemoteSource] driven by [authApiProvider].
///
/// Tests can override this provider with a fake implementation.
///
/// Copied from [authRemoteSource].
@ProviderFor(authRemoteSource)
final authRemoteSourceProvider = Provider<AuthRemoteSource>.internal(
  authRemoteSource,
  name: r'authRemoteSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authRemoteSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthRemoteSourceRef = ProviderRef<AuthRemoteSource>;
String _$authDataSourceHash() => r'901954b2767acd5dcc1475865b6e5904ef61db91';

/// Aggregate auth data source — facade over [authRemoteSourceProvider].
///
/// Copied from [authDataSource].
@ProviderFor(authDataSource)
final authDataSourceProvider = Provider<AuthDataSource>.internal(
  authDataSource,
  name: r'authDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthDataSourceRef = ProviderRef<AuthDataSource>;
String _$authRepositoryHash() => r'9f9acb499bfe3571831f47b6b5554f7bcd31a42a';

/// Singleton repository bound to the active storage implementation.
///
/// Copied from [authRepository].
@ProviderFor(authRepository)
final authRepositoryProvider = Provider<AuthRepository>.internal(
  authRepository,
  name: r'authRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthRepositoryRef = ProviderRef<AuthRepository>;
String _$loginUseCaseHash() => r'24ad3f2ba64f0eabe574926ed647b61cd5651291';

/// Domain-layer use case wrapping the repository's login.
///
/// Copied from [loginUseCase].
@ProviderFor(loginUseCase)
final loginUseCaseProvider = Provider<LoginUseCase>.internal(
  loginUseCase,
  name: r'loginUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$loginUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LoginUseCaseRef = ProviderRef<LoginUseCase>;
String _$getCurrentUserUseCaseHash() =>
    r'5cd5426118c793aa603d1d80a0567f9ed1313557';

/// Reads the persisted user from secure storage. Returns `null` when no user
/// is logged in. Invalidated whenever [logoutControllerProvider] runs.
///
/// Copied from [getCurrentUserUseCase].
@ProviderFor(getCurrentUserUseCase)
final getCurrentUserUseCaseProvider = Provider<GetCurrentUserUseCase>.internal(
  getCurrentUserUseCase,
  name: r'getCurrentUserUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getCurrentUserUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetCurrentUserUseCaseRef = ProviderRef<GetCurrentUserUseCase>;
String _$logoutUseCaseHash() => r'9caaf0cb8d2a39bd5b99e8fae9e36c716e1fd83a';

/// Domain-layer use case wrapping the repository's logout.
///
/// Copied from [logoutUseCase].
@ProviderFor(logoutUseCase)
final logoutUseCaseProvider = Provider<LogoutUseCase>.internal(
  logoutUseCase,
  name: r'logoutUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$logoutUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LogoutUseCaseRef = ProviderRef<LogoutUseCase>;
String _$currentUserHash() => r'fa244603a7d92aef91ded8a57b73a28d3f078e57';

/// Async snapshot of the currently logged-in user. `null` inside the data
/// means "no user" (logged-out) — `AsyncValue.error` means the storage read
/// itself failed.
///
/// Copied from [currentUser].
@ProviderFor(currentUser)
final currentUserProvider = FutureProvider<AuthUser?>.internal(
  currentUser,
  name: r'currentUserProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentUserHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentUserRef = FutureProviderRef<AuthUser?>;
String _$isAuthenticatedHash() => r'81ccbcf1d92ea9f131ede4ce1680fb65062c3d21';

/// Synchronous view of whether the user is authenticated.
///
/// The router reads this provider on every redirect, so we keep it cheap:
/// a single secure storage read at construction time, then it stays in
/// memory for the lifetime of the provider.
///
/// Copied from [isAuthenticated].
@ProviderFor(isAuthenticated)
final isAuthenticatedProvider = FutureProvider<bool>.internal(
  isAuthenticated,
  name: r'isAuthenticatedProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isAuthenticatedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsAuthenticatedRef = FutureProviderRef<bool>;
String _$logoutControllerHash() => r'31ef253825043153af3f7505ff5e6a13c5e9bce8';

/// Triggers a logout and refreshes the auth provider so the router redirects
/// back to the login screen.
///
/// Copied from [logoutController].
@ProviderFor(logoutController)
final logoutControllerProvider = Provider<Future<void> Function()>.internal(
  logoutController,
  name: r'logoutControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$logoutControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LogoutControllerRef = ProviderRef<Future<void> Function()>;
String _$sessionExpiredHash() => r'946fa6deb10a32ffadd3d4fd17160e34b7a78ed0';

/// Broadcast stream of "session expired" events.
///
/// Emitted by the auth layer (e.g. when the [AuthInterceptor] exhausts its
/// refresh retry) so the router can react: invalidate
/// [isAuthenticatedProvider] and the redirect will fire on the next
/// navigation.
///
/// Copied from [SessionExpired].
@ProviderFor(SessionExpired)
final sessionExpiredProvider = NotifierProvider<SessionExpired, bool>.internal(
  SessionExpired.new,
  name: r'sessionExpiredProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sessionExpiredHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SessionExpired = Notifier<bool>;
String _$loginControllerHash() => r'9056fb8e390ca62c6e18543a73f009db8830cb65';

/// Holds the current submission state plus simple form controllers.
///
/// Copied from [LoginController].
@ProviderFor(LoginController)
final loginControllerProvider =
    NotifierProvider<LoginController, LoginState>.internal(
      LoginController.new,
      name: r'loginControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$loginControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$LoginController = Notifier<LoginState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
