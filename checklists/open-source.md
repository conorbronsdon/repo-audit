# Open source

The repo is going public, or already is. These make the difference between code someone can read and a project someone can join.

- [ ] A contribution path exists — how to set up, what a good PR looks like, what will be rejected — **and it lives in a file GitHub links from the PR and issue UI**: `CONTRIBUTING.md` at the root, in `.github/`, or in `docs/` (`templates/CONTRIBUTING.md`). A good Contributing section in the README is content in the wrong file, not a missing contribution path, and the finding is "move it, keep it" rather than "write one." Say which, because the second is a much larger ask and a maintainer who already wrote the content will read it as the audit not having looked.
- [ ] `SECURITY.md` — how to report a vulnerability privately, and what response to expect (`templates/SECURITY.md`)
- [ ] `CODE_OF_CONDUCT.md` and a real enforcement contact (`templates/CODE_OF_CONDUCT.md`)
- [ ] Issue templates — bug, feature, question (`templates/github/ISSUE_TEMPLATE/`)
- [ ] Pull request template (`templates/github/PULL_REQUEST_TEMPLATE.md`)
- [ ] Funding metadata on owned repos only — **never on a fork**, where it redirects sponsorship away from the maintainer
- [ ] `good first issue` and `help wanted` labels applied only to issues that are
- [ ] The scope boundary is written down: what this project will not accept, so contributors do not build the wrong thing
- [ ] A `CHANGELOG.md`, or a stated reason there is none

**Do not** add community health files to a repo nobody can contribute to yet. An unstaffed CODE_OF_CONDUCT with no contact is worse than none.
