# AGENTS.md

Repository guidance for coding agents. `SKILL.md` is the product; everything else supports it.

## What this repo is

One agent skill, `SKILL.md`, that audits a repository before it goes public. There is no build, no test suite, and no runtime — the skill is the deliverable, and it is read by an agent rather than executed.

## Rules

Each rule names the mechanism that checks it, or is marked unenforced. This repo holds itself to its own Step 3 gate.

| Rule | Enforced by |
|---|---|
| `SKILL.md` frontmatter must keep `name`, `description`, `license`, `compatibility`, and `metadata` | **Unenforced.** No validator here yet — check by hand until one exists. |
| Line endings are LF | `.gitattributes` (`* text=auto eol=lf`), applied by git on commit |
| No credentials or private-context strings | **Unenforced in CI.** The two-pass scan in `SKILL.md` Step 4 is run by hand before any public flip. |
| Funding metadata belongs only on this owned repo, never a fork | **Unenforced.** Convention only. |

If you add a CI gate for any of these, move the row and say what fails closed.

## Changing the skill

- Keep the credit to [Nnenna Ndukwe](https://github.com/nnennandukwe) in `SKILL.md` and `README.md`. The structure is adapted from her Apache-2.0 work, so removing the attribution while keeping the structure breaks the licence terms.
- Worked examples must stay real. Every example in `SKILL.md` describes something that actually happened. Do not add an illustrative one that did not.
- Do not add prose-style checks. This skill owns facts, enforcement, and policy; a writing-quality pass is a separate tool. A second hype-word list here is drift, not a feature.
- Keep the product-shape exception. Removing it makes the skill misfire on games and consumer apps.

## Before flipping this repo public

Run the skill against itself, then work `SKILL.md` Step 4. The social preview upload is manual — GitHub has no API for it.
