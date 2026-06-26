# State Management (Riverpod)

> `@riverpod` codegen via `riverpod_generator`. Part of the
> [AGENTS.md](../../AGENTS.md) index.

## Why codegen

Prefer `riverpod_generator` for provider declarations — less boilerplate,
compile-time safety, and generated providers remain easy to override in tests
via `ProviderScope.overrides`.

UI **states** stay hand-written `sealed class` hierarchies (not `freezed`).

## Provider declarations

Annotate providers in `<feature>_providers.dart` (or split by concern within
the feature). Run `build_runner` after edits:

```bash
fvm dart run build_runner build --delete-conflicting-outputs
```

Export only the symbols that other features may consume. Use `part`
`'<feature>_providers.g.dart';` as required by the generator.

### Repository provider (typical)

```dart
@Riverpod(keepAlive: true)
FeatureRepository featureRepository(Ref ref) {
  throw UnimplementedError(); // overridden in bootstrap.dart or tests
}
```

### Controller provider (Notifier)

```dart
@riverpod
class FeatureController extends _$FeatureController {
  @override
  FeatureState build() => const FeatureInitial();

  // ...
}
```

## Sealed UI states

Every screen has a `sealed class` state. Widgets render via exhaustive `switch`:

```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  final state = ref.watch(featureControllerProvider);
  return switch (state) {
    FeatureInitial()   => const InitialView(),
    FeatureLoading()   => const LoadingView(),
    FeatureLoaded(d)   => LoadedView(data: d),
    FeatureError(f)    => ErrorView(failure: f),
  };
}
```

Adding a state = adding a sealed subclass + a switch arm (compile-time enforced).

## Cross-feature access

A feature may **only** access another feature through its providers file:

```dart
// in presentation/orders/riverpod/orders_providers.dart
import 'package:flutter_clean_riverpod_boilerplate/presentation/auth/riverpod/auth_providers.dart';

@riverpod
class OrdersController extends _$OrdersController {
  @override
  OrdersState build() {
    ref.watch(authStateProvider);
    return const OrdersInitial();
  }
}
```

Do **not** import `presentation/auth/` directly — go through
`auth_providers.dart`.

## Test overrides

```dart
await tester.pumpWidget(
  ProviderScope(
    overrides: [
      featureRepositoryProvider.overrideWithValue(mockRepo),
    ],
    child: const MyApp(),
  ),
);
```

## Rules

- Use `@riverpod` / `@Riverpod` for new providers; avoid hand-written
  `Provider` / `NotifierProvider` unless codegen cannot express the case.
- New provider → add to `<feature>_providers.dart` and regenerate.
- Don't import a feature's `presentation/` from another feature.

## Related

- [error-handling.md](./error-handling.md) — `Either<Failure, T>` flows through providers.
- [testing.md](./testing.md) — override patterns.
- [../../AGENTS.md](../../AGENTS.md) — index.
