# Self-proof

**Trigger:** the repo's product is a judgment. A linter, detector, auditor, scorer, grader, or benchmark — anything whose output is a verdict on someone else's work.

A tool that flags "delve" in your draft should survive its own pass. A tool that does not run on itself is asking for a trust it has not earned, and the reader has no way to tell which.

- [ ] **The tool runs on itself, in one command, with no setup.** `avoid-ai-writing` publishes `git clone … && node scripts/self-scan.js` at the top of [`PROOF.md`](https://github.com/conorbronsdon/avoid-ai-writing/blob/main/PROOF.md). A self-assessment a reader cannot reproduce is a press release. `P1`.
- [ ] **The published result includes the unflattering number.** `PROOF.md` prints a raw score and an exempt score per file side by side, because "publishing only the flattering one is the behavior this project exists to criticize." If the tool has an escape hatch, show the score with and without it. `P1`.
- [ ] **CI gates the live measurement, not the number written in the README.** `.github/workflows/detector-test.yml` runs `npm run self-scan:check`; `scripts/self-scan.js --check` exits 1 when a file exceeds its budget. A table pasted into a markdown file rots the moment the docs change and nothing notices. `P1`.
- [ ] **The gate is a regression ceiling that only moves down.** The `BUDGETS` map in `scripts/self-scan.js` documents this in the code: ceilings set from measured values with headroom, and "raising one is a decision that belongs in a pull request with the new number stated." A ceiling anyone can raise in the same commit that breaks it is not a gate. `P2`.
- [ ] **The page states what the measurement does not cover.** `PROOF.md` has a "What this page does not claim" section: a low score means no surface pattern hits, not that the writing is good or human, and blanking exempt spans perturbs the document-level metrics. Naming the limitation is what makes the rest of the number readable. `P2`.
- [ ] **A number has a publication gate it must clear before it becomes a claim.** `corpus/README.md` requires n >= 100, a confidence interval, and more than one register people actually write in today before any figure enters the README, a release note, or a social post — and the current run **fails** the register test, so the numbers stay in the write-up rather than the headline. Without a stated gate, every measured number drifts into marketing. `P2`.

## README section this contributes

When the checks pass, the README earns a link, not a paragraph of self-praise:

```markdown
## Proof

This tool runs against its own documentation. [`PROOF.md`](PROOF.md) publishes the
result, including the files that score worst and why. Reproduce it:

    <the one command>

CI fails the build when any file drifts past its budget.
```

If the repo cannot fill that section from evidence, the section does not go in.
