{
  ...
}:
{
  home-manager.users."*".programs.opencode = {
    settings.lsp = true;

    agents.discuss = ./ai/agents/discuss.md;

    skills.code-comments = ./ai/code-comments;

    context = ''
      ## Comments
      Default to no comment. When one's needed, state the contract (what's
      promised), not the mechanism (how it's built) — and make sure it'd read
      the same for any caller, not just the one in front of you. Never explain
      implementation, name a specific caller/ticket/date, or narrate a decision
      inline; that goes in docs instead. Full standard: ~/.config/opencode/skills/code-comments/SKILL.md
    '';
  };
}
