---
name: repo-audit
description: Audit a repository before it goes public, ships a release, or gets handed to a coding agent. Checks whether the README matches what the software actually does, whether stated rules are enforced or merely written down, and whether launch requirements are met. Use when asked to "audit this repo," "is this repo ready to go public," "is this ready to ship," "check this README," or before flipping a repo public. Reports by default; edits only when explicitly asked.
license: MIT
compatibility: Requires read access to the repository and a shell for git and grep. Uses the GitHub CLI for repository metadata when available; degrades to local-only checks when it is not.
metadata:
  author: Conor Bronsdon
  tags: [audit, readme, release, documentation, agent-readiness, open-source]
  agentskills_spec: "1.0"
---

# Repo Audit

Answer one question: **would a stranger who cloned this repo be able to use it, and is everything it claims about itself true?**

Three failure modes, and most repos have all three:

1. The README describes software that no longer exists.
2. A rule reads like a guardrail but nothing enforces it.
3. Launch requirements are half-applied — the ones checked at flip time get done, the ones checked never do not.

This skill owns facts, enforcement, and policy. It does not grade prose style; pair it with a writing-quality pass rather than growing a second one here.

---

## Operating Boundary

- **Read-only by default.** Report findings. Do not edit, stage, commit, branch, push, or open a pull request unless explicitly asked.
- A request to "audit" is a request for a report. A request to "fix" authorizes edits to the files named in the findings, nothing else.
- Preserve unrelated worktree changes.
- Never run a destructive or state-changing command to verify a claim. `--help`, `--dry-run`, and reading source are enough.

---

## Step 0: Verify you are auditing current code

**Do this first, every time. An audit of a stale checkout is worse than no audit** — it manufactures findings that were fixed weeks ago and reports them with confidence.

```bash
git fetch -q origin && git status -sb | head -1
```

If the branch is behind, pull before reading anything. If you cannot fetch, say so under Coverage limits and treat every finding as provisional.

Then check open pull requests before reporting anything as missing. A file that arrives in an open PR is not a finding.

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

---

## Step 2: Audit the README against that contract

The spine, in order. A missing answer is a finding — do not excuse it because a later section eventually explains it.

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

These language gates assume a developer tool. **They misfire on games, narrative projects, and consumer apps**, where evocative prose is the correct README. Decide the product shape before applying them.

For a non-developer product, apply the factual gates — commands work, paths exist, claims are true — and drop the literal-noun ones. A game README that opens by setting a scene is not a defect. Filing that finding costs you the reader's trust in every other finding in the report.

---

## Step 3: The enforcement gate

**The check nothing else covers.**

For every claim that something is prevented, blocked, refused, required, or guaranteed — find the mechanism. Then classify it:

| Claim backed by | Verdict |
|---|---|
| A hook, CI job, test, validator, or type that fails closed | **Enforced.** The claim stands. |
| A warning that prints but does not block | **Advisory.** Reword the claim. |
| A sentence in a markdown file telling an agent or human not to do it | **Guidance.** Not enforcement. |
| Nothing found | **Unsupported.** P1. |

Instructions and configuration are not enforcement by themselves. A rule an agent is asked to follow is guidance, however forcefully worded.

Worked example: a memory-management kit whose README states "the dream commands refuse to push." The mechanism was an instruction to a model in a command file, plus a warning at install time that printed and continued. No hook, no CI. A reader could reasonably believe pushing was impossible when it was one command away — on a tool whose entire pitch is keeping private data local.

**Check the scope of the mechanism, not just its existence.** A guard that scans one directory does not back a claim about the whole build. A denylist of named vendors does not back a claim of "no third-party services." When the claim is broader than the check, that gap is the finding.

**Check the inverse too:** a mechanism that exists but no longer runs. A workflow step whose dependency is gone, a hook nobody installed, a gate keyed to a service the owner lost access to. These rot silently, because a step that never executes never fails.

Apply the same test to the repo's own agent rules: every "always" or "never" either names the mechanism that checks it or is marked unenforced.

---

## Step 4: Launch requirements

**A repo-local checklist outranks this section.** If the repository ships its own launch or release checklist, read it first and treat it as the standard; these are defaults for repos that have none. Repo-local expectations beat received best practice.

Mechanically checkable:

```bash
gh repo view OWNER/REPO --json description,homepageUrl,repositoryTopics,licenseInfo,isPrivate
ls LICENSE .gitattributes .github/FUNDING.yml
```

- **LICENSE present.** A public repo with no license is all-rights-reserved: nobody may legally use or fork it. P1.
- Repository description and homepage set; topics set
- `.gitattributes` with `* text=auto eol=lf`
- Funding metadata on owned repositories only — **never on a fork**, where it redirects sponsorship away from the maintainer
- Any required affiliation or independence disclaimer uses current wording. A stale disclaimer asserting a relationship that has ended is P1.
- Social preview image

### Safety gates — hard exit, not advisory

Before any public flip, scan for context that should not travel. Tune the first pattern to the org, employer, and private repository names that apply:

```bash
grep -rniE "<internal-org>|<private-repo-names>" .
grep -rniE "(api[_-]?key|secret|token|password)[\"' ]*[:=]" .
```

- Two passes, the second by different eyes than the first
- No links to private repositories on pages that will be public — they render as 404s to everyone but the owner
- Content-hold check: is any announcement gated on something unresolved?

Any hit is P1 and blocks the flip.

---

## Step 5: Agent readiness

- `AGENTS.md` at root — several agents read it; a repo with only `CLAUDE.md` is invisible to them
- Rules cite their evidence: the file and line that makes them true
- Generated files marked as generated, with the command that regenerates them
- Skill repositories: complete `SKILL.md` frontmatter

---

## Severity

- **P1** — misstates behavior, hides the primary output, gives an invalid command, claims enforcement that does not exist, leaks private context, or blocks a public flip.
- **P2** — audience, downstream use, approval boundary, prerequisite, or canonical artifact is unclear.
- **P3** — wordiness, ordering, or formatting friction that does not change the factual contract.

No numeric scores. A score invites arguing with the number instead of the finding.

---

## Report Format

```markdown
## Repo Audit — <repo>

**Bottom line:** one sentence — could a stranger clone this and use it, and is what it claims true?

**Audited at:** <sha>, <branch>, fetched <yes/no>
**Evidence checked:** the exact files, help output, tests, and configs inspected
**Coverage limits:** what could not be verified, and why

### P1
- `path:line` Finding.
  Why it matters: ...
  Required change: ...

### P2
### P3

### Required verification
Commands that would settle each unverified claim.
```

**Coverage limits can never be omitted.** An empty section is itself a claim — that everything was checked — so it has to be made deliberately. If there are no findings, say `No findings.` and still list residual risks.

---

## Fix Mode

Only when explicitly asked:

1. Complete the audit first.
2. Fix in severity order. Do not bundle unrelated cleanup.
3. Preserve repository-specific requirements you did not fully understand.
4. Re-run the checks that produced each finding.
5. Report files changed and any claim still unverified.

---

## When NOT to use this skill

- **A pull request diff** → a code-review skill.
- **Prose quality alone** → a writing-quality skill.
- **A fact copied across many documents** → an SSOT drift checker.
- **A benchmark repository's credibility** → a benchmark-integrity auditor.

---

## Credit

The audit structure — a severity taxonomy without numeric scores, the mandatory *Evidence checked* and *Coverage limits* sections, sources-before-README ordering, the enforcement-versus-guidance gate, and the rule that a repo-local checklist outranks generic best practice — adapts [`readme-audit`](https://github.com/nnennandukwe/skills/tree/main/skills/readme-audit) and [`dx-audit`](https://github.com/nnennandukwe/skills/tree/main/skills/dx-audit) by [Nnenna Ndukwe](https://github.com/nnennandukwe), used under Apache-2.0.
