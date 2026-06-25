import 'package:flutter_clean_riverpod_boilerplate/bootstrap.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/config/flavor.dart';

/// Production entrypoint. Run with:
///   fvm flutter run --flavor prod -t lib/main_prod.dart
void main() {
  bootstrap(Flavor.prod);
}
