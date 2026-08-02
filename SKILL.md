---
name: repo-audit
description: Audit a repository or prepare it for an open-source release. Audit mode reports whether the README matches the code and whether stated rules are actually enforced; launch mode walks a repo to release-ready with opt-in checklist packs and README templates. Use when asked to "audit this repo," "is this repo ready to go public," "prepare this repo for release," "open-source this," "get this ready to publish," "check this README," or "what's missing before I launch this." Reports by default; writes only when explicitly asked.
version: 0.1.0
license: Apache-2.0
compatibility: Requires read access to the repository and a shell for git and grep. Uses the GitHub CLI for repository metadata when available; degrades to local-only checks when it is not.
metadata:
  author: Conor Bronsdon
  tags: [audit, readme, release, open-source, documentation, agent-readiness, launch]
  agentskills_spec: "1.0"
---

# Repo Audit

Two jobs, one skill.

| Mode | Question it answers | Default posture |
|---|---|---|
| **Audit** | Is everything this repo claims about itself true? | Read-only. Reports findings. |
| **Launch** | What stands between this repo and a release people can adopt? | Read-only until you approve a plan, then writes what you picked. |

Pick from what the user asked. "Audit this," "check this README," "is this accurate" → audit. "Prepare this for release," "I want to open-source this," "what's missing before launch" → launch. When it is ambiguous, run audit first and offer launch: you cannot plan a release around a README that is already wrong.

This skill owns facts, enforcement, packaging, and release readiness. It does not grade prose style; see [Toolbox](#toolbox) for what to reach for instead. Do not grow a second hype-word list here.

---

## Operating Boundary

- **Read-only by default.** Report. Do not edit, stage, commit, branch, push, or open a pull request unless explicitly asked.
- **Launch mode proposes before it writes.** Produce the plan, get approval, then create files. Never generate a dozen boilerplate files unasked.
- A request to "audit" is a request for a report. A request to "fix," "prepare," or "apply" authorizes writing the files in the approved plan, nothing else.
- Preserve unrelated worktree changes.
- Never run a destructive or state-changing command to verify a claim. `--help`, `--dry-run`, and reading source are enough.
- **Never flip a repository public.** That is the user's action, always. Report readiness; let them throw the switch.

---

## Step 0: Verify you are looking at current code

**Do this first, every time. An audit of a stale checkout is worse than no audit** — it manufactures findings that were fixed weeks ago and states them with confidence.

```bash
git fetch -q origin && git status -sb | head -1
```

If the branch is behind, pull before reading anything. If you cannot fetch, say so under Coverage limits and treat every finding as provisional.

Then check open pull requests before calling anything missing. **Verify each relevant PR against its diff, not its title.** A title states an intention; the diff is the only thing that says what lands. A gap an open PR actually closes is reported under *Known / in-flight* and excluded from the counts, not filed as a finding. A PR whose title promises the fix and whose diff does not deliver it is still a finding.

---

## Step 1: Establish the factual contract

Read the sources **before** the README, so the README cannot frame what you believe.

Inspect the smallest authoritative set that applies:

- CLI help and command registration
- public API or service entry points
- generated artifact paths, schemas, config examples
- installation and release configuration
- tests that enforce documentation or command parity
- contributing, architecture, and security docs
- agent instruction files (`AGENTS.md`, `CLAUDE.md`, `.cursorrules`)
- hooks and CI (`.husky/`, `.githooks/`, `.github/workflows/`) — these matter for Step 3

Write down what the software accepts, what it does, exactly what it returns or changes, where those outputs live, and what it deliberately does not do.

**Record every source you could not inspect.** That list is a required output, not a footnote.

### Identify the product shape

Everything downstream depends on this. Pick one:

`cli` · `library` · `service` · `framework` · `integration` · `agent-skill` · `app` · `data` · `game-or-narrative`

The shape selects the README template in launch mode and decides which language gates apply in audit mode.

---

## Step 2: Audit the README against that contract

The spine, in order. A missing answer is a finding. Do not excuse it because a later section eventually explains it.

1. What does the software do?
2. What exact thing does it return, generate, change, or expose?
3. Who is it for, and in what repository or system state?
4. What do they do with the result?
5. How do they install and run it?
6. What must they review, approve, or operate themselves?
7. What is automated, advisory, optional, or out of scope?
8. Where is the deeper detail?

**First sentence:** must state literal behavior with familiar technical nouns and a concrete verb. Flag openings that lead with an undefined internal term, say only that the software "helps" or "enables," call something "AI-ready" or "agent-friendly" without naming what changes, or state implementation form ("a CLI and framework") instead of behavior.

**Commands:** check every command against current help or source. Copy-safety counts — flag raw angle-bracket placeholders a shell would read as redirection.

**Links and anchors:** verify in-page anchors resolve and referenced paths exist.

### The product-shape exception

These language gates assume a developer tool. **They misfire on `game-or-narrative` and `app` shapes**, where evocative prose is the correct README. For those, apply the factual gates (commands work, paths exist, claims are true) and drop the literal-noun ones. A game README that opens by setting a scene is not a defect. Filing that finding costs you the reader's trust in every other finding in the report.

---

## Step 3: The enforcement gate

**The check nothing else covers.**

For every claim that something is prevented, blocked, refused, required, or guaranteed, find the mechanism. Then classify it:

| Claim backed by | Verdict |
|---|---|
| A hook, CI job, test, validator, or type that fails closed | **Enforced.** The claim stands. |
| A warning that prints but does not block | **Advisory.** Reword the claim. |
| A sentence in a markdown file telling an agent or human not to do it | **Guidance.** Not enforcement. |
| Nothing found | **Unsupported.** P1. |

Instructions and configuration are not enforcement by themselves. A rule an agent is asked to follow is guidance, however forcefully worded.

Worked example: a memory-management kit whose README stated "the dream commands refuse to push." The mechanism was an instruction to a model in a command file, plus an install-time warning that printed and continued. No hook, no CI. A reader could reasonably believe pushing was impossible when it was one command away, on a tool whose entire pitch is keeping private data local.

**Check the scope of the mechanism, not just its existence.** A guard that scans one directory does not back a claim about the whole build. A denylist of named vendors does not back a claim of "no third-party services." When the claim is broader than the check, that gap is the finding.

**Check the inverse too:** a mechanism that exists but no longer runs. A workflow step whose dependency is gone, a hook nobody installed, a gate keyed to a service the owner lost access to. These rot silently, because a step that never executes never fails.

Apply the same test to the repo's own agent rules: every "always" or "never" either names the mechanism that checks it or is marked unenforced.

### The evidence bar

Every verdict above is a claim about someone's repository, so every verdict carries its evidence.

**Evidence is mandatory.** A verdict with no `file:line` — or no explicit "searched `X`, `Y`, `Z`, found nothing" — is not a finding, it is a guess. Reject it before it reaches the report. This applies to the clean verdicts too: "Enforced" with no cited mechanism is the same guess wearing a friendlier word.

**A grep miss alone does not establish Unsupported.** Your search terms carry your vocabulary, and the repo names things its own way: a guard called `verify`, a hook installed through `core.hooksPath` rather than `.git/hooks/`, a check that lives in a test file rather than a workflow. **Search by concept** — read the entry points, the CI workflows, the hooks directory, and the docs under the target's own names — before calling anything unsupported. This rule is load-bearing. Every other finding costs the reader a fix; a false Unsupported costs them a defense, because it is an accusation that they claimed something untrue.

**In-flight fixes are not gaps.** Step 0 already checked open pull requests against their diffs. Anything a merged-pending diff genuinely fixes goes under *Known / in-flight* with the PR number, and does not count.

---

## Step 4: Choose the checklist packs

**A repo-local checklist outranks everything here.** If the repository ships its own launch or release checklist, read it first and treat it as the standard. Repo-local expectations beat received best practice. These packs are for repos that have none, or gaps theirs does not cover.

Packs are opt-in. Ask which apply rather than running all of them. A private internal tool does not need community health files, and an audit that files findings the user will never act on trains them to ignore the report.

| Pack | File | Apply when |
|---|---|---|
| **Core** | [`checklists/core.md`](checklists/core.md) | Always. License, description, line endings, basic hygiene. |
| **Open source** | [`checklists/open-source.md`](checklists/open-source.md) | The repo is going public, or already is. Contribution path, security policy, conduct, issue templates. |
| **Release** | [`checklists/release.md`](checklists/release.md) | The repo ships versioned artifacts — tags, packages, binaries. |
| **Agent readiness** | [`checklists/agent-readiness.md`](checklists/agent-readiness.md) | Coding agents will work in this repo, or it ships skills. |
| **Distribution** | [`checklists/distribution.md`](checklists/distribution.md) | Anyone is meant to find it. Discovery, listings, social preview. |
| **Safety gates** | [`checklists/safety-gates.md`](checklists/safety-gates.md) | **Mandatory before any public flip.** Leak scan, private links, content holds. |

Default suggestion by intent: going public → Core + Open source + Safety gates + Distribution. Shipping a version → Core + Release. Handing to agents → Core + Agent readiness. Improving an existing public repo → Core + whatever the audit surfaced.

### Swap-in modules

[`checklists/modules/`](checklists/modules/) holds narrower add-ons that most repos do not need. A module is selected by the repo's **shape**, not by the user's intent: each one states the trigger that makes it apply, and the trigger is a fact you can check from Step 1 evidence. Name the module and the trigger you observed, ask before applying it, and drop it if the answer is no. A module the user did not want produces findings they will not act on, which is how the whole report gets ignored.

| Module | File | Trigger |
|---|---|---|
| **Self-proof** | [`modules/self-proof.md`](checklists/modules/self-proof.md) | The repo's product is a judgment — a linter, detector, auditor, scorer, or benchmark. |
| **Single source of truth** | [`modules/ssot.md`](checklists/modules/ssot.md) | The README carries two or more numerals reading as counts, prices, or versions. |
| **Pinned knowledge** | [`modules/pinned-knowledge.md`](checklists/modules/pinned-knowledge.md) | The repo restates a third-party spec, API, pricing tier, or docs page. |
| **Live data** | [`modules/live-data.md`](checklists/modules/live-data.md) | A workflow carries `schedule:`, or a published number is sourced from JSON. |
| **Evidence grading** | [`modules/evidence-grading.md`](checklists/modules/evidence-grading.md) | The repo itself ships something that grades. Its core rules are already in Steps 0, 3, and 5. |

Modules also carry README sections. Where a module names one, it is a section launch mode can add for that shape — filled from evidence like any other, and left out when the repo cannot fill it.

**If a pack file is not on disk beside this one**, fetch it — a single-file install of `SKILL.md` has no `checklists/` directory:

```
https://raw.githubusercontent.com/conorbronsdon/repo-audit/main/checklists/<pack>.md
https://raw.githubusercontent.com/conorbronsdon/repo-audit/main/checklists/modules/<module>.md
```

If the fetch fails, name the pack under Coverage limits and audit without it. Never work a pack from its title: the file is the checklist, and a pack you guessed at is a set of findings the user cannot trace to anything.

---

## Step 5: Report (audit mode)

### Severity

- **P1** — misstates behavior, hides the primary output, gives an invalid command, claims enforcement that does not exist, leaks private context, or blocks a public flip.
- **P2** — audience, downstream use, approval boundary, prerequisite, or canonical artifact is unclear.
- **P3** — wordiness, ordering, or formatting friction that does not change the factual contract.

No numeric scores. A score invites arguing with the number instead of the finding.

### Format

```markdown
## Repo Audit — <repo>

**Bottom line:** one sentence — could a stranger clone this and use it, and is what it claims true?

**Audited at:** <sha>, <branch>, fetched <yes/no>
**Product shape:** <shape>
**Packs applied:** <packs>
**Evidence checked:** the exact files, help output, tests, and configs inspected
**Coverage limits:** what could not be verified, and why

### P1
- `path:line` Finding.
  Why it matters: ...
  Required change: ...

### P2
### P3

### Known / in-flight
- Already fixed on open PR #<n>, verified against the diff. Excluded from the counts.

### Required verification
Commands that would settle each unverified claim.
```

**Coverage limits can never be omitted.** An empty section is itself a claim — that everything was checked — so it has to be made deliberately. If there are no findings, say `No findings.` and still list residual risks.

### Every finding carries a concrete fix

`Required change` names the file to edit, the guard to write, the test to add, or the sentence to reword — with the replacement wording. "Consider improving the documentation" is not a required change; it is the finding restated as advice, and it is what a reader skips. If you cannot name the change, you have not finished the finding.

### Verify the report before you send it

Do not trust your own earlier notes at face value. Before writing:

- **Re-check every Unsupported.** Confirm a concept search actually happened, not just a grep on your own vocabulary. This is the most damaging error this skill can make.
- **Confirm every finding carries evidence** — a `file:line`, or an explicit searched-and-found-nothing note naming what was searched. Drop any finding that does not.
- **Re-verify each in-flight claim against the actual diff.**
- **Check that severities follow the definitions above**, rather than from how strongly the finding is worded.

---

## Step 6: Launch plan (launch mode)

Audit first (Steps 0 through 4), then produce a plan before writing anything.

### Present the plan

```markdown
## Launch Plan — <repo>

**Product shape:** <shape>  ·  **Packs:** <packs>
**Blocking now:** the P1s that must clear before this can go public

### Will create
| File | From | Why |
|---|---|---|
| `CONTRIBUTING.md` | `templates/CONTRIBUTING.md` | No contribution path exists |

### Will rewrite
| File | Change |
|---|---|

### Yours to do (I cannot)
- Flip the repository public
- Upload the social preview image (no API for it)
- <anything needing credentials or a human decision>

### Recommended, not included
- <suggestions with the skill that does each — see Toolbox>
```

Get approval. Then write only what was approved.

### README templates

Match the product shape. Each is a skeleton with the sections that shape needs, not prose to paste unedited.

| Shape | Template |
|---|---|
| `cli` | [`templates/readme/cli.md`](templates/readme/cli.md) |
| `library` | [`templates/readme/library.md`](templates/readme/library.md) |
| `service` | [`templates/readme/service.md`](templates/readme/service.md) |
| `agent-skill` | [`templates/readme/agent-skill.md`](templates/readme/agent-skill.md) |
| `app` · `game-or-narrative` | [`templates/readme/app.md`](templates/readme/app.md) |

Fill them from the Step 1 contract, never from guesswork. A template section you cannot fill from evidence gets deleted, not padded.

### Supporting files

[`templates/`](templates/) also carries `CONTRIBUTING.md`, `SECURITY.md`, `CODE_OF_CONDUCT.md`, `.gitattributes`, a pull request template, and issue forms. Copy only what the chosen packs call for.

### When a template is not on disk

A single-file install of `SKILL.md` has no `templates/` directory. Fetch the one you need:

```
https://raw.githubusercontent.com/conorbronsdon/repo-audit/main/templates/<path>
```

If it cannot be fetched, say which files you could not read under Coverage limits and stop short of writing them. Writing a `CONTRIBUTING.md` or a README from memory of what the template probably said produces a file the user believes was generated from a reviewed skeleton and was not.

### After writing

1. Re-run the audit against what you wrote. Templates make claims; verify them the same as any other.
2. Run a prose pass (see Toolbox).
3. Report files created, files changed, and every claim still unverified.

---

## Toolbox

This skill deliberately stops at its edges. Where a gap needs a different tool, name it rather than half-doing the job.

| Gap | Reach for |
|---|---|
| Prose reads like AI wrote it | [`avoid-ai-writing`](https://github.com/conorbronsdon/avoid-ai-writing) — pattern categories plus a detector engine |
| No demo GIF, or a stale one | [`demo-gif-skill`](https://github.com/conorbronsdon/demo-gif-skill) — picks vhs or Playwright, commits a regenerable recording script |
| A fact is copied across many docs and drifting | [`ssot-check`](https://github.com/conorbronsdon/ssot-check) — canonical-value manifest, hook, and Action |
| The repo publishes benchmark numbers | [`eval-integrity`](https://github.com/conorbronsdon/eval-integrity) — credibility audit across seven dimensions |
| The repo ships an agent skill that needs writing or migrating | [`agent-skill-builder`](https://github.com/conorbronsdon/agent-skill-builder) |
| Deep README rewrite against source | [`readme-audit`](https://github.com/nnennandukwe/skills/tree/main/skills/readme-audit) and `readme-creation` by Nnenna Ndukwe |
| Reviewing a pull request diff | a code-review skill — this one audits repositories, not changes |

---

## When NOT to use this skill

- **A pull request diff** → a code-review skill.
- **Prose quality alone** → a writing-quality skill.
- **A single fact copied across documents** → an SSOT drift checker.
- **Deciding whether to open-source at all** → that is a judgment call, not a checklist.

---

## Credit

The audit structure adapts [`readme-audit`](https://github.com/nnennandukwe/skills/tree/main/skills/readme-audit) and [`dx-audit`](https://github.com/nnennandukwe/skills/tree/main/skills/dx-audit) by [Nnenna Ndukwe](https://github.com/nnennandukwe), used under Apache-2.0: a severity taxonomy without numeric scores, the mandatory *Evidence checked* and *Coverage limits* sections, sources-before-README ordering, the enforcement-versus-guidance gate, and the rule that a repo-local checklist outranks generic best practice.

The repository records this in [`NOTICE`](NOTICE); the license text is at [`LICENSE`](LICENSE). If you redistribute this skill file on its own, carry both.
