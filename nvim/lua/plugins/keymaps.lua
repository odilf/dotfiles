local toggle_inlay_hints = function()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end

return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			preset = "modern",
		},
		dependencies = {
			"echasnovski/mini.icons",
		},
		config = function(opts)
			local wk = require("which-key")

			wk.setup(opts)

			wk.add({
				{ "<leader>",   group = "leader mappings" },

				{ "<leader>c",  group = "completion" },
				{ "<leader>cc", require('cmp').mapping.complete,                              desc = "Complete" },
				{ "<leader>cs", "<cmd>CmpStatus<enter>",                                      desc = "Cmp Status" },

				{ "<leader>f",  group = "file" },
				{ "<leader>f,", "<cmd>Telescope buffers<enter>",                              desc = "Search buffers" },
				{ "<leader>fc", "<cmd>Telescope frecency workspace=CWD<enter>",               desc = "Open frecency" },
				{ "<leader>fe", "<cmd>NvimTreeToggle<enter>",                                 desc = "Toggle file explorer" },
				{ "<leader>ff", "<cmd>Telescope find_files<enter>",                           desc = "Find File" },
				{ "<leader>fg", "<cmd>Telescope live_grep<enter>",                            desc = "Find in file (grep)" },
				{ "<leader>fr", "<cmd>Telescope oldfiles<enter>",                             desc = "Open recent file" },
				{ "<leader>fs", function() require("persistence").load() end,                 desc = "Load session" },

				{ "<leader>g",  group = "git" },
				{ "<leader>gb", "<cmd>Gitsigns blame_line<enter>",                            desc = "Blame line" },
				{ "<leader>gc", "<cmd>Git commit<enter>",                                     desc = "Commit" },
				{ "<leader>gd", "<cmd>DiffviewOpen<enter>",                                   desc = "Open diff" },
				{ "<leader>gf", "<cmd>Gitsigns stage_buffer<enter>",                          desc = "Stage file" },
				{ "<leader>gg", "<cmd>Neogit<enter>",                                         desc = "Open neogit" },
				{ "<leader>gh", "<cmd>Gitsigns stage_hunk<enter>",                            desc = "Stage hunk" },
				{ "<leader>gj", "<cmd>Gitsigns next_hunk<enter>",                             desc = "Next hunk" },
				{ "<leader>gk", "<cmd>Gitsigns prev_hunk<enter>",                             desc = "Previous hunk" },

				{ "<leader>l",  group = "lsp" },
				{ "<leader>lG", "<cmd>Telescope diagnostics<enter>",                          desc = "Show diagnostics" },
				{ "<leader>la", vim.lsp.buf.code_action,                                      desc = "Code action" },
				{ "<leader>ld", vim.lsp.buf.definition,                                       desc = "Definition" },
				{ "<leader>lf", function() vim.lsp.buf.format { async = true } end,           desc = "Format" },
				{ "<leader>lg", vim.diagnostic.open_float,                                    desc = "Show diagnostics" },
				{ "<leader>lh", toggle_inlay_hints,                                           desc = "Inlay hints" },
				{ "<leader>lj", vim.diagnostic.goto_next,                                     desc = "Next diagnostic" },
				{ "<leader>lk", vim.diagnostic.goto_prev,                                     desc = "Previous diagnostic" },
				{ "<leader>lr", vim.lsp.buf.rename,                                           desc = "Rename" },
				{ "<leader>lt", vim.lsp.buf.type_definition,                                  desc = "Type definition" },
				{ "<leader>lw", "<cmd>Telescope lsp_dynamic_workspace_symbols<enter>",        desc = "Workspace symbol" },

				{ "<leader>n",  group = "notifications" },
				-- { "<leader>nd", , desc = "Dismiss" },

				{ "<leader>s",  group = "search" },
				{ "<leader>sb", "<cmd>Telescope buffers<enter>",                              desc = "Search Buffers" },
				{ "<leader>sh", "<cmd>Telescope help_tags<enter>",                            desc = "Search Help" },
				{ "<leader>sm", "<cmd>Telescope marks<enter>",                                desc = "Search Marks" },
				{ "<leader>sr", require("spectre").open,                                      desc = "Replace in files (Spectre)" },
				{ "<leader>ss", "<cmd>Telescope live_grep<enter>",                            desc = "Search in files (grep)" },

				{ "<leader>t",  group = "terminal" },
				{ "<leader>t,", "<cmd>ToggleTerm<enter>",                                     desc = "Toggle terminal" },
				{ "<leader>tf", "<cmd>ToggleTerm direction=float<enter>",                     desc = "Floating terminal" },
				{ "<leader>th", "<cmd>ToggleTerm direction=horizontal<enter>",                desc = "Horizontal terminal" },
				{ "<leader>tt", "<cmd>ToggleTerm direction=tab size=80<enter>",               desc = "Tab terminal" },
				{ "<leader>tv", "<cmd>ToggleTerm direction=vertical size=80<enter>",          desc = "Vertical terminal" },

				-- Other
				{ "<leader>?",  function() require("which-key").show({ global = false }) end, desc = "Buffer Local Keymaps (which-key)" },

				-- TODO: This is kinda ugly, I can't press escape in terminal mode
				{ "<esc>",      "<C-\\><C-n>",                                                desc = "Exit terminal mode",              mode = "t" },

				{ "<C-l>",      "<cmd>Copilot accept<cr>",                                    desc = "Accept copilot suggestion" },
				{ "<M-]>",      "<cmd>Copilot next<cr>",                                      desc = "Next copilot suggestion" },
				{ "<M-[>",      "<cmd>Copilot prev<cr>",                                      desc = "Previous copilot suggestion" },
				{ "<C-]>",      "<cmd>Copilot dismiss<cr>",                                   desc = "Dismiss copilot suggestion" },
				{ "K",          vim.lsp.buf.hover,                                            desc = "Hover" },
			})
		end,
	},
}
