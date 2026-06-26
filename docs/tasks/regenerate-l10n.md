# Task: Regenerate `AppLocalizations`

> Goal: rebuild generated localization classes after editing any ARB.

## When to run

- After adding, renaming, or removing any key in `lib/l10n/app_*.arb`.
- After changing `l10n.yaml` (locale list, output location).
- Before opening a PR that touches any user-facing copy.

## Steps

```bash
fvm flutter gen-l10n
```

If the generated file lives under `.dart_tool/` (configured in
`l10n.yaml`), verify the change is reflected on the next `fvm flutter
run`.

## Sanity checks

```bash
fvm flutter analyze
fvm flutter test
```

If a widget test asserts on a string, run it against the regenerated
localizations to confirm the key is still present.

## Done criteria

- [ ] `gen-l10n` exit 0.
- [ ] Analyzer clean.
- [ ] Test suite green.

## Related

- [localization.md](../agents/localization.md) — full ARB workflow.
- [commands.md](../agents/commands.md) — exact CLI invocation.
