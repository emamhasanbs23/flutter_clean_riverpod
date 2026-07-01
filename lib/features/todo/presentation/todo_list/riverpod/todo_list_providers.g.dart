// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_list_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Retrofit-generated `TodoApi` bound to the configured `Dio`. Shares the
/// Dio's interceptors (auth + logging) with the rest of the app.

@ProviderFor(todoApi)
final todoApiProvider = TodoApiProvider._();

/// Retrofit-generated `TodoApi` bound to the configured `Dio`. Shares the
/// Dio's interceptors (auth + logging) with the rest of the app.

final class TodoApiProvider
    extends $FunctionalProvider<TodoApi, TodoApi, TodoApi>
    with $Provider<TodoApi> {
  /// Retrofit-generated `TodoApi` bound to the configured `Dio`. Shares the
  /// Dio's interceptors (auth + logging) with the rest of the app.
  TodoApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todoApiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todoApiHash();

  @$internal
  @override
  $ProviderElement<TodoApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TodoApi create(Ref ref) {
    return todoApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TodoApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TodoApi>(value),
    );
  }
}

String _$todoApiHash() => r'1fdeb4cc519bd6c1dcca9a0755a92f46fe7826ec';

/// Dio-backed [TodoRemoteSource] driven by [todoApiProvider].

@ProviderFor(todoRemoteSource)
final todoRemoteSourceProvider = TodoRemoteSourceProvider._();

/// Dio-backed [TodoRemoteSource] driven by [todoApiProvider].

final class TodoRemoteSourceProvider
    extends
        $FunctionalProvider<
          TodoRemoteSource,
          TodoRemoteSource,
          TodoRemoteSource
        >
    with $Provider<TodoRemoteSource> {
  /// Dio-backed [TodoRemoteSource] driven by [todoApiProvider].
  TodoRemoteSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todoRemoteSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todoRemoteSourceHash();

  @$internal
  @override
  $ProviderElement<TodoRemoteSource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TodoRemoteSource create(Ref ref) {
    return todoRemoteSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TodoRemoteSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TodoRemoteSource>(value),
    );
  }
}

String _$todoRemoteSourceHash() => r'5eea68aa9e8ca94c350906de27fdd9266da8f278';

/// Default aggregate data source. Wires [TodoDataSourceImpl] to
/// [todoRemoteSourceProvider] so the full Clean Architecture data flow runs
/// end-to-end against a real HTTP API.
///
/// Tests and offline development override this provider with
/// [todoMockSourceProvider].

@ProviderFor(todoDataSource)
final todoDataSourceProvider = TodoDataSourceProvider._();

/// Default aggregate data source. Wires [TodoDataSourceImpl] to
/// [todoRemoteSourceProvider] so the full Clean Architecture data flow runs
/// end-to-end against a real HTTP API.
///
/// Tests and offline development override this provider with
/// [todoMockSourceProvider].

final class TodoDataSourceProvider
    extends $FunctionalProvider<TodoDataSource, TodoDataSource, TodoDataSource>
    with $Provider<TodoDataSource> {
  /// Default aggregate data source. Wires [TodoDataSourceImpl] to
  /// [todoRemoteSourceProvider] so the full Clean Architecture data flow runs
  /// end-to-end against a real HTTP API.
  ///
  /// Tests and offline development override this provider with
  /// [todoMockSourceProvider].
  TodoDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todoDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todoDataSourceHash();

  @$internal
  @override
  $ProviderElement<TodoDataSource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TodoDataSource create(Ref ref) {
    return todoDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TodoDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TodoDataSource>(value),
    );
  }
}

String _$todoDataSourceHash() => r'ac33e1424b4d13e4a5716ffc19afbe5230ad6832';

/// In-memory data source used by tests and as an offline fallback.

@ProviderFor(todoMockSource)
final todoMockSourceProvider = TodoMockSourceProvider._();

/// In-memory data source used by tests and as an offline fallback.

final class TodoMockSourceProvider
    extends $FunctionalProvider<TodoDataSource, TodoDataSource, TodoDataSource>
    with $Provider<TodoDataSource> {
  /// In-memory data source used by tests and as an offline fallback.
  TodoMockSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todoMockSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todoMockSourceHash();

  @$internal
  @override
  $ProviderElement<TodoDataSource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TodoDataSource create(Ref ref) {
    return todoMockSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TodoDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TodoDataSource>(value),
    );
  }
}

String _$todoMockSourceHash() => r'6e89ea0192c8a8c86f67178dce9568af0a42794d';

@ProviderFor(todoRepository)
final todoRepositoryProvider = TodoRepositoryProvider._();

final class TodoRepositoryProvider
    extends $FunctionalProvider<TodoRepository, TodoRepository, TodoRepository>
    with $Provider<TodoRepository> {
  TodoRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todoRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todoRepositoryHash();

  @$internal
  @override
  $ProviderElement<TodoRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TodoRepository create(Ref ref) {
    return todoRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TodoRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TodoRepository>(value),
    );
  }
}

String _$todoRepositoryHash() => r'13e71c261f2315909607336d5afc5750648fd29c';

@ProviderFor(getTodosUseCase)
final getTodosUseCaseProvider = GetTodosUseCaseProvider._();

final class GetTodosUseCaseProvider
    extends
        $FunctionalProvider<GetTodosUseCase, GetTodosUseCase, GetTodosUseCase>
    with $Provider<GetTodosUseCase> {
  GetTodosUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getTodosUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getTodosUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetTodosUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetTodosUseCase create(Ref ref) {
    return getTodosUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetTodosUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetTodosUseCase>(value),
    );
  }
}

String _$getTodosUseCaseHash() => r'7f0bf141e1a794104d0648bc552cae027e685372';

@ProviderFor(createTodoUseCase)
final createTodoUseCaseProvider = CreateTodoUseCaseProvider._();

final class CreateTodoUseCaseProvider
    extends
        $FunctionalProvider<
          CreateTodoUseCase,
          CreateTodoUseCase,
          CreateTodoUseCase
        >
    with $Provider<CreateTodoUseCase> {
  CreateTodoUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createTodoUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createTodoUseCaseHash();

  @$internal
  @override
  $ProviderElement<CreateTodoUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CreateTodoUseCase create(Ref ref) {
    return createTodoUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CreateTodoUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CreateTodoUseCase>(value),
    );
  }
}

String _$createTodoUseCaseHash() => r'e402cf8cddf65ab014b035d8d3815f9fa5b6a604';

@ProviderFor(toggleTodoUseCase)
final toggleTodoUseCaseProvider = ToggleTodoUseCaseProvider._();

final class ToggleTodoUseCaseProvider
    extends
        $FunctionalProvider<
          ToggleTodoUseCase,
          ToggleTodoUseCase,
          ToggleTodoUseCase
        >
    with $Provider<ToggleTodoUseCase> {
  ToggleTodoUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'toggleTodoUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$toggleTodoUseCaseHash();

  @$internal
  @override
  $ProviderElement<ToggleTodoUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ToggleTodoUseCase create(Ref ref) {
    return toggleTodoUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ToggleTodoUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ToggleTodoUseCase>(value),
    );
  }
}

String _$toggleTodoUseCaseHash() => r'e02c96ea7eb24adbb0da22c747130dcb8870afd2';

@ProviderFor(deleteTodoUseCase)
final deleteTodoUseCaseProvider = DeleteTodoUseCaseProvider._();

final class DeleteTodoUseCaseProvider
    extends
        $FunctionalProvider<
          DeleteTodoUseCase,
          DeleteTodoUseCase,
          DeleteTodoUseCase
        >
    with $Provider<DeleteTodoUseCase> {
  DeleteTodoUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deleteTodoUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deleteTodoUseCaseHash();

  @$internal
  @override
  $ProviderElement<DeleteTodoUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DeleteTodoUseCase create(Ref ref) {
    return deleteTodoUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeleteTodoUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeleteTodoUseCase>(value),
    );
  }
}

String _$deleteTodoUseCaseHash() => r'3eeb4000b8f237ec5d26677f9b2d00aed7fa7519';

/// Manages the list state and exposes mutating methods. Mutations
/// optimistically re-fetch to keep the data source authoritative, which also
/// keeps the implementation simple at the cost of an extra round-trip.

@ProviderFor(TodoListController)
final todoListControllerProvider = TodoListControllerProvider._();

/// Manages the list state and exposes mutating methods. Mutations
/// optimistically re-fetch to keep the data source authoritative, which also
/// keeps the implementation simple at the cost of an extra round-trip.
final class TodoListControllerProvider
    extends $AsyncNotifierProvider<TodoListController, TodoListState> {
  /// Manages the list state and exposes mutating methods. Mutations
  /// optimistically re-fetch to keep the data source authoritative, which also
  /// keeps the implementation simple at the cost of an extra round-trip.
  TodoListControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todoListControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todoListControllerHash();

  @$internal
  @override
  TodoListController create() => TodoListController();
}

String _$todoListControllerHash() =>
    r'176dbfb9a2df1fa7bcd472805603a09dd321a737';

/// Manages the list state and exposes mutating methods. Mutations
/// optimistically re-fetch to keep the data source authoritative, which also
/// keeps the implementation simple at the cost of an extra round-trip.

abstract class _$TodoListController extends $AsyncNotifier<TodoListState> {
  FutureOr<TodoListState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<TodoListState>, TodoListState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<TodoListState>, TodoListState>,
              AsyncValue<TodoListState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
