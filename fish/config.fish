set PATH $PATH /opt/homebrew/bin
set PATH $PATH ~/.cargo/bin

abbr --add ls lsd
abbr --add vim nvim
abbr --add grep rg
abbr --add cat bat

abbr --add c cargo
abbr --add g git
abbr --add e nvim


if status is-interactive
	zoxide init fish | source
	starship init fish | source
	
	set fish_greeting
	pfetch
end

