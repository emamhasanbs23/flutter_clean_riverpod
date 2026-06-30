import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Cancels in-flight Dio requests when the hosting provider is disposed.
///
/// Call [initCancelToken] once at the start of [AsyncNotifier.build].
abstract mixin class CancelableControllerMixin {
  CancelToken? _cancelToken;

  /// Dio cancel token scoped to the current provider lifecycle.
  CancelToken get cancelToken {
    assert(
      _cancelToken != null,
      'Call initCancelToken(ref) at the start of build()',
    );
    return _cancelToken!;
  }

  bool get isCancelled => _cancelToken?.isCancelled ?? false;

  /// Registers a [CancelToken] that is cancelled when [ref] is disposed.
  void initCancelToken(Ref ref) {
    _cancelToken = CancelToken();
    ref.onDispose(_cancelToken!.cancel);
  }
}

/// Shared [refreshWith] helper for async Riverpod controllers.
///
/// Mixed into generated `AsyncNotifier` subclasses that expose sealed UI
/// state via [AsyncValue.data].
abstract mixin class RefreshableAsyncControllerMixin<T> {
  AsyncValue<T> get state;
  set state(AsyncValue<T> value);

  /// Sets an optional [loadingState], then re-runs [load] inside
  /// [AsyncValue.guard].
  Future<void> refreshWith({
    required Future<T> Function() load,
    T? loadingState,
  }) async {
    if (loadingState != null) {
      state = AsyncValue.data(loadingState);
    }
    state = await AsyncValue.guard(load);
  }
}
