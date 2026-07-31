# Agent readiness

Coding agents will work in this repo, or it ships skills for them.

- [ ] `AGENTS.md` at root — several agents read it; a repo with only `CLAUDE.md` is invisible to them
- [ ] Every rule states its evidence: the file and line that makes it true
- [ ] Every "always" or "never" names the mechanism that checks it, **or is explicitly marked unenforced**
- [ ] Generated files marked as generated, with the command that regenerates them
- [ ] Setup that an agent cannot infer is written down: required services, credentials, platform constraints
- [ ] Skill repos: complete `SKILL.md` frontmatter, and a description that says when to invoke rather than what the skill admires about itself
- [ ] Destructive commands are flagged as destructive where an agent will read them
