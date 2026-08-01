# Regenerates docs/demo.gif. Render from the repo root:
#   "$LOCALAPPDATA/Microsoft/WinGet/Packages/charmbracelet.vhs_.../vhs" docs/demo.tape
# vhs runs the commands inside the default WSL distro's bash, so paths are /mnt/c/...
Output docs/demo.gif
Set Shell bash
Set FontSize 15
Set Width 1200
Set Height 760
Set Theme "Monokai Pro"
Set Padding 18
Set TypingSpeed 28ms

Hide
Type "cd /mnt/c/Users/conor/repo-audit && clear" Enter
Show

Type "# repo-audit ships its own audit of a public repo as the worked example"
Enter
Sleep 1200ms
Type "sed -n '7,15p' examples/agent-memory-kit-audit.md"
Enter
Sleep 4500ms

Type "clear" Enter
Type "# the finding: a stated guarantee that nothing actually enforces"
Enter
Sleep 1200ms
Type "sed -n '17,21p' examples/agent-memory-kit-audit.md"
Enter
Sleep 5500ms

Type "clear" Enter
Type "# a clean result is a finding too, so it is recorded"
Enter
Sleep 1000ms
Type "sed -n '33,44p' examples/agent-memory-kit-audit.md"
Enter
Sleep 5000ms
