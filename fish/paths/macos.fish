source ~/.config/fish/paths/universal.fish

# brew
set PATH $PATH /opt/homebrew/bin

# pnpm
set PATH $PATH /Users/odilf/Library/pnpm/
set -x PNPM_HOME ~/.pnpm
set PATH $PATH $PNPM_HOME
