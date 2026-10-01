{
  ...
}:
{
  home-manager.users."*".programs.opencode = {
    settings.lsp = true;

    agents.discuss = ./ai/agents/discuss.md;

    skills.code-comments = ./ai/code-comments;

    context = ''
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
      inline; that goes in docs instead. Full standard: ~/.config/opencode/skills/code-comments/SKILL.md
    '';
  };
}
