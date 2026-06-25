import 'package:flutter_clean_riverpod_boilerplate/bootstrap.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/config/flavor.dart';

/// Dev entrypoint. Run with:
///   fvm flutter run --flavor dev -t lib/main_dev.dart
void main() {
  bootstrap(Flavor.dev);
}
