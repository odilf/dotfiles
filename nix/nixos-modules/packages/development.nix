{ pkgs, ... }: {

}

# { pkgs, system }: with pkgs; builtins.attrValues {
# 	# General packages that I use day to day to navigate a cli
# 	general = [
# 		bat
# 		bottom
# 		btop # Maybe htop is better?
# 		curl
# 		dua
# 		eza
# 		fd
# 		starship
# 		ripgrep
# 		rsync
# 		tokei
# 		vim
# 		neovim
# 		wget
# 		yazi
# 		zellij
# 		zoxide
# 	] ++ mkIf system.isDarwin [
# 		darwin.trash
# 	] ++ mkIf system.isLinux [ ];
#
# 	rust = [
# 		bacon
# 	];
#
# 	js = [
# 		bun
# 		deno
# 		nodejs_22
# 		pnpm
# 	];
# }
