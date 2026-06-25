// Default entrypoint. Kept for `flutter test` and tooling that expects
// `lib/main.dart`. Real dev/staging/prod runs use `main_dev.dart`, etc.

import 'package:flutter_clean_riverpod_boilerplate/bootstrap.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/config/flavor.dart';

void main() {
  bootstrap(Flavor.dev);
}