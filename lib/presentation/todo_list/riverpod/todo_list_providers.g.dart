// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_list_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$todoApiHash() => r'1fdeb4cc519bd6c1dcca9a0755a92f46fe7826ec';

/// Retrofit-generated `TodoApi` bound to the configured `Dio`. Shares the
/// Dio's interceptors (auth + logging) with the rest of the app.
///
/// Copied from [todoApi].
@ProviderFor(todoApi)
final todoApiProvider = Provider<TodoApi>.internal(
  todoApi,
  name: r'todoApiProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$todoApiHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TodoApiRef = ProviderRef<TodoApi>;
String _$todoRemoteSourceHash() => r'5eea68aa9e8ca94c350906de27fdd9266da8f278';

/// Dio-backed [TodoRemoteSource] driven by [todoApiProvider].
///
/// Copied from [todoRemoteSource].
@ProviderFor(todoRemoteSource)
final todoRemoteSourceProvider = Provider<TodoRemoteSource>.internal(
  todoRemoteSource,
  name: r'todoRemoteSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$todoRemoteSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TodoRemoteSourceRef = ProviderRef<TodoRemoteSource>;
String _$todoDataSourceHash() => r'ac33e1424b4d13e4a5716ffc19afbe5230ad6832';

/// Default aggregate data source. Wires [TodoDataSourceImpl] to
/// [todoRemoteSourceProvider] so the full Clean Architecture data flow runs
/// end-to-end against a real HTTP API.
///
/// Tests and offline development override this provider with
/// [todoMockSourceProvider].
///
/// Copied from [todoDataSource].
@ProviderFor(todoDataSource)
final todoDataSourceProvider = Provider<TodoDataSource>.internal(
  todoDataSource,
  name: r'todoDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$todoDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TodoDataSourceRef = ProviderRef<TodoDataSource>;
String _$todoMockSourceHash() => r'6e89ea0192c8a8c86f67178dce9568af0a42794d';

/// In-memory data source used by tests and as an offline fallback.
///
/// Copied from [todoMockSource].
@ProviderFor(todoMockSource)
final todoMockSourceProvider = Provider<TodoDataSource>.internal(
  todoMockSource,
  name: r'todoMockSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$todoMockSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TodoMockSourceRef = ProviderRef<TodoDataSource>;
String _$todoRepositoryHash() => r'13e71c261f2315909607336d5afc5750648fd29c';

/// See also [todoRepository].
@ProviderFor(todoRepository)
final todoRepositoryProvider = Provider<TodoRepository>.internal(
  todoRepository,
  name: r'todoRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$todoRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TodoRepositoryRef = ProviderRef<TodoRepository>;
String _$getTodosUseCaseHash() => r'7f0bf141e1a794104d0648bc552cae027e685372';

/// See also [getTodosUseCase].
@ProviderFor(getTodosUseCase)
final getTodosUseCaseProvider = Provider<GetTodosUseCase>.internal(
  getTodosUseCase,
  name: r'getTodosUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getTodosUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetTodosUseCaseRef = ProviderRef<GetTodosUseCase>;
String _$createTodoUseCaseHash() => r'e402cf8cddf65ab014b035d8d3815f9fa5b6a604';

/// See also [createTodoUseCase].
@ProviderFor(createTodoUseCase)
final createTodoUseCaseProvider = Provider<CreateTodoUseCase>.internal(
  createTodoUseCase,
  name: r'createTodoUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$createTodoUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CreateTodoUseCaseRef = ProviderRef<CreateTodoUseCase>;
String _$toggleTodoUseCaseHash() => r'e02c96ea7eb24adbb0da22c747130dcb8870afd2';

/// See also [toggleTodoUseCase].
@ProviderFor(toggleTodoUseCase)
final toggleTodoUseCaseProvider = Provider<ToggleTodoUseCase>.internal(
  toggleTodoUseCase,
  name: r'toggleTodoUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$toggleTodoUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ToggleTodoUseCaseRef = ProviderRef<ToggleTodoUseCase>;
String _$deleteTodoUseCaseHash() => r'3eeb4000b8f237ec5d26677f9b2d00aed7fa7519';

/// See also [deleteTodoUseCase].
@ProviderFor(deleteTodoUseCase)
final deleteTodoUseCaseProvider = Provider<DeleteTodoUseCase>.internal(
  deleteTodoUseCase,
  name: r'deleteTodoUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$deleteTodoUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DeleteTodoUseCaseRef = ProviderRef<DeleteTodoUseCase>;
String _$todoListControllerHash() =>
    r'428bdd1da76ca33fbb4b4e47f94fed06a205fb62';

/// Manages the list state and exposes mutating methods. Mutations
/// optimistically re-fetch to keep the data source authoritative, which also
/// keeps the implementation simple at the cost of an extra round-trip.
///
/// Copied from [TodoListController].
@ProviderFor(TodoListController)
final todoListControllerProvider =
    AsyncNotifierProvider<TodoListController, TodoListState>.internal(
      TodoListController.new,
      name: r'todoListControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$todoListControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$TodoListController = AsyncNotifier<TodoListState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
