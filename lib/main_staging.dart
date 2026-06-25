import 'package:flutter_clean_riverpod_boilerplate/bootstrap.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/config/flavor.dart';

/// Staging entrypoint. Run with:
///   fvm flutter run --flavor staging -t lib/main_staging.dart
void main() {
  bootstrap(Flavor.staging);
}
