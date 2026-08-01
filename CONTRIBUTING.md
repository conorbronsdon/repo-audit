# Contributing

This project accepts changes that make the audit catch something real it currently misses, or stop it filing something that is not a defect.

## Setup

There is no build and no test suite. `SKILL.md` is the product; an agent reads it. To work on it, install your checkout as the skill and run it:

```bash
git clone https://github.com/conorbronsdon/repo-audit
mkdir -p .claude/skills/repo-audit && cp -r repo-audit/{SKILL.md,checklists,templates} .claude/skills/repo-audit/
```

Then, in an agent session: `Audit this repo with repo-audit.` If it produces a report with Evidence checked and Coverage limits filled in, your copy works.

## Making a change

1. Run the skill against this repository, with your change in place. It holds itself to its own gates, and a change that makes it fail its own Step 3 is the change to fix.
2. Check that every relative link in `SKILL.md` and `README.md` still resolves — the checklists and templates are addressed by path from both.
3. Open a pull request describing what changed and how you verified it.

Include in the PR: what you changed, how you tested it, and anything you could not verify.

## Scope

This project does not accept:

- **Prose-style or hype-word checks.** This skill owns facts, enforcement, and policy. A second word list here is drift. See the Toolbox table in `SKILL.md` for where that work belongs.
- **Numeric scores.** A score invites arguing with the number instead of the finding.
- **Worked examples that did not happen.** Every example in `SKILL.md` describes a real audit. Illustrative ones are not allowed, however clear.
- **Removing the product-shape exception.** Without it the language gates misfire on games and consumer apps.
- **Removing the credit to Nnenna Ndukwe** while keeping the adapted structure. See `NOTICE`.
- **Checklist items that are style preferences.** A checklist item names something that breaks, misleads, or blocks a launch.

Proposals that change these boundaries need discussion in an issue first.

## Reporting bugs

Open an issue with the bug form. Include the agent you ran it in, how you installed the skill (tarball, clone, single file), the repository shape it was auditing, and the finding it filed or missed — quoted, not summarized.
