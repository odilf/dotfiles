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

        programs.fish.functions = {
          piws = {
            description = "Run pi in a jj workspace, or manage pi workspaces";
            body = ''
              argparse -n piws 'n/name=' 'f/force' 'status' 'c/clean' 'all' 'h/help' -- $argv
              or return 2

              if set -q _flag_help
                echo 'usage: piws [-n NAME] [-f] [pi args...]'
                echo '       piws --status'
                echo '       piws --clean [--all] [NAME...]'
                return 0
              end

              set -l root (jj root 2>/dev/null)
              if test -z "$root"
                echo "piws: not inside a jj repo" >&2
                return 1
              end

              if set -q _flag_status
                __piws_status $root
                return
              end

              if set -q _flag_clean
                set -l mode incorporated
                if set -q _flag_all
                  set mode all
                end
                __piws_clean $root $mode $argv
                return
              end

              set -l name agent
              if set -q _flag_name
                set name $_flag_name
              end

              if test -z "$name"
                echo "piws: workspace name must not be empty" >&2
                return 2
              end

              if not string match -rq '^[A-Za-z0-9._-]+$' "$name"; or string match -q -- '-*' "$name"; or test "$name" = .; or test "$name" = ..
                echo "piws: invalid workspace name: $name" >&2
                return 2
              end

              if test "$name" = default
                echo "piws: 'default' is the main workspace; pick another name" >&2
                return 2
              end

              set -l dir $root/.ws/$name

              if not test -e $dir
                mkdir -p $root/.ws
                jj workspace add -r @ $dir --name $name
                or return 1
              end

              set -l lock $root/.ws/.locks/$name
              if test -e $lock
                set -l pid (cat $lock 2>/dev/null)
                if test -n "$pid"; and kill -0 $pid 2>/dev/null
                  if not set -q _flag_force
                    echo "piws: an agent is already running in '$name' (pid $pid)" >&2
                    echo "      use --force to open it anyway" >&2
                    return 1
                  end
                else
                  rm -f $lock
                end
              end

              pushd $dir >/dev/null
              command pi --name $name $argv
              set -l code $status
              popd >/dev/null
              return $code
            '';
          };

          __piws_status = {
            description = "List pi jj workspaces and their state";
            body = ''
              set -l root $argv[1]
              set -l wsroot $root/.ws
              set -l locks $wsroot/.locks

              if not test -d $wsroot
                echo "no pi workspaces"
                return
              end

              for dir in $wsroot/*/
                if not test -d "$dir"
                  continue
                end

                set -l name (basename "$dir")
                if test "$name" = .locks
                  continue
                end

                set -l state idle
                set -l lock $locks/$name
                if test -e $lock
                  set -l pid (cat $lock 2>/dev/null)
                  if test -n "$pid"; and kill -0 $pid 2>/dev/null
                    set state active
                  end
                end

                set -l desc ""
                if jj log -r "$name@" >/dev/null 2>&1
                  set -l inc (jj log -r "$name@ & ::@" --no-graph -T 'change_id.short()' 2>/dev/null)
                  if test -n "$inc"
                    set state incorporated
                  end
                  set desc (jj log -r "$name@" --no-graph -T 'description.first_line()' 2>/dev/null)
                else
                  set state unregistered
                end

                printf '%-16s %-13s %s\n' "$name" "$state" "$desc"
              end
            '';
          };

          __piws_clean = {
            description = "Forget and remove pi jj workspaces";
            body = ''
              set -l root $argv[1]
              set -l mode $argv[2]
              set -l names $argv[3..-1]
              set -l wsroot $root/.ws
              set -l locks $wsroot/.locks

              if test -z "$names"
                for dir in $wsroot/*/
                  if not test -d "$dir"
                    continue
                  end

                  set -l name (basename "$dir")
                  if test "$name" = .locks
                    continue
                  end

                  if test "$mode" = all
                    set -a names $name
                  else
                    set -l inc (jj log -r "$name@ & ::@" --no-graph -T 'change_id.short()' 2>/dev/null)
                    if test -n "$inc"
                      set -a names $name
                    end
                  end
                end
              end

              if test (count $names) -eq 0
                echo "nothing to clean"
                return
              end

              for name in $names
                if not string match -rq '^[A-Za-z0-9._-]+$' "$name"; or string match -q -- '-*' "$name"; or test "$name" = .; or test "$name" = ..
                  echo "piws: refusing to clean invalid name: $name" >&2
                  continue
                end

                set -l dir $wsroot/$name
                set -l lock $locks/$name

                if not test -d $dir
                  echo "piws: no such workspace: $name" >&2
                  continue
                end

                if test -e $lock
                  set -l pid (cat $lock 2>/dev/null)
                  if test -n "$pid"; and kill -0 $pid 2>/dev/null
                    echo "piws: skipping '$name': agent still running (pid $pid)" >&2
                    continue
                  end
                end

                if test -d $dir
                  pushd $dir >/dev/null
                  jj st >/dev/null 2>&1
                  popd >/dev/null
                end

                jj workspace forget $name >/dev/null 2>&1
                rm -rf -- "$dir"
                rm -f -- "$lock"
                echo "cleaned $name"
              end
            '';
          };
        };

        home.file = lib.mkIf config.programs.pi-coding-agent.enable {
          "${agentDir}/skills/" = {
            source = ./ai/skills;
            recursive = true;
          };

          "${agentDir}/prompts/discuss.md".source = ./ai/discuss.md;

          "${agentDir}/mcp.json".source = ./ai/mcp.json;

          "${agentDir}/extensions/jj-workspace.ts".source = ./ai/extensions/jj-workspace.ts;
        };
      }
    )
  ];
}
