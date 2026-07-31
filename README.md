<div align="center">

# repo-audit

Audit a repo before it goes public: does the README match the code, and is anything it calls a guardrail actually enforced?

[![GitHub stars](https://img.shields.io/github/stars/conorbronsdon/repo-audit?style=social)](https://github.com/conorbronsdon/repo-audit/stargazers)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=flat-square)](LICENSE)
[![X](https://img.shields.io/badge/X-@ConorBronsdon-black?style=flat-square&logo=x)](https://x.com/ConorBronsdon)

</div>

---

`repo-audit` reads a repository's source, tests, hooks, and CI **before** its README, then reports what the README gets wrong — as `P1`/`P2`/`P3` findings with the evidence it checked and an explicit list of what it could not verify.

It is a single `SKILL.md` for [Claude Code](https://docs.anthropic.com/en/docs/claude-code), Codex, Cursor, or any [agentskills.io](https://agentskills.io)-compatible agent. No code to install, no dependencies, nothing to run in CI.

## The check that makes it worth running

Most documentation linters grade prose. This one asks whether your claims are true, and one gate does most of the work:

> For every claim that something is **prevented, blocked, refused, or guaranteed** — find the mechanism.

| Backed by | Verdict |
|---|---|
| A hook, CI job, test, or validator that fails closed | **Enforced** — the claim stands |
| A warning that prints but does not block | **Advisory** — reword it |
| A sentence telling an agent not to do it | **Guidance** — not enforcement |
| Nothing | **Unsupported** — `P1` |

Real example from the repo this was first run against: a memory tool whose README said *"the dream commands refuse to push."* The mechanism was an instruction to a model in a markdown file, plus an install-time warning that printed and continued. No hook, no CI. On a tool whose whole pitch is keeping private data local, a reader could reasonably believe pushing was impossible when it was one command away.

It also checks the **scope** of a mechanism, not just its existence — a guard that scans one directory does not back a claim about the whole build — and the inverse case, a mechanism that still exists but no longer runs. Those rot silently, because a step that never executes never fails.

## What you get

```
## Repo Audit — <repo>

**Bottom line:** one sentence — could a stranger clone this and use it?

**Audited at:** <sha>, <branch>, fetched yes
**Evidence checked:** the exact files, help output, tests, and configs read
**Coverage limits:** what could not be verified, and why

### P1
- `path:line` Finding.
  Why it matters: ...
  Required change: ...
```

**Coverage limits can never be omitted.** An empty section is itself a claim — that everything was checked — so it has to be made deliberately.

## Install

Copy `SKILL.md` into your agent's skills directory:

```bash
# Claude Code (project)
mkdir -p .claude/skills/repo-audit && curl -fsSL \
  https://raw.githubusercontent.com/conorbronsdon/repo-audit/main/SKILL.md \
  -o .claude/skills/repo-audit/SKILL.md

# Codex
mkdir -p .agents/skills/repo-audit && curl -fsSL \
  https://raw.githubusercontent.com/conorbronsdon/repo-audit/main/SKILL.md \
  -o .agents/skills/repo-audit/SKILL.md
```

Use `~/.claude/skills/` instead of `.claude/skills/` to install it globally.

## First use

Ask your agent to audit a repo:

```
Audit this repo with repo-audit — I'm about to make it public.
```

It reports and stops. It does not edit, commit, or push unless you separately ask it to fix what it found.

## What it does not do

- **Grade your prose.** Pair it with a writing-quality pass; this skill will not grow a second hype-word list.
- **Review a diff.** Use a code-review skill for a pull request.
- **Run your tests.** It reads what your gates check, it does not execute them.
- **Score you out of 100.** A number invites arguing with the number instead of the finding.

## Design notes

Three guards exist because each failure happened in practice:

- **Step 0 fetches before reading.** An audit of a stale checkout invents findings that were fixed weeks ago and states them with confidence. It also checks open pull requests before calling anything missing.
- **The product-shape exception.** The language gates assume a developer tool and misfire on games, narrative projects, and consumer apps, where evocative prose is the correct README. Filing that finding costs the reader's trust in every other finding.
- **A repo-local checklist outranks the defaults.** If your repository ships its own release checklist, that is the standard; the built-in launch requirements are for repos that have none.

## Credit

The audit structure — a severity taxonomy without numeric scores, the mandatory *Evidence checked* and *Coverage limits* sections, reading sources before the README, the enforcement-versus-guidance gate, and repo-local expectations outranking generic best practice — adapts [`readme-audit`](https://github.com/nnennandukwe/skills/tree/main/skills/readme-audit) and [`dx-audit`](https://github.com/nnennandukwe/skills/tree/main/skills/dx-audit) by [Nnenna Ndukwe](https://github.com/nnennandukwe), used under Apache-2.0. Her framing — that an audit report must say what it could not verify, and that an empty coverage section is itself a claim — is the part that changed how this one works.

## About

Built by [Conor Bronsdon](https://conorbronsdon.com). I host the [Chain of Thought](https://chainofthought.show) podcast on AI infrastructure and developer tools. More tools: [ai-tools-for-creators](https://github.com/conorbronsdon/ai-tools-for-creators).

---

## Disclaimer

*This is an independent personal project, not affiliated with, sponsored by, or endorsed by any company. All views expressed are my own.*

## License

MIT (see [`LICENSE`](LICENSE)).
