# AGENTS.md

Repository guidance for coding agents. `SKILL.md` is the product; everything else supports it.

## What this repo is

One agent skill, `SKILL.md`, that audits a repository before it goes public. There is no build, no test suite, and no runtime — the skill is the deliverable, and it is read by an agent rather than executed.

## Rules

Each rule names the mechanism that checks it, or is marked unenforced. This repo holds itself to its own Step 3 gate.

| Rule | Enforced by |
|---|---|
| `SKILL.md` frontmatter must keep `name`, `description`, `version`, `license`, `compatibility`, and `metadata` | **Unenforced.** No validator here yet — check by hand until one exists. |
| `version` in `SKILL.md` matches the top heading in `CHANGELOG.md` | **Unenforced.** Bump both in the same commit. |
| Line endings are LF | `.gitattributes` (`* text=auto eol=lf`), applied by git on commit |
| No credentials or private-context strings | **Unenforced in CI.** The two-pass scan in `SKILL.md` Step 4 is run by hand before any public flip. |
| Funding metadata belongs only on this owned repo, never a fork | **Unenforced.** Convention only. |

If you add a CI gate for any of these, move the row and say what fails closed.

## Changing the skill

- Keep the credit to [Nnenna Ndukwe](https://github.com/nnennandukwe) in `SKILL.md` and `README.md`. The structure is adapted from her Apache-2.0 work, so removing the attribution while keeping the structure breaks the licence terms.
- Worked examples must stay real. Every example in `SKILL.md` describes something that actually happened. Do not add an illustrative one that did not.
- Do not add prose-style checks. This skill owns facts, enforcement, and policy; a writing-quality pass is a separate tool. A second hype-word list here is drift, not a feature.
- Keep the product-shape exception. Removing it makes the skill misfire on games and consumer apps.

## Deliberately not here

The launch packs for this repo are Core, Open source, Safety gates, and Distribution. These items in them are skipped on purpose, so an audit does not re-file them:

- **No Cursor rule port.** The README used to claim Cursor support the install did not deliver. A `.cursor/rules/*.mdc` port is a second copy of `SKILL.md` to keep in sync, and a single `.mdc` file cannot carry `checklists/` or `templates/`, which launch mode reads by path. The claim was cut instead. If a port lands later, it ships with the sync story, not before.
- **No `question.yml` issue form.** Discussions is off on this repo, so the template's Question contact link would 404. Blank issues are enabled instead — see `.github/ISSUE_TEMPLATE/config.yml`.
- **No `good first issue` or `help wanted` labels yet.** There are no issues to apply them to.
- **No release tags, checksums, or artifacts.** The Release pack does not apply: the skill is a file you copy, not a build you publish. `CHANGELOG.md` exists anyway, because behavior changes and readers need the diff.
- **No CI.** There is nothing to build or test, and the rules table above marks every unenforced rule as unenforced rather than pretending otherwise.

## Before flipping this repo public

Run the skill against itself, then work `SKILL.md` Step 4. The social preview upload is manual — GitHub has no API for it.
