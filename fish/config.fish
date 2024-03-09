source ~/.config/fish/aliases.fish

switch (uname)
    case Linux
		source ~/.config/fish/linux/subconfig.fish
    case Darwin
		source ~/.config/fish/macos/subconfig.fish
end

set SHELL "fish"

if status is-interactive
	zoxide init fish | source
	starship init fish | source
	
	set fish_greeting
	pfetch
end

