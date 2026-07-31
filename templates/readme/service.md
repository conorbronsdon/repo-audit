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

## License
