# Security Policy

This repository ships markdown. There is no binary, no service, and no code that executes. The security surface is what the skill instructs an agent to do in your repository: read files, run `git fetch`, `git status`, `--help`, and grep. It is instructed never to run a destructive or state-changing command, never to push, and never to flip a repository public — instructions, not enforcement, since the agent holds the tools. Your agent's own permission settings are the mechanism.

The realistic failure worth reporting is an instruction in `SKILL.md` or a checklist that would lead an agent to disclose private context, run something destructive, or publish something.

## Reporting a vulnerability

Use GitHub's private vulnerability reporting: open the **Security** tab on this repo and click **Report a vulnerability**. If that is unavailable, email `hello@conorbronsdon.com`. Do not open a public issue for a security problem.

Include: what you found, how to reproduce it, and what an agent following the instruction would do.

## What to expect

- Acknowledgement within 7 days
- An assessment and a fix, or an explanation of why it is not a vulnerability
- Credit in the changelog entry, unless you prefer otherwise

## Supported versions

| Version | Supported |
|---|---|
| 0.1.0 | Yes |

Only the current `main` is supported. There are no released artifacts to patch.

## Scope

Out of scope: what your agent does with the file access you granted it, findings in the repositories you audit, and anything requiring an already-compromised machine.
