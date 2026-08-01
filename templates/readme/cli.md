<!-- README template — CLI. Fill from evidence. Delete any section you cannot fill. -->

# <name>

<One sentence: `<Tool>` does <exact thing> for <who or what>. Familiar nouns, concrete verb, no internal vocabulary.>

## Install

<The current path, per platform you actually ship. Commands must be copy-safe.>

## Usage

```bash
<the single most common invocation>
```

<What it prints, what files it changes, what exit code it returns.>

| Command | Does | Changes on disk |
|---|---|---|

## Exit codes

| Code | Meaning |
|---|---|
| 0 | Success |

## What it does not do

<The boundary. Prevents the most likely category error.>

## What's enforced

<Only if something above is described as prevented, blocked, refused, required, or guaranteed.
 One row per claim; delete the section if there are none. An empty table reads as "nothing holds."
 Enforced = a hook, CI job, test, validator, or type that fails closed.
 Advisory = it warns and continues. Guidance = a sentence asking someone not to.>

| Claim | Mechanism | Verdict |
|---|---|---|
| <the claim, worded as it appears above> | <`path:line` of the gate> | Enforced / Advisory / Guidance |

## Configuration

<Flags and environment variables that change behavior. Link exhaustive reference elsewhere.>

## License
