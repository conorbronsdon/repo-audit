# MCP server

**Trigger:** the repo ships a Model Context Protocol server. `server.json` at the root, or `@modelcontextprotocol/sdk` in `dependencies`.

An MCP server is installed by pasting a config block into a client and restarting it. The client reports a failure as "server disconnected" and nothing else, so a packaging defect that any other project would surface as a build error surfaces here as a tool that silently is not there. Every item below is about the gap between what the README tells someone to paste and what actually resolves.

- [ ] **The install block in the README resolves.** A config that runs `npx -y <pkg>` against a name that is not on the registry fails for every reader, and it fails after they have already edited their client config. Check it, do not read it:

```bash
npm view <package-name> version
```

  A 404 here is `P1`. The same applies to an npm version badge — `img.shields.io/npm/v/<pkg>` renders as a broken "invalid" pill for a package that does not exist, which is the first thing on the page. **A repo not yet published leads with the local path config** — `node /absolute/path/to/dist/index.js`, with a sentence saying `npx` replaces it once the package is on npm — rather than shipping a command that documents a future. `P1`.

- [ ] **`server.json` `name` matches `mcpName` in `package.json`.** The registry validates ownership by reading `mcpName` off the published npm package and comparing it to the name being claimed; a mismatch or a missing field rejects the publish. It is two strings in two files with nothing comparing them, which is the shape every drift takes. `P1`.

- [ ] **`server.json` `version` and every `packages[].version` match `package.json` `version`.** Three copies of one number. A stale `packages[].version` points the registry entry at a tarball that is not the code in the repo, and the client installs the old one without an error. `P1`.

- [ ] **`server.json` validates against the `$schema` it declares**, not just against a reading of it. Argument objects are the trap: `packageArguments` entries carry a discriminator, and an entry missing `"type": "named"` parses as valid JSON, reads as obviously correct, and is rejected on the first publish attempt. Fetch the schema named in the file and validate rather than eyeballing the shape. `P1`.

- [ ] **The publish workflow can perform the *first* publish, not only subsequent ones.** npm Trusted Publishing is configured per-package in the npmjs.com package settings, and a package that has never been published has no settings page to configure. A workflow with `id-token: write` and `--provenance` but no `NODE_AUTH_TOKEN` therefore 404s on run one and works on every run after, so it looks correct in review and fails exactly once — at launch. Either the first publish is done by hand with a token and the workflow takes over after, or the workflow carries a token path for the bootstrap case. Say which in the release notes. `P1`.

- [ ] **Tool results are bounded.** Every tool returns into a context window, so a handler that returns whatever the upstream gave it is a denial of service against the model: one call to an unbounded list or search can consume the budget the conversation needed. Check that each tool caps what it returns — a `limit` parameter with a default and a hard maximum, a date range, a truncation with a stated count of what was dropped. Unbounded dumps are `P2`, or `P1` where the upstream size is unbounded by nature (logs, search, file reads).

## README section this contributes

```markdown
## Install

Add to your client config:

    <the block that actually resolves today — local path until the package is published>

<one line naming what replaces it after the first publish>
```

If the package is not published yet, the README says so in that sentence rather than shipping the `npx` form early. A reader who pastes a config that cannot resolve has no way to tell your bug from theirs.
