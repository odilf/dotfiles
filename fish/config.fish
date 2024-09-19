source ~/.config/fish/aliases.fish
source ~/.config/fish/paths.fish

switch (uname)
    case Linux
		source ~/.config/fish/linux.fish
    case Darwin
		source ~/.config/fish/macos.fish
end

set -x LANG en_US.UTF-8
set -x SHELL "fish"

if status is-interactive
	thefuck --alias | source

	zoxide init fish | source
	starship init fish | source
	enable_transience
	
	set fish_greeting 
	pfetch
end


# Created by `pipx` on 2024-03-13 10:57:59
set PATH $PATH /Users/odilf/.local/bin
