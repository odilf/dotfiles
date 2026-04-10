{ pkgs, ... }:
{
  home-manager.users."*".programs.aerospace.settings = {
    # If I ever want to use sketchybar again:
    # after-startup-command = [
    # 	'exec-and-forget borders active_color=0xffffff inactive_color=0x000000 width=10.0 style=round',
    # 	'exec-and-forget sketchybar'
    # ]
    # exec-on-workspace-change = ['/bin/bash', '-c',
    #     'sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE'
    # ]

    # I think this should not be necessary:
    accordion-padding = 30;

    mode.main.binding = {
      alt-enter = "exec-and-forget open -n /Applications/Ghostty.app";

      # See: https://nikitabobko.github.io/AeroSpace/commands#layout
      alt-slash = "layout tiles horizontal vertical";
      alt-comma = "layout accordion horizontal vertical";

      # See: https://nikitabobko.github.io/AeroSpace/commands#focus
      cmd-h = "focus left";
      cmd-j = "focus down";
      cmd-k = "focus up";
      cmd-l = "focus right";

      # See: https://nikitabobko.github.io/AeroSpace/commands#move
      cmd-ctrl-h = "move left";
      cmd-ctrl-j = "move down";
      cmd-ctrl-k = "move up";
      cmd-ctrl-l = "move right";

      cmd-leftSquareBracket = "join-with left";
      cmd-rightSquareBracket = "join-with right";

      # See: https://nikitabobko.github.io/AeroSpace/commands#resize
      cmd-shift-minus = "resize smart -50";
      cmd-shift-equal = "resize smart +50";

      # See: https://nikitabobko.github.io/AeroSpace/commands#workspace
      cmd-1 = "workspace 1";
      cmd-2 = "workspace 2";
      cmd-3 = "workspace 3";
      cmd-4 = "workspace 4";
      cmd-5 = "workspace 5";
      cmd-6 = "workspace 6";
      cmd-7 = "workspace 7";
      cmd-8 = "workspace 8";
      cmd-9 = "workspace 9";

      # See: https://nikitabobko.github.io/AeroSpace/commands#move-node-to-workspace
      cmd-ctrl-1 = "move-node-to-workspace 1";
      cmd-ctrl-2 = "move-node-to-workspace 2";
      cmd-ctrl-3 = "move-node-to-workspace 3";
      cmd-ctrl-4 = "move-node-to-workspace 4";
      cmd-ctrl-5 = "move-node-to-workspace 5";
      cmd-ctrl-6 = "move-node-to-workspace 6";
      cmd-ctrl-7 = "move-node-to-workspace 7";
      cmd-ctrl-8 = "move-node-to-workspace 8";
      cmd-ctrl-9 = "move-node-to-workspace 9";

      cmd-shift-f = "fullscreen";

      # See: https://nikitabobko.github.io/AeroSpace/commands#workspace-back-and-forth
      alt-tab = "workspace-back-and-forth";
      # See: https://nikitabobko.github.io/AeroSpace/commands#move-workspace-to-monitor
      alt-shift-tab = "move-workspace-to-monitor --wrap-around next";
    };
  };

  system.defaults.dock.expose-group-apps = false;
}
