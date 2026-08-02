# Changelog

Behavior, not commits. Dates are the day the change landed on `main`.

## 0.1.0 — unreleased

First public version. Nothing is tagged yet, so this entry describes the skill as it stands at launch rather than a diff from anything.

- Two modes. Audit reports whether a repository's claims match its code. Launch audits first, proposes a plan, and writes only what was approved.
- The enforcement gate: every claim that something is prevented, blocked, refused, required, or guaranteed is classified Enforced, Advisory, Guidance, or Unsupported against the mechanism behind it. Scope and liveness count — a guard over one directory does not back a claim about the build, and a workflow step that no longer runs never fails.
- Six opt-in checklist packs, with Safety gates mandatory before a public flip. A checklist the audited repo ships outranks all of them.
- Five swap-in modules under `checklists/modules/`, selected by the repo's shape rather than the user's intent. Each states the trigger that makes it apply and is offered, not applied: self-proof (the product is a judgment), single source of truth (a number is written in more than one file), pinned knowledge (the repo restates a third-party spec), live data (a published number comes from a scheduled job), and evidence grading (the repo itself ships a grader).
- The evidence bar is in the skill itself, not a pack. A verdict needs a `file:line` or an explicit searched-and-found-nothing note; a grep miss alone does not establish Unsupported, because the target names things its own way and a false Unsupported is a false accusation; an open PR is verified against its diff, not its title, and what it fixes moves to `Known / in-flight`; every finding names the file, guard, or test to change.
- Safety gates now scan metadata as well as the tree. Commit messages, branch names, tags, and PR and issue text are checked against the same pattern as the file scan, because a leak in a commit message survives fixing the file and needs a history rewrite that forks and `refs/pull/*` never see.
- Five README templates chosen by product shape, each with a `What's enforced` table so a generated README states its mechanisms rather than earning a P1 on the next audit.
- Reports carry `Evidence checked` and `Coverage limits`. Coverage limits cannot be omitted; an empty one is a claim that everything was checked.
- Install pulls the whole skill directory. `SKILL.md` on its own now fetches a missing checklist or template from `raw.githubusercontent.com`, and reports what it could not fetch instead of proceeding without it.
- `NOTICE` records the structure adapted from Nnenna Ndukwe's Apache-2.0 work.
