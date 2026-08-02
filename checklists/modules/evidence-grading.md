# Evidence grading

**The rules this module exists for are not optional and are not here.** They are built into `SKILL.md`: the diff-not-title rule in Step 0, the evidence bar in Step 3, and the concrete-fix rule and verification pass in Step 5. They govern every audit this skill produces, so they were transplanted into the skill rather than left in a pack someone might not select.

**Trigger for this file:** the repo under audit *itself* ships something that grades — an auditor, a reviewer, a rubric, a rating schema, a report format. Then its own rating contract has to clear the same bar, and these are the checks.

Reference implementation: [`eval-integrity`](https://github.com/conorbronsdon/eval-integrity), whose `SKILL.md` states the evidence bar the rules above are adapted from.

- [ ] **The rating scale is defined, and every level says what evidence it requires.** `eval-integrity` defines `PRESENT` as implemented *and* enforced in code or a test, not prose, and requires a `file:line`. A scale whose levels are adjectives produces ratings nobody can dispute or reproduce. `P1`.
- [ ] **A rating with no evidence is rejected, not softened.** The rule is stated as a rejection: a rating with no `file:line`, or no explicit "searched X, Y, Z — found nothing," is a guess. Downgrading an unevidenced finding to a lower severity keeps it in the report; rejecting it removes it. `P1`.
- [ ] **The tool tells the grader that a grep miss does not establish absence.** The target names things under its own vocabulary — a holdout called a "sequestered split," a judge called a "grader." Concept search over the entry points, workflows, and docs comes before any absent rating. A false absent is a false accusation. `P1`.
- [ ] **A verification pass runs before the report is emitted, and spot-checks the absents specifically.** Trusting a sub-report's rating at face value is how a parallel audit launders a guess into a verdict. `P2`.
- [ ] **Every gap carries a fix that names a file, a guard, or a test.** `eval-integrity`'s report rules state it as a prohibition: not "consider improving X." `P2`.
- [ ] **In-flight fixes are a separate bucket with their own heading, verified against the diff and excluded from the counts.** A report that counts a gap an open PR already closed is wrong twice — the number and the ask. `P2`.
