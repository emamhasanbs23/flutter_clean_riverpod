# Task: Add a new environment variable

> Goal: add a per-flavor env value and surface it in Dart through the
> Flavor config.

## Preconditions

- Value is **non-secret**. Secrets don't belong here — use secure
  storage or CI secrets. See [flavors.md](../agents/flavors.md).

## Steps

1. **Add to all three** `env.<flavor>.json` files:
   ```json
   {
     "MY_FLAG": "value-dev"
   }
   ```
   Keep the keys identical across flavors; only the values change.
2. **Loader**: extend the env loader in `lib/core/env/` to read the key.
   Type the result (String, bool, int).
3. **Plumbing**: pass the parsed value into wherever it needs to live —
   usually `bootstrap.dart` for Dio `baseUrl`, headers, or feature flags.
4. **Default**: provide a safe default in the loader so a missing key
   never crashes startup.
5. **Tests**:
   - Loader returns the parsed value for each flavor.
   - Missing key returns the default.

## What you may NOT do

- ❌ Commit a secret value, token, or signing material.
- ❌ Reference `Flavor` directly outside `lib/core/config/`.
- ❌ Read the env file from a feature — go through the loader.

## Done criteria

- [ ] Key present in all three `env.<flavor>.json`.
- [ ] Loader is typed + defaulted.
- [ ] Tests cover happy path + missing-key default.

## Related

- [flavors.md](../agents/flavors.md) — flavor system.
- [commands.md](../agents/commands.md) — per-flavor run commands.
