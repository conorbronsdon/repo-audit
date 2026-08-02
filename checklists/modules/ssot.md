# Single source of truth

**Trigger:** the README carries two or more numerals that read as counts, prices, versions, or dates — or the same figure appears in a README, a docs page, and a landing page. Any number written by hand in more than one file is already drifting; nobody notices until a reader does.

Scope is any fact with one true value: a count, a price, a version, a date, an address, a support email. This module checks that the repo has decided where each one lives and put something in the path that verifies the rest.

Reference implementation: [`ssot-check`](https://github.com/conorbronsdon/ssot-check). `python3 ssot_check.py discover --root .` proposes drift-prone facts read-only and writes nothing, which makes it safe to run during an audit.

- [ ] **Every fact written in more than one file has one declared canonical location.** Not "the README is probably right" — a manifest entry naming the file and the pattern that extracts the value, as in [`.ssot.example.yaml`](https://github.com/conorbronsdon/ssot-check/blob/main/.ssot.example.yaml). A convention that lives only in a maintainer's head is guidance, not a source of truth. `P2`.
- [ ] **Something mechanical verifies the copies.** A hook, a CI step, or a test that reads both sides and compares. `ssot-check` ships [`hooks/pre-commit`](https://github.com/conorbronsdon/ssot-check/blob/main/hooks/pre-commit) and a composite [`action.yml`](https://github.com/conorbronsdon/ssot-check/blob/main/action.yml); the CLI exits `1` on drift and `2` on a manifest error, and the Action step fails the build on either. Docs telling contributors to keep the numbers in sync are guidance. `P1` when the drifted number is public-facing — a price or a version. `P2` otherwise.
- [ ] **The hook posture is chosen, not inherited.** `hooks/pre-commit` soft-fails by default: it prints the drift and lets the commit through, so it never blocks work it cannot auto-fix. `SSOT_STRICT=1` makes it blocking. Either is defensible; what is not defensible is a README that calls a soft-fail hook a guarantee. Check the claim against the exit code. `P1` if the claim overstates it.
- [ ] **A rounded copy is declared as rounded.** A README that says "1,000+ downloads" against a canonical `1,234` is not a stale copy, it is a different fact, and a checker that tolerates the gap with fuzzy matching cannot tell drift from rounding. `ssot-check` handles this with a per-copy `rounding: floor-1000`, a deterministic transform applied to the canonical before an **exact** compare. Undeclared rounding, or a checker with a tolerance window, both fail this. `P2`.
- [ ] **The comparison is typed.** `1,234`, `1234`, and `1234+` are the same count; `v1.2.3` and `1.2.3` are the same version. A string compare files three findings a reader will learn to ignore. `ssot-check`'s `type:` field (`string`, `integer`, `currency`, `semver`, `date`) normalizes before comparing. `P3`.
- [ ] **Facts that expire carry an owner and a max age.** A count that was correct in March and has had no editor since is a different failure from a copy that drifted, and needs a different fix. `freshness: {owner, max_age_days}` checks the canonical file's git last-edit date and reports when it lapses. Applies to metrics, pricing, and roadmap dates; not to a support email. `P2`.

## What this does not cover

Cross-repo copies are read-only in any sane setup: report the divergence, never write into a sibling tree. If a copy cannot be read, it is **unverified**, which is a finding in its own right — not an assumed match.
