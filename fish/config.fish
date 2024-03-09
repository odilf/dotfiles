source ~/.config/fish/aliases.fish

switch (uname)
    case Linux
		source ~/.config/fish/paths/linux.fish
    case Darwin
		source ~/.config/fish/paths/macos.fish
end

set -x LANG en_US.UTF-8
set -x SHELL "fish"

if status is-interactive
	zoxide init fish | source
	starship init fish | source
	
	set fish_greeting
	pfetch
end

