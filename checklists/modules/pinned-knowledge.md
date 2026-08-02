# Pinned knowledge

**Trigger:** the repo restates a third-party contract. A spec, an API surface, a frontmatter table, a pricing tier, a model name, a rate limit, a config schema — anything whose true value lives on someone else's docs page and can change without a commit here.

Restating is usually correct: it keeps an agent from fetching a page mid-task, and it makes the repo readable offline. The failure is restating without a date and without anything that notices the upstream moved.

**Worked example, in this repo.** `SKILL.md` frontmatter pins `agentskills_spec: "1.0"`. Nothing in this repository reads that field, checks it against agentskills.io, or notices if the spec reaches 1.1 — `AGENTS.md` records that there is no CI at all. The pin is a claim of conformance with no mechanism behind it, which is exactly the Step 3 verdict this skill files against other people's repos.

Reference implementation: [`agent-skill-builder`](https://github.com/conorbronsdon/agent-skill-builder), which pins the Claude Code skill frontmatter spec in `references/claude-code-frontmatter.md` and watches it from `scripts/check_spec_freshness.py` and `.github/workflows/spec-drift.yml`.

- [ ] **Every restatement carries a dated snapshot header naming its source.** `references/claude-code-frontmatter.md` opens with `**Snapshot:** 2026-07-13, from https://code.claude.com/docs/en/skills`, and names the specific sections it copied. Undated, a reader cannot tell a current transcription from a two-year-old one. `P1` when the restated thing is a version, a price, or an API signature. `P2` otherwise.
- [ ] **An age gate runs without a network.** `check_spec_freshness.py` parses the `**Snapshot:**` date and fails at `MAX_AGE_DAYS = 90` before it tries to reach anything. This is the layer that keeps working in a restricted runner, on a fork, and after the upstream URL changes. A freshness check that only works when a fetch succeeds does not run in the environments where it matters most. `P1`.
- [ ] **The field-drift fetch is best-effort and degrades to pass.** The same script pulls the live docs page and reports snapshot fields that no longer appear on it — but a fetch failure prints the reason and returns success, because the age check already passed. A network flake that fails the build teaches everyone to ignore this job. `P2`.
- [ ] **Drift opens a labeled issue instead of failing the build.** `spec-drift.yml` runs the check with `continue-on-error: true`, then opens an issue labeled `spec-drift` with the log in the body. Upstream changing is not the contributor's fault, and a red X on an unrelated pull request is how the signal gets muted. `P2`.
- [ ] **The issue path has a dedupe guard.** Before creating, `spec-drift.yml` queries `gh issue list --label spec-drift --state open` and exits if one is already open. A weekly cron with no guard files fifty-two issues for one unaddressed drift and buries the real one. `P2`.
- [ ] **The update path is a reviewed change, never a side effect.** The snapshot file states its own policy: if the date is more than three months old, warn and continue — do not update it while doing something else. Bumping a pinned date is the act of asserting the new content is correct, so it belongs in a pull request someone read. `P2`.
- [ ] **The check states what it cannot see.** The script's own comment records that it detects removed and renamed fields, not newly added ones, because new-token sniffing on a docs page is too noisy to gate CI on — new-field discovery happens at the age-triggered manual review. A staleness check whose blind spot is undocumented reads as complete coverage. `P3`.

## README section this contributes

```markdown
## Pinned references

`references/` restates <what> from <source>, snapshotted on <date>. It is not
fetched at runtime. A weekly job checks the snapshot against the live page and
opens a `spec-drift` issue when they diverge; the snapshot is only updated
through a reviewed pull request.
```
