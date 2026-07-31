# Example: auditing `agent-memory-kit`

A real audit run, kept as the worked example. The repository is public, so every finding below can be checked.

---

## Repo Audit — agent-memory-kit

**Bottom line:** a stranger could clone this and use it; every factual claim in the README holds except one, where a stated guarantee is guidance rather than enforcement.

**Audited at:** `1170492`, `main`, fetched yes
**Product shape:** `agent-skill`
**Packs applied:** core, agent-readiness, safety-gates
**Evidence checked:** `commands/` (5 files), `prompts/` (2 files), `init.sh`, `docs/` (4 files), `examples/`, `context-starter/`, `README.md`
**Coverage limits:** `init.sh` was read, not executed — the printed output in the README was verified against its `echo` statements at `init.sh:53`, `:83`, and `:109` rather than by running it. The `/dream` and `/end` commands were not exercised against a live agent, so their behavior is verified as *written*, not as *observed*.

### P1

- `README.md:145` — "Keep the memory repo **local-only** if it holds anything private. No remote. The dream commands refuse to push."

  **Why it matters:** the mechanism is a prompt instruction (`commands/dream-apply.md:79`, "Never push memory git anywhere. If a remote exists, refuse and ask the user to remove it") plus a non-blocking warning (`init.sh:113-115`, which prints `WARNING: memory repo has a remote configured` and continues). No hook, no CI, no pre-push guard. Under the enforcement gate this is **Guidance**, not **Enforced**. For a tool whose stated purpose is keeping private memory local, a reader can reasonably conclude that pushing is impossible when it is one `git push` away.

  **Required change:** either add a real mechanism (a `pre-push` hook installed by `init.sh` is the cheap version) or reword to match what exists: "the dream commands will not push, and `init.sh` warns if a remote is configured — but nothing blocks a manual push."

### P2

None.

### P3

None.

### Verified as accurate

Recorded because a clean result is a finding too:

| Claim | Checked against |
|---|---|
| "Five slash commands" | 5 files in `commands/` |
| "Two curators ship today: `rot` and `lint`" | `prompts/rot.md`, `prompts/lint.md` |
| `init.sh` flags for global install and external memory dir | `--path`, `--force`, `--help`, `--commands`, `--memory-dir` |
| The sample `init.sh` output block | `init.sh:53`, `:83`, `:109` |
| All four `docs/` links | files present |
| In-page anchors `#quickstart`, `#memory-directory-resolution` | headings present |

### Required verification

- `bash init.sh --path <tmp>` in a scratch directory, to confirm the printed output matches the README exactly
- `git -C <memory dir> push` after `init.sh`, to confirm nothing blocks it — this is the check that settles the P1

---

## What this example is here to show

The audit found one thing, and it was the thing a reader would most reasonably get wrong. Everything else in that README is true, which is unusual and worth stating plainly rather than padding the report to look thorough.

An earlier pass on this same repository produced a confident P1 about a stale disclaimer. The disclaimer had already been fixed; the local clone was four commits behind. That failure is why Step 0 exists.
