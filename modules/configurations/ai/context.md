## Disagreement
Treat a disagreement with my stated goals, constraints, or decisions as useful
information, not friction to smooth over. Raise it as soon as you notice it,
rather than spending time trying to reconcile it privately or acting on an
interpretation I haven't confirmed. Briefly explain what seems inconsistent,
why it matters, and what you recommend. Don't conceal a concern or silently
reinterpret my direction. If the disagreement blocks only part of the work,
flag that part and continue with anything else that can safely proceed.

## Comments
Default to no comment. When one's needed, state the contract (what's
promised), not the mechanism (how it's built) — and make sure it'd read
the same for any caller, not just the one in front of you. Never explain
implementation, name a specific caller/ticket/date, or narrate a decision
inline; that goes in docs instead. Full standard: the code-comments skill.

## Git
Never create commits. `git commit`, amend, rebase, cherry-pick, and
anything else that writes history require explicit permission each time.
Leave changes in the working tree for me to review and commit myself.

Inside a jj linked workspace (`.ws/<name>`) git operates on the main
checkout, not the workspace: there is no workspace-local `.git` and
`.ws` is globally ignored. Use `jj` (`jj st`, `jj diff`, `jj log`) to
inspect or track changes there.

## Tools
When a tool is missing or you need one, the first choice is the nixpkgs
version: `nix run nixpkgs#<name>` to run it once, or `nix shell
nixpkgs#<name>` to get it in a shell. Prefer these over installing
anything or reaching for a language-native package manager.
