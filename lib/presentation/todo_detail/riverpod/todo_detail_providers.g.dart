// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_detail_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getTodoUseCaseHash() => r'd48b40014c032cac8adc893a9e449a9e76e0ebd5';

/// See also [getTodoUseCase].
@ProviderFor(getTodoUseCase)
final getTodoUseCaseProvider = Provider<GetTodoUseCase>.internal(
  getTodoUseCase,
  name: r'getTodoUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getTodoUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetTodoUseCaseRef = ProviderRef<GetTodoUseCase>;
String _$todoDetailControllerHash() =>
    r'a4e29f13aeed568d40b0098194a65da79c01a1a0';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$TodoDetailController
    extends BuildlessAutoDisposeAsyncNotifier<TodoDetailState> {
  late final String id;

  FutureOr<TodoDetailState> build(String id);
}

/// Loads a single todo by id for the detail route. Each route id gets an
/// isolated controller instance via the family parameter.
///
/// Copied from [TodoDetailController].
@ProviderFor(TodoDetailController)
const todoDetailControllerProvider = TodoDetailControllerFamily();

/// Loads a single todo by id for the detail route. Each route id gets an
/// isolated controller instance via the family parameter.
///
/// Copied from [TodoDetailController].
class TodoDetailControllerFamily extends Family<AsyncValue<TodoDetailState>> {
  /// Loads a single todo by id for the detail route. Each route id gets an
  /// isolated controller instance via the family parameter.
  ///
  /// Copied from [TodoDetailController].
  const TodoDetailControllerFamily();

  /// Loads a single todo by id for the detail route. Each route id gets an
  /// isolated controller instance via the family parameter.
  ///
  /// Copied from [TodoDetailController].
  TodoDetailControllerProvider call(String id) {
    return TodoDetailControllerProvider(id);
  }

  @override
  TodoDetailControllerProvider getProviderOverride(
    covariant TodoDetailControllerProvider provider,
  ) {
    return call(provider.id);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'todoDetailControllerProvider';
}

/// Loads a single todo by id for the detail route. Each route id gets an
/// isolated controller instance via the family parameter.
///
/// Copied from [TodoDetailController].
class TodoDetailControllerProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          TodoDetailController,
          TodoDetailState
        > {
  /// Loads a single todo by id for the detail route. Each route id gets an
  /// isolated controller instance via the family parameter.
  ///
  /// Copied from [TodoDetailController].
  TodoDetailControllerProvider(String id)
    : this._internal(
        () => TodoDetailController()..id = id,
        from: todoDetailControllerProvider,
        name: r'todoDetailControllerProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$todoDetailControllerHash,
        dependencies: TodoDetailControllerFamily._dependencies,
        allTransitiveDependencies:
            TodoDetailControllerFamily._allTransitiveDependencies,
        id: id,
      );

  TodoDetailControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  FutureOr<TodoDetailState> runNotifierBuild(
    covariant TodoDetailController notifier,
  ) {
    return notifier.build(id);
  }

  @override
  Override overrideWith(TodoDetailController Function() create) {
    return ProviderOverride(
      origin: this,
      override: TodoDetailControllerProvider._internal(
        () => create()..id = id,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<TodoDetailController, TodoDetailState>
  createElement() {
    return _TodoDetailControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TodoDetailControllerProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TodoDetailControllerRef
    on AutoDisposeAsyncNotifierProviderRef<TodoDetailState> {
  /// The parameter `id` of this provider.
  String get id;
}

class _TodoDetailControllerProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          TodoDetailController,
          TodoDetailState
        >
    with TodoDetailControllerRef {
  _TodoDetailControllerProviderElement(super.provider);

  @override
  String get id => (origin as TodoDetailControllerProvider).id;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
