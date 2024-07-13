vim.o.sessionoptions = "blank,buffers,curdir,folds,globals,help,tabpages,winsize,winpos,terminal,localoptions"

local function change_nvim_tree_dir()
	local nvim_tree = require("nvim-tree")
	nvim_tree.change_dir(vim.fn.getcwd())
end

return {
	{
		'rmagatti/auto-session',
		lazy = false,
		opts = {
			log_level = "error",
			auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
			auto_session_use_git_branch = true,
			-- TODO: Only restore NvimTree if NvimTree was opened previously
			-- TODO: Restore (close and open) terminal buffers too
			post_restore_cmds = { change_nvim_tree_dir, "NvimTreeOpen" },
			pre_save_cmds = { "NvimTreeClose" },
		}
	},
}
