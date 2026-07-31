# Safety gates

**Mandatory before any public flip.** Any hit is `P1` and blocks the flip. These are hard exits, not advisory.

- [ ] **Two-pass leak scan**, second pass by different eyes than the first. Tune to the org, employer, client, and private repo names that apply:

```bash
grep -rniE "<internal-org>|<employer>|<private-repo-names>" .
grep -rniE "(api[_-]?key|secret|token|password)[\"' ]*[:=]" .
```

- [ ] Scan **history**, not just the working tree — a secret removed in a later commit is still published:

```bash
git log -p | grep -niE "(api[_-]?key|secret|token|password)[\"' ]*[:=]" | head
```

- [ ] No links to private repositories on pages that will be public — they render as 404s to everyone but you
- [ ] No internal architecture, headcount, roadmaps, or customer names in docs or commit messages
- [ ] `.env`, credential files, and local config are ignored **and** absent from history
- [ ] Content-hold check: is any announcement gated on something unresolved — an embargo, a signature, a legal review?
- [ ] Contributor licensing is settled if anyone else has committed

A repo cannot be un-published. Treat every item here as blocking.
