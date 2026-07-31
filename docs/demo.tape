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
Sleep 1200
Type "sed -n '9,22p' examples/agent-memory-kit-audit.md"
Enter
Sleep 4500

Type "clear" Enter
Type "# the finding: a stated guarantee that nothing actually enforces"
Enter
Sleep 1200
Type "sed -n '24,32p' examples/agent-memory-kit-audit.md"
Enter
Sleep 5500

Type "clear" Enter
Type "# a clean result is a finding too, so it is recorded"
Enter
Sleep 1000
Type "sed -n '38,49p' examples/agent-memory-kit-audit.md"
Enter
Sleep 5000
