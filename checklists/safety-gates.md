# Safety gates

**Mandatory before any public flip.** Any hit is `P1` and blocks the flip. These are hard exits, not advisory.

- [ ] **Build the pattern, do not brainstorm it.** The names worth grepping for are the ones you would not think to type. Under a known owner they are enumerable, so start there:

```bash
gh repo list <owner> --visibility private --limit 200 --json name --jq '[.[].name] | join("|")'
```

  That alternation is the high-value half of the pattern, derived rather than remembered. Add the org, employer, and client names by hand — those are not in the list — and keep the derived half first, because a private repo name in a doc is the leak nobody guesses at. If `gh` is unavailable, say so under Coverage limits: a hand-written pattern covers what you thought of, which is not the same scan.

- [ ] **Two-pass leak scan**, second pass by different eyes than the first, using the pattern above:

```bash
grep -rniE "<derived-private-repo-names>|<internal-org>|<employer>" .
grep -rniE "(api[_-]?key|secret|token|password)[\"' ]*[:=]" .
```

- [ ] Scan **history**, not just the working tree — a secret removed in a later commit is still published:

```bash
git log -p | grep -niE "(api[_-]?key|secret|token|password)[\"' ]*[:=]" | head
```

- [ ] **Scan the metadata, not only the files.** The two-pass scan above reads the tree; commit messages, branch names, tags, and PR and issue text are none of those. This is a real failure mode, not a hypothetical: a commit message named a private repository and summarized a private repo inventory while the tree it described was clean, so every file-level pass came back green.

```bash
git log --format='%B' --all | grep -niE "<derived-private-repo-names>|<internal-org>|<employer>"
git branch -a && git tag -l
gh pr list --state all --json title,body --limit 200
gh issue list --state all --json title,body --limit 200
```

Tune the pattern to the same names as the first pass. Check the PR and issue output by eye as well — a private repo name is easy to grep for, a description of private work is not.

- [ ] **Metadata leaks must clear before the flip, not after.** Editing the file fixes the file; the commit message that leaked it survives untouched, and removing it means rewriting history and force-pushing — which does not reach a fork, a clone, or `refs/pull/*`. Once the repo is public there is no clean fix. `P1`.
- [ ] No links to private repositories on pages that will be public — they render as 404s to everyone but you
- [ ] No internal architecture, headcount, roadmaps, or customer names in docs, commit messages, branch names, or PR descriptions
- [ ] `.env`, credential files, and local config are ignored **and** absent from history
- [ ] Content-hold check: is any announcement gated on something unresolved — an embargo, a signature, a legal review?
- [ ] Contributor licensing is settled if anyone else has committed

A repo cannot be un-published. Treat every item here as blocking.
