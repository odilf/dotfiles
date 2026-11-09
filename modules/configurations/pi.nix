{ ... }:
{
  home-manager.sharedModules = [
    (
      {
        config,
        lib,
        pkgs,
        ...
      }:
      let
        agentDir = config.programs.pi-coding-agent.configDir;
      in
      {
        programs.pi-coding-agent = {
          keybindings = {
            "app.editor.external" = "alt+e";
          };

          settings = {
            packages = [
              "npm:@juicesharp/rpiv-todo"
              "npm:@narumitw/pi-btw"
              "npm:@narumitw/pi-caffeinate"
              "npm:@narumitw/pi-usage"
              "npm:@raidou/pi-notify"
              "npm:@zigai/pi-status-bar"
              "npm:pi-claude-bridge"
              "npm:pi-lens"
              # "npm:pi-nono@next"
              "npm:pi-notify"
              "npm:pi-simplify"
              "npm:pi-vim"
            ];

            defaultProvider = "mistral";
            defaultModel = "mistral-large-4";
            defaultThinkingLevel = "high";
            enabledModels = [
              "mistral/mistral-large-4"
              "mistral/zai-glm-5-3"
              "mistral/deepseek-v4-1-flash-1017"
            ];

            showCacheMissNotices = true;
            defaultTools = [ "+codemode" ];

            tuiMode = "regular";
          };

          # For plugin installation
          extraPackages = [
            pkgs.nodejs
            pkgs.pnpm
            pkgs.gh
          ];

          context = ./ai/context.md;
        };

        programs.git.ignores = [
          ".ws"
        ];

        home.file = lib.mkIf config.programs.pi-coding-agent.enable {
          "${agentDir}/skills/" = {
            source = ./ai/skills;
            recursive = true;
          };

          "${agentDir}/mcp.json".source = ./ai/mcp.json;
        };
      }
    )
  ];
}
