{ ... }:
{

  home-manager.sharedModules = [
    (
      {
        config,
        lib,
        ...
      }:
      {
        programs.mistral-vibe.settings = {
          theme = "auto";
          active_model = "mistral-large-4";
          show_thinking_nodes = true;
        };

        home.file = lib.mkIf config.programs.mistral-vibe.enable {
          ".vibe/AGENTS.md".source = ./ai/context.md;

          ".vibe/skills/" = {
            source = ./ai/skills;
            recursive = true;
          };
        };
      }
    )
  ];
}
