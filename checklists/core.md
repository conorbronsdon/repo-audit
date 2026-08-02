# Core

Always applies. Nothing here is optional for a repo anyone else will read.

- [ ] **LICENSE present.** A public repo with no license is all-rights-reserved — nobody may legally use or fork it. `P1`.
- [ ] **The license fits what the repo actually is.** Permissive licenses are not interchangeable, and the wrong one is a silent mismatch rather than an error:
  - **Code that others will depend on** — a library, a server, a CLI. Apache-2.0 carries a patent grant with a retaliation clause and defines inbound contribution terms, which is why enterprise review prefers it for dependencies. MIT grants no patent rights at all.
  - **A small single-purpose repo.** MIT. Two hundred lines of license on a three-file repo is noise, and a patent grant over prose does nothing.
  - **Curated lists, datasets, and reference content.** This is data, not software. A software license makes a claim it cannot support; CC-BY-4.0 is the honest fit and the ecosystem norm for awesome-lists.
  - **A derivative of someone else's work.** Matching the upstream license removes the burden of explaining which parts fall under which terms. A mixed-license repo is legal and still costs every reader an explanation. `P2`.
- [ ] **Credit expectations match the license, not the intention.** MIT already requires redistributors to keep the copyright notice — "I want credit" is not a reason to move off it. Apache-2.0 adds NOTICE propagation into derivatives (§4d) and a state-your-changes requirement (§4b); those are the reasons to move. If the repo wants credit that neither license compels, that belongs in a Credit section and in community norms, not in a license the author is misreading. `P3`.
- [ ] **Relicensing is forward-only.** Every published version stays under the license it shipped with, and anyone who already forked keeps those rights. On a repo with existing forks or outside contributors, a relicense buys confusion rather than protection — flag the intent, do not assume it is achievable. `P2`.
- [ ] Repository description set, and it says what the software does rather than what you are doing to it ("Building an app for X" describes your week, not the product)
- [ ] Homepage field set if a live URL or docs site exists
- [ ] `.gitattributes` with `* text=auto eol=lf`, and `binary` for images and GIFs
- [ ] `.gitignore` covers build output for every platform you build on — a Windows `.exe` is not matched by a bare `/name`
- [ ] README answers the eight spine questions (SKILL.md Step 2)
- [ ] Every command in the README verified against current help or source
- [ ] Derived or vendored material carries the notices its upstream license requires — the license text, retained attribution, and any upstream `NOTICE`. Apache-2.0 §4 asks for a copy of the license and the notices, so a line of credit in the README satisfies neither. Check every "adapted from," "based on," and vendored file. `P1`.
- [ ] No stale affiliation or employer disclaimer asserting a relationship that has ended. `P1`.
- [ ] Default branch is the one you actually develop on
