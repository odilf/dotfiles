abbr rebuild nixos-rebuild switch --use-remote-sudo

# brew
set PATH $PATH ~/.linuxbrew/bin
set PATH $PATH /home/linuxbrew/.linuxbrew/bin

# pnpm
set -x PNPM_HOME ~/.local/share/pnpm/store/v3/
set PATH $PATH $PNPM_HOME
