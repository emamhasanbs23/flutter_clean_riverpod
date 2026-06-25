# Contributing

Thanks for your interest in `flutter_clean_riverpod_boilerplate`. This document
covers the local workflow and the conventions the project follows.

## Local setup

1. Install [FVM](https://fvm.app) and the Flutter SDK pinned in `.fvm/fvm_config.json`.
   ```sh
   fvm install
   fvm use 3.41.8
   ```
2. Install dependencies.
   ```sh
   fvm flutter pub get
   ```
3. Pick a flavor and run the app.
   ```sh
   fvm flutter run --flavor dev -t lib/main_dev.dart
   ```

## Code conventions

- The project intentionally avoids `freezed` / `riverpod_generator` / `build_runner`. Keep
  new code hand-written and run `dart format .` before committing.
- Domain entities live in `lib/features/<feature>/domain/` and must not import anything
  from `data/` or `presentation/`. The opposite direction is also one-way: `data/`
  implements `domain/`, `presentation/` consumes both.
- All I/O and async work returns `Either<Failure, T>` from `fpdart`. Never throw across
  layer boundaries.
- Use `Failure.toMessage(context)` at the render site; controllers and providers carry the
  raw `Failure` and never pre-localize.
- Mutations in `TodoListController` re-fetch via `refresh()` to keep the data source
  authoritative.
- Cross-feature dependencies go through Riverpod providers — never `import` another
  feature's internals.

## Tests

```sh
fvm flutter test
```

When adding a feature, add tests at the matching layer:
- `domain/` → use case tests (mock the repository).
- `data/` → repository tests (mock the data source).
- `presentation/` → controller tests (override providers with a `ProviderContainer`).
- `core/` → unit tests for the helper.

Widget tests are optional but encouraged for any new page; they need a
`Localizations` ancestor (`MaterialApp` plus `flutter_localizations`) so the
`context.l10n` extension resolves.

## Pull requests

1. Branch from `main` (`feature/<short-name>` or `fix/<short-name>`).
2. Run `dart format .` and `flutter analyze` locally — CI rejects diffs.
3. Keep commits focused; squash noisy WIP commits.
4. In the PR description, link any related issue and call out testing you performed.

## Reporting bugs

Use the **Bug report** issue template and include:
- Flutter / Dart versions (`flutter --version`)
- Device + OS
- Flavor (`dev` / `staging` / `prod`)
- Steps to reproduce
- Expected vs actual behaviour
- Logs or screenshots when relevant