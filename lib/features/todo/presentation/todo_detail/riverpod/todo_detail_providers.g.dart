// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_detail_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(getTodoUseCase)
final getTodoUseCaseProvider = GetTodoUseCaseProvider._();

final class GetTodoUseCaseProvider
    extends $FunctionalProvider<GetTodoUseCase, GetTodoUseCase, GetTodoUseCase>
    with $Provider<GetTodoUseCase> {
  GetTodoUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getTodoUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getTodoUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetTodoUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetTodoUseCase create(Ref ref) {
    return getTodoUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetTodoUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetTodoUseCase>(value),
    );
  }
}

String _$getTodoUseCaseHash() => r'd48b40014c032cac8adc893a9e449a9e76e0ebd5';

/// Loads a single todo by id for the detail route. Each route id gets an
/// isolated controller instance via the family parameter.

@ProviderFor(TodoDetailController)
final todoDetailControllerProvider = TodoDetailControllerFamily._();

/// Loads a single todo by id for the detail route. Each route id gets an
/// isolated controller instance via the family parameter.
final class TodoDetailControllerProvider
    extends $AsyncNotifierProvider<TodoDetailController, TodoDetailState> {
  /// Loads a single todo by id for the detail route. Each route id gets an
  /// isolated controller instance via the family parameter.
  TodoDetailControllerProvider._({
    required TodoDetailControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'todoDetailControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$todoDetailControllerHash();

  @override
  String toString() {
    return r'todoDetailControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  TodoDetailController create() => TodoDetailController();

  @override
  bool operator ==(Object other) {
    return other is TodoDetailControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$todoDetailControllerHash() =>
    r'd652e3189466ffa908e4e6e2cfa14d729b5ba35c';

/// Loads a single todo by id for the detail route. Each route id gets an
/// isolated controller instance via the family parameter.

final class TodoDetailControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          TodoDetailController,
          AsyncValue<TodoDetailState>,
          TodoDetailState,
          FutureOr<TodoDetailState>,
          String
        > {
  TodoDetailControllerFamily._()
    : super(
        retry: null,
        name: r'todoDetailControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Loads a single todo by id for the detail route. Each route id gets an
  /// isolated controller instance via the family parameter.

  TodoDetailControllerProvider call(String id) =>
      TodoDetailControllerProvider._(argument: id, from: this);

  @override
  String toString() => r'todoDetailControllerProvider';
}

/// Loads a single todo by id for the detail route. Each route id gets an
/// isolated controller instance via the family parameter.

abstract class _$TodoDetailController extends $AsyncNotifier<TodoDetailState> {
  late final _$args = ref.$arg as String;
  String get id => _$args;

  FutureOr<TodoDetailState> build(String id);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<TodoDetailState>, TodoDetailState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<TodoDetailState>, TodoDetailState>,
              AsyncValue<TodoDetailState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
