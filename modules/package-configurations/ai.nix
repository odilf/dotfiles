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
              "npm:@narumitw/pi-usage"
              "npm:@raidou/pi-notify"
              "npm:pi-btw"
              "npm:pi-lens"
              "npm:pi-notify"
              "npm:pi-simplify"
              "npm:pi-vim"
            ];

            defaultProvider = "opencode-go";
            defaultModel = "deepseek-v4.1-flash";
            enabledModels = [
              "opencode-go/deepseek-v4.1-flash"
              "opencode-go/deepseek-v4-pro"
            ];

            showCacheMissNotices = true;
            defaultTools = [ "+codemode" ];

            tuiMode = "regular";
          };

          # For plugin installation
          extraPackages = [
            pkgs.nodejs
            pkgs.pnpm
          ];

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
            inline; that goes in docs instead. Full standard: ~/.pi/agent/skills/code-comments/SKILL.md

            ## Git
            Never create commits. `git commit`, amend, rebase, cherry-pick, and
            anything else that writes history require explicit permission each time.
            Leave changes in the working tree for me to review and commit myself.
          '';
        };

        programs.git.ignores = [
          ".ws"
        ];

        programs.fish.functions.piws = {
          description = "Run pi in a fresh jj workspace";
          body = ''
            argparse -n piws 'n/name=' -- $argv
            or return 2

            set -l name agent
            if set -q _flag_name
              set name $_flag_name
            end

            if test -z "$name"
              echo "piws: workspace name must not be empty" >&2
              return 2
            end

            if test "$name" = default
              echo "piws: 'default' is the main workspace; pick another name" >&2
              return 2
            end

            if string match -q -- '*/*' "$name"; or string match -q -- '-*' "$name"; or test "$name" = .; or test "$name" = ..
              echo "piws: invalid workspace name: $name" >&2
              return 2
            end

            set -l root (jj root 2>/dev/null)
            if test -z "$root"
              echo "piws: not inside a jj repo" >&2
              return 1
            end

            set -l dir $root/.ws/$name

            if not test -e $dir
              mkdir -p $root/.ws
              jj workspace add -r @ $dir --name $name
              or return 1
            end

            pushd $dir >/dev/null
            command pi --name $name $argv
            set -l code $status
            popd >/dev/null
            return $code
          '';
        };

        home.file = lib.mkIf config.programs.pi-coding-agent.enable {
          "${agentDir}/skills/" = {
            source = ./ai/skills;
            recursive = true;
          };

          "${agentDir}/prompts/discuss.md".source = ./ai/discuss.md;

          "${agentDir}/mcp.json".source = ./ai/mcp.json;

          "${agentDir}/extensions/jj-describe.ts".source = ./ai/extensions/jj-describe.ts;
        };
      }
    )
  ];
}
