# Analyzer Overrides

> Three rules are intentionally relaxed. Do not re-enable them without maintainer sign-off.
> Part of the [AGENTS.md](../../AGENTS.md) index.

## The base

`analysis_options.yaml` includes `very_good_analysis`. Every rule is enforced **except** the three below.

## Relaxed rules

| Rule                                              | Why it's off                                                                                  |
|---------------------------------------------------|-----------------------------------------------------------------------------------------------|
| `public_member_api_docs`                          | Internal boilerplate; not all public APIs are user-facing library surfaces.                   |
| `avoid_dynamic_calls`                             | Permitted inside DTO mappers and Dio response handling where the schema is dynamic by design. |
| `invalid_use_of_visible_for_testing_member`       | Test helpers are intentionally accessible from test files across module boundaries.            |

## When to push back

If you're tempted to turn one of these back on, **don't** — instead:

- Add a comment in the file explaining the dynamic schema.
- Mark test helpers with a more explicit `// visible for testing across modules` comment if needed.
- Add a doc comment to public APIs that are actually part of the public contract.

## What stays on

All other `very_good_analysis` rules are enforced. CI runs `fvm flutter analyze` and the build fails on any violation.

## Related

- [commands.md](./commands.md) — `fvm flutter analyze` in the pre-PR gate.
- [ci.md](./ci.md) — where this is enforced.
- [../../AGENTS.md](../../AGENTS.md) — index.
