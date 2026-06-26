# State Management (Riverpod)

> Hand-written Riverpod. **No** `riverpod_generator` / `@riverpod` annotations.
> Part of the [AGENTS.md](../../AGENTS.md) index.

## Why hand-written

The project deliberately avoids code generation for providers — providers are explicit declarations, easy to grep, and play well with `mocktail` overrides in tests.

## Provider declarations

All providers for a feature live in a single file:

```
features/<feature>/<feature>_providers.dart
```

Export only the symbols that other features may consume. Keep internal providers private.

### Repository provider (typical)

```dart
final repositoryProvider = Provider<FeatureRepository>((ref) {
  throw UnimplementedError(); // overridden in bootstrap.dart or tests
});
```

### Controller provider (Notifier)

```dart
final featureControllerProvider =
    NotifierProvider<FeatureController, FeatureState>(FeatureController.new);
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
// in features/orders/orders_providers.dart
import '../auth/auth_providers.dart';

final ordersControllerProvider = NotifierProvider<OrdersController, OrdersState>((ref) {
  return OrdersController(ref.watch(authStateProvider));
});
```

Do **not** import `features/auth/presentation/` directly — go through `auth_providers.dart`.

## Test overrides

```dart
await tester.pumpWidget(
  ProviderScope(
    overrides: [
      repositoryProvider.overrideWithValue(mockRepo),
    ],
    child: const MyApp(),
  ),
);
```

## Rules

- No `@riverpod` codegen.
- New provider → new declaration in `<feature>_providers.dart`.
- Don't import a feature's `presentation/` from another feature.

## Related

- [error-handling.md](./error-handling.md) — `Either<Failure, T>` flows through providers.
- [testing.md](./testing.md) — override patterns.
- [../../AGENTS.md](../../AGENTS.md) — index.
