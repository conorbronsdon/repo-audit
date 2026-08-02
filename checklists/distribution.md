# Distribution

Anyone is meant to find this.

- [ ] README opens with what it does, above the fold, before badges push it down
- [ ] Demo GIF or screenshot near the top with real alt text describing what happens, not "demo"
- [ ] The recording script is committed so the GIF regenerates instead of rotting

**Product-shape exception, same principle as SKILL.md Step 2.** For `library` and `service` shapes with no TTY surface — an MCP server speaking JSON-RPC over stdio, a request-response API — a worked request and its real response satisfies the demo item. A recording of the wire format shows a JSON blob scrolling past, which demonstrates nothing a reader wanted to know.

This is not an exemption from having a demo. The artifact has to **show the value, not the protocol**: a GIF of a human-readable wrapper — the client that calls the server, the script that consumes the library — is usually achievable and is better than the code block. What is exempt is the raw protocol recording, not the obligation to show the thing working.
- [ ] Topics set — this is most of how GitHub search finds a repo
- [ ] Social preview image, 1280x640 (**manual upload; GitHub has no API for it**)
- [ ] Listed where it fits: awesome-lists, registries, your own site. A bad-fit listing is spam.
- [ ] Cross-linked from related repos where natural
- [ ] The first sentence works as a search result on its own, with no surrounding page
