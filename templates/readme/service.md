<!-- README template — service or daemon. Fill from evidence. Delete any section you cannot fill. -->

# <name>

<One sentence: `<Service>` accepts <input> and returns, stores, or emits <output>.>

## Run it

```bash
<the shortest path to a running instance>
```

## Interface

| Endpoint or event | Accepts | Returns | Side effects |
|---|---|---|---|

## Configuration

| Variable | Required | Default | Effect |
|---|---|---|---|

## Operating requirements

<State it stores, what it needs to reach, what happens on restart. What it does when a dependency is down.>

## Failure behavior

<What it does under load, on bad input, on partial outage. Retries, timeouts, backpressure.>

## Observability

<What it logs and exposes. How an operator knows it is healthy.>

## Security

<AuthN/AuthZ, what it trusts, what it never accepts.>

## What's enforced

<Only if something above is described as prevented, blocked, refused, required, or guaranteed —
 rate limits, auth, "never accepts." One row per claim; delete the section if there are none.
 An empty table reads as "nothing holds."
 Enforced = a hook, CI job, test, validator, middleware, or type that fails closed.
 Advisory = it warns and continues. Guidance = a sentence asking someone not to.>

| Claim | Mechanism | Verdict |
|---|---|---|
| <the claim, worded as it appears above> | <`path:line` of the gate> | Enforced / Advisory / Guidance |

## License
