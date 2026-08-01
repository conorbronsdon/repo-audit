<div align="center">

# repo-audit

Audit a repo against its own code, or get it ready to open-source.

[![GitHub stars](https://img.shields.io/github/stars/conorbronsdon/repo-audit?style=social)](https://github.com/conorbronsdon/repo-audit/stargazers)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=flat-square)](LICENSE)
[![X](https://img.shields.io/badge/X-@ConorBronsdon-black?style=flat-square&logo=x)](https://x.com/ConorBronsdon)

<img src="docs/demo.gif" alt="repo-audit reading its own worked example: the bottom line, a P1 finding where a stated guarantee has no mechanism behind it, and the checks that came back clean" width="800">

<sub>Recorded from <a href="docs/demo.tape">docs/demo.tape</a> with <a href="https://github.com/charmbracelet/vhs">vhs</a> — re-render it when the output changes.</sub>

</div>

---

An agent skill with two modes.

| Mode | Question | What it does |
|---|---|---|
| **Audit** | Is everything this repo claims about itself true? | Reads your source, tests, hooks, and CI **before** your README, then reports `P1`/`P2`/`P3` findings with the evidence it checked and what it could not verify. |
| **Launch** | What stands between this and a release people can adopt? | Audits first, proposes a plan, and on approval writes the README and supporting files your chosen checklist packs call for. |

It runs in [Claude Code](https://docs.anthropic.com/en/docs/claude-code), Codex, or any [agentskills.io](https://agentskills.io)-compatible agent that reads a skill directory. No dependencies, nothing to run in CI.

## The check that does most of the work

Most documentation tools grade prose. This one asks whether your claims are true, and one gate does most of the work:

> For every claim that something is **prevented, blocked, refused, or guaranteed**, find the mechanism.

| Backed by | Verdict |
|---|---|
| A hook, CI job, test, or validator that fails closed | **Enforced** — the claim stands |
| A warning that prints but does not block | **Advisory** — reword it |
| A sentence telling an agent not to do it | **Guidance** — not enforcement |
| Nothing | **Unsupported** — `P1` |

From the first repo this ran against: a memory tool whose README said *"the dream commands refuse to push."* The mechanism was an instruction to a model in a markdown file, plus an install-time warning that printed and continued. No hook, no CI. On a tool whose whole pitch is keeping private data local, a reader could reasonably believe pushing was impossible when it was one command away.

It checks **scope** too, not just existence. A guard that scans one directory does not back a claim about the whole build. It catches the inverse case as well: a mechanism that still exists but no longer runs. Those rot quietly, because a step that never executes never fails.

## Checklist packs

Packs are opt-in, because an audit that files findings you will never act on teaches you to ignore the report. A private internal tool does not need community health files.

| Pack | Apply when |
|---|---|
| [Core](checklists/core.md) | Always — license, description, line endings, hygiene |
| [Open source](checklists/open-source.md) | Going public: contribution path, security policy, conduct, issue forms |
| [Release](checklists/release.md) | Shipping versioned artifacts — tags, packages, binaries |
| [Agent readiness](checklists/agent-readiness.md) | Agents will work here, or the repo ships skills |
| [Distribution](checklists/distribution.md) | Anyone is meant to find it |
| [Safety gates](checklists/safety-gates.md) | **Mandatory before any public flip** |

A checklist your repo already ships outranks all of these. Repo-local expectations beat received best practice.

## README templates

Launch mode picks by product shape, because a CLI README and a game README should not look alike.

[`cli`](templates/readme/cli.md) · [`library`](templates/readme/library.md) · [`service`](templates/readme/service.md) · [`agent-skill`](templates/readme/agent-skill.md) · [`app` / `game-or-narrative`](templates/readme/app.md)

They are skeletons, filled from your code. A section that cannot be filled from evidence gets deleted rather than padded.

[`templates/`](templates/) also carries `CONTRIBUTING.md`, `SECURITY.md`, `CODE_OF_CONDUCT.md`, a PR template, issue forms, and a `.gitattributes`.

## What you get

```
## Repo Audit — <repo>

**Bottom line:** could a stranger clone this and use it?

**Audited at:** <sha>, <branch>, fetched yes
**Product shape:** cli
**Packs applied:** core, open-source, safety-gates
**Evidence checked:** the exact files, help output, tests, and configs read
**Coverage limits:** what could not be verified, and why

### P1
- `path:line` Finding.
  Why it matters: ...
  Required change: ...
```

**Coverage limits can never be omitted.** An empty section is itself a claim — that everything was checked — so it has to be made deliberately.

## Install

Install the whole directory. `SKILL.md` alone is not enough — launch mode reads `checklists/` and `templates/` from disk beside it.

```bash
# Claude Code (project)
mkdir -p .claude/skills/repo-audit && curl -fsSL \
  https://github.com/conorbronsdon/repo-audit/archive/refs/heads/main.tar.gz \
  | tar -xz --strip-components=1 -C .claude/skills/repo-audit

# Codex
mkdir -p .agents/skills/repo-audit && curl -fsSL \
  https://github.com/conorbronsdon/repo-audit/archive/refs/heads/main.tar.gz \
  | tar -xz --strip-components=1 -C .agents/skills/repo-audit
```

Use `~/.claude/skills/` for a global install, or `git clone` if you want history.

If you install `SKILL.md` on its own anyway, the skill fetches each missing checklist and template from `raw.githubusercontent.com` at the moment it needs one, and reports the ones it could not fetch under Coverage limits rather than proceeding as if they said nothing.

## First use

```
Audit this repo with repo-audit — I'm about to make it public.
```

```
Use repo-audit to prepare this for open source. It's a CLI.
```

Audit mode reports and stops. Launch mode shows you a plan and waits. Neither edits, commits, or pushes until you say so, and neither will flip a repository public. That switch stays yours.

## What it does not do

- **Grade your prose.** Pair it with [`avoid-ai-writing`](https://github.com/conorbronsdon/avoid-ai-writing); this skill will not grow a second hype-word list.
- **Review a diff.** It audits repositories, not changes.
- **Run your tests.** It reads what your gates check; it does not execute them.
- **Score you out of 100.** A number invites arguing with the number instead of the finding.

The skill's Toolbox section names the tool for each gap it deliberately leaves: demo GIFs, SSOT drift, benchmark credibility, skill authoring.

## Design notes

Three guards exist because each failure happened in practice:

- **Step 0 fetches before reading.** An audit of a stale checkout invents findings that were fixed weeks ago and states them with confidence. It also checks open pull requests before calling anything missing.
- **The product-shape exception.** The language gates assume a developer tool and misfire on games and consumer apps, where evocative prose is correct. Filing that finding costs the reader's trust in every other finding.
- **Launch mode proposes before it writes.** Generating a dozen boilerplate files unasked is how a repo ends up with an unstaffed code of conduct pointing at an unattended inbox.

## Credit

The audit structure adapts [`readme-audit`](https://github.com/nnennandukwe/skills/tree/main/skills/readme-audit) and [`dx-audit`](https://github.com/nnennandukwe/skills/tree/main/skills/dx-audit) by [Nnenna Ndukwe](https://github.com/nnennandukwe), used under Apache-2.0: a severity taxonomy without numeric scores, the mandatory *Evidence checked* and *Coverage limits* sections, reading sources before the README, the enforcement-versus-guidance gate, and repo-local expectations outranking generic best practice. Her rule that a report must say what it could not verify, and that an empty coverage section is itself a claim, is the part that changed how this one works.

## About

Built by [Conor Bronsdon](https://conorbronsdon.com/?utm_source=github&utm_medium=referral&utm_campaign=repo-readme&utm_content=repo-audit). I host the [Chain of Thought](https://chainofthought.show/?utm_source=github&utm_medium=referral&utm_campaign=repo-readme&utm_content=repo-audit) podcast on AI infrastructure and developer tools. More tools: [ai-tools-for-creators](https://github.com/conorbronsdon/ai-tools-for-creators).

---

## Disclaimer

*This is an independent personal project, not affiliated with, sponsored by, or endorsed by any company. All views expressed are my own.*

## License

MIT (see [`LICENSE`](LICENSE)).

The adapted Apache-2.0 material described under [Credit](#credit) is recorded in [`NOTICE`](NOTICE), and the license it is used under is at [`licenses/Apache-2.0.txt`](licenses/Apache-2.0.txt).
