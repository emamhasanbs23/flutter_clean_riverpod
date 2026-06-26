# Flavors (dev / staging / prod)

> Three flavors, three entrypoints, one `bootstrap`.
> Part of the [AGENTS.md](../../AGENTS.md) index.

## Entrypoints

```
lib/main.dart          # default (prod)
lib/main_dev.dart      # dev
lib/main_staging.dart  # staging
lib/main_prod.dart     # prod
```

Each is a one-liner that calls `bootstrap(Flavor.x)`.

## Flavor enum

`lib/core/config/flavor.dart` defines:

```dart
enum Flavor { dev, staging, prod }
```

Plus a `currentFlavor` extension that returns the active one inside `bootstrap`.

## bootstrap.dart

`bootstrap(Flavor)` wires everything flavor-specific:

- Env file selection (`env.<flavor>.json`).
- Dio `baseUrl` and headers.
- Analytics / CrashReporter implementations (NoOp by default, swap in prod).
- `onSessionExpired` callback for the auth interceptor.
- RunZonedGuarded entrypoint.

## Per-flavor files

- `env.<flavor>.json` — committed, **non-secret** values (hostnames, public flags).
- `android/app/build.gradle.kts` — `productFlavors { dev { ... } staging { ... } prod { ... } }`.
- `ios/Runner/Configuration-<Flavor>.xcconfig` and `Info-<Flavor>.plist`.
- `flutter_launcher_icons-<flavor>.yaml` and `flutter_native_splash-<flavor>.yaml`.

## Running

```bash
fvm flutter run --flavor dev     -t lib/main_dev.dart
fvm flutter run --flavor staging -t lib/main_staging.dart
fvm flutter run --flavor prod    -t lib/main_prod.dart
```

See [commands.md](./commands.md) for full build/test commands.

## Secrets

`android/key.properties` is **gitignored**. Copy from `key.properties.example`. Real keys, tokens, or signing material must never be committed — keep them in env-specific keychains or CI secrets.

## Related

- [commands.md](./commands.md) — how to run/build per flavor.
- [auth-refresh.md](./auth-refresh.md) — `onSessionExpired` is wired in `bootstrap`.
- [../../AGENTS.md](../../AGENTS.md) — index.
