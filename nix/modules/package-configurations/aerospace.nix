{ ... }:
# TODO:
# - Make whatsapp always on 5
# - Make firefox always on 1
# - Maybe Todoist always on something too?
{
  home-manager.users."*".programs.aerospace.userSettings = {
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
      alt-h = "focus left";
      alt-j = "focus down";
      alt-k = "focus up";
      alt-l = "focus right";

      # See: https://nikitabobko.github.io/AeroSpace/commands#move
      alt-shift-h = "move left";
      alt-shift-j = "move down";
      alt-shift-k = "move up";
      alt-shift-l = "move right";

      alt-shift-ctrl-h = "join-with left";
      alt-shift-ctrl-j = "join-with down";
      alt-shift-ctrl-k = "join-with up";
      alt-shift-ctrl-l = "join-with right";

      # See: https://nikitabobko.github.io/AeroSpace/commands#resize
      alt-shift-minus = "resize smart -50";
      alt-shift-equal = "resize smart +50";

      # See: https://nikitabobko.github.io/AeroSpace/commands#workspace
      ctrl-1 = "workspace 1";
      ctrl-2 = "workspace 2";
      ctrl-3 = "workspace 3";
      ctrl-4 = "workspace 4";
      ctrl-5 = "workspace 5";
      ctrl-6 = "workspace 6";
      ctrl-7 = "workspace 7";
      ctrl-8 = "workspace 8";
      ctrl-9 = "workspace 9";

      # See: https://nikitabobko.github.io/AeroSpace/commands#move-node-to-workspace
      alt-shift-1 = "move-node-to-workspace 1";
      alt-shift-2 = "move-node-to-workspace 2";
      alt-shift-3 = "move-node-to-workspace 3";
      alt-shift-4 = "move-node-to-workspace 4";
      alt-shift-5 = "move-node-to-workspace 5";
      alt-shift-6 = "move-node-to-workspace 6";
      alt-shift-7 = "move-node-to-workspace 7";
      alt-shift-8 = "move-node-to-workspace 8";
      alt-shift-9 = "move-node-to-workspace 9";

      alt-f = "fullscreen";

      # See: https://nikitabobko.github.io/AeroSpace/commands#workspace-back-and-forth
      alt-tab = "workspace-back-and-forth";
      # See: https://nikitabobko.github.io/AeroSpace/commands#move-workspace-to-monitor
      alt-shift-tab = "move-workspace-to-monitor --wrap-around next";
    };
  };

  system.defaults.dock.expose-group-apps = false;
}
