source ~/.config/fish/paths/universal.fish

# brew
set PATH $PATH /opt/homebrew/bin

# pnpm
set PATH $PATH /Users/odilf/Library/pnpm/
set -x PNPM_HOME ~/.pnpm
set PATH $PNPM_HOME $PATH 

# For Docker
set PATH $PATH /usr/local/bin
