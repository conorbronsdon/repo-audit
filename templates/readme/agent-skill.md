<!-- README template — agent skill. Fill from evidence. Delete any section you cannot fill. -->

# <name>

<One sentence: what the skill makes an agent do, and what it produces.>

<Which agents: Claude Code, Codex, Cursor, OpenCode, agentskills.io-compatible.>

## What it produces

<The exact output — a report, edited files, a generated artifact. Show its shape.>

## Install

```bash
# project
mkdir -p .claude/skills/<name> && cp SKILL.md .claude/skills/<name>/

# other agents
mkdir -p .agents/skills/<name> && cp SKILL.md .agents/skills/<name>/
```

## First use

```
<the sentence a user types to invoke it>
```

<What it does, and crucially what it does NOT do without being asked — edit, commit, push.>

## What it does not do

<Where it stops, and what to reach for instead.>

## What's enforced

<Only if something above is described as prevented, blocked, refused, required, or guaranteed —
 "it will not commit," "it never pushes," "it stays read-only." One row per claim; delete the
 section if there are none. An empty table reads as "nothing holds."
 A skill file instructing the model is Guidance, however forcefully worded. Enforced needs a
 hook, CI job, test, or validator that fails closed. Advisory warns and continues.>

| Claim | Mechanism | Verdict |
|---|---|---|
| <the claim, worded as it appears above> | <`path:line` of the gate> | Enforced / Advisory / Guidance |

## License
