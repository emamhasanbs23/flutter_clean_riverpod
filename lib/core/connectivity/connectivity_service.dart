import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connectivity_service.g.dart';

/// Reactive wrapper around [Connectivity].
///
/// Exposes a [Stream] of online/offline changes and a synchronous check for
/// the current state. UI listens via [connectivityStreamProvider] while
/// non-UI code can `read` it directly.
class ConnectivityService {
  ConnectivityService({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  Stream<bool> get onStatusChange =>
      _connectivity.onConnectivityChanged.map(_isOnline);

  Future<bool> isConnected() async {
    final results = await _connectivity.checkConnectivity();
    return _isOnline(results);
  }

  bool _isOnline(List<ConnectivityResult> results) {
    // Empty list = no active interface; treat as offline.
    return results.any((r) => r != ConnectivityResult.none);
  }
}

@Riverpod(keepAlive: true)
ConnectivityService connectivityService(Ref ref) {
  return ConnectivityService();
}

/// Live connectivity status. `null` until the first event arrives.
@Riverpod(keepAlive: true)
Stream<bool> connectivityStream(Ref ref) {
  final service = ref.watch(connectivityServiceProvider);
  return service.onStatusChange;
}
