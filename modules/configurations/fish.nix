{
  config,
  lib,
  pkgs,
  ...
}:
let
  homeUsers = builtins.attrNames config.home-manager.users;

  homeConfig =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (pkgs.stdenv.hostPlatform) isLinux isDarwin;
    in
    {
      home.packages = lib.mkIf config.programs.fish.enable (
        [
          pkgs.bottom
          pkgs.btop
          pkgs.comma
          pkgs.curl
          pkgs.dua
          pkgs.dust
          pkgs.fd
          pkgs.mosh
          pkgs.rsync
          pkgs.tokei
          pkgs.watchexec
          pkgs.wget
        ]
        ++ lib.optionals isDarwin [
          pkgs.darwin.trash
        ]
        ++ lib.optionals isLinux [
          pkgs.trashy
        ]
      );

      programs = lib.mkIf config.programs.fish.enable {
        eza.enable = true;
        eza.enableFishIntegration = false; # `la` does `eza -a` but I want `eza -l`

        nix-index.enable = true;
        nix-index.enableFishIntegration = false; # takes a long time to fail commands otherwise

        # Other programs I want to have enabled in shells
        bat.enable = true;
        broot.enable = true;
        direnv.enable = true;
        git.enable = true;
        jujutsu.enable = true;
        navi.enable = true;
        nh.enable = true;
        ripgrep-all.enable = true;
        ripgrep.enable = true;
        skim.enable = true;
        starship.enable = true;
        vim.enable = true;
        yazi.enable = true;
        zellij.enable = true;
        zoxide.enable = true;

        fish = {
          preferAbbrs = true;
          interactiveShellInit = ''
            set fish_greeting
            ${lib.getExe pkgs.pfetch-rs}

            functions --copy cd __cd_orig
            function cd --description 'cd, resolving symlinks'
                __cd_orig -P $argv
            end
          '';

          shellAbbrs = {
            # Keep muscle memmory but use new versions
            ls = "eza";
            la = "eza -l";
            lt = "eza --tree";
            grep = "rg";
            cat = "bat";

            # Actual abbreviations of long commands
            e = "$EDITOR";
            g = "git";
            c = "cargo";
            o = "open \\$argv &; disown";
            j = "jj";

            ## Git
            gc = "git commit";
            gC = "git commit --amend";
            gp = "git push";
            gP = "git pull";
            gl = "git log --graph";
            gd = "git diff";
            gD = "git diff --staged";
            gs = "git status";

            jc = "jj commit";
            jd = "jj diff";
            js = "jj st";

            ## Nix
            ns = "nix shell nixpkgs#";
          };
        };
      };

      home.sessionVariables.PATH = lib.mkIf (
        config.programs.fish.enable && isDarwin
      ) "$PATH:/opt/homebrew/bin";
    };
in
{
  programs.fish.enable = lib.mkIf (lib.any (
    user: config.home-manager.users.${user}.programs.fish.enable
  ) homeUsers) true;

  users.users = lib.mapAttrs (user: _: {
    shell = lib.mkIf config.home-manager.users.${user}.programs.fish.enable pkgs.fish;
  }) config.home-manager.users;

  home-manager.sharedModules = [ homeConfig ];
}
