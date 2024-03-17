return {
	{
		"folke/which-key.nvim",
		config = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 500

			local wk = require("which-key")

			wk.register({
				["<leader>"] = {
					name = "leader mappings",

					-- Files and telescope
					f = {
						name = "file", -- optional group name
						f = { "<cmd>Telescope find_files<enter>", "Find File" },
						g = { "<cmd>Telescope live_grep<enter>", "Find in file (grep)" },
						r = { "<cmd>Telescope oldfiles<enter>", "Open recent file" },
						c = { "<cmd>Telescope frecency workspace=CWD<enter>", "Open frecency" },
						e = { "<cmd>NvimTreeToggle<enter>", "Toggle file explorer" },
						[","] = { "<cmd>Telescope buffers<enter>", "Search buffers" },
					},

					-- Git
					g = {
						name = "git",
						g = { "<cmd>Neogit<enter>", "Open neogit" },
						b = { "<cmd>Gitsigns blame_line<enter>", "Blame line" },
						d = { "<cmd>DiffviewOpen<enter>", "Open diff" },

						h = { "<cmd>Gitsigns stage_hunk<enter>", "Stage hunk" },
						j = { "<cmd>Gitsigns next_hunk<enter>", "Next hunk" },
						k = { "<cmd>Gitsigns prev_hunk<enter>", "Previous hunk" },
					},

					-- Terminal
					t = {
						name = "terminal",
						h = { "<cmd>ToggleTerm direction=horizontal<enter>", "Horizontal terminal" },
						f = { "<cmd>ToggleTerm direction=float<enter>", "Floating terminal" },
						v = { "<cmd>ToggleTerm direction=vertical size=80<enter>", "Vertical terminal" },
						t = { "<cmd>ToggleTerm direction=tab size=80<enter>", "Tab terminal" },
						[","] = { "<cmd>ToggleTerm<enter>", "Toggle terminal" },
					},

					-- LSP
					l = {
						name = "lsp",
						a = { vim.lsp.buf.code_action, "Code action" },
						d = { vim.lsp.buf.definition, "Definition" },
						f = { function() vim.lsp.buf.format { async = true } end, "Format" },
						g = { vim.diagnostic.open_float, "Show diagnostics" },
						G = { "<cmd>Telescope diagnostics<enter>", "Show diagnostics" },
						j = { vim.diagnostic.goto_next, "Next diagnostic" },
						k = { vim.diagnostic.goto_prev, "Previous diagnostic" },
						l = { vim.lsp.diagnostic.setloclist, "Set location list" },
						r = { vim.lsp.buf.rename, "Rename" },
						t = { vim.lsp.buf.type_definition, "Type definition" },
						w = { "<cmd>Telescope lsp_dynamic_workspace_symbols<enter>", "Workspace symbol" },
						h = { function(buf) vim.lsp.inlay_hint.enable(buf, not vim.lsp.inlay_hint.is_enabled()) end, "Inlay hints" }
					},

					-- Search
					s = {
						name = "search",
						s = { "<cmd>Telescope live_grep<enter>", "Search in files (grep)" },
						b = { "<cmd>Telescope buffers<enter>", "Search Buffers" },
						h = { "<cmd>Telescope help_tags<enter>", "Search Help" },
						m = { "<cmd>Telescope marks<enter>", "Search Marks" },
						r = { function() require("spectre").open() end, "Replace in files (Spectre)" },
					},

					-- Completion
					-- Some completion mappings are in `lsp.lua`
					c = {
						name = "completion",
						s = { "<cmd>CmpStatus<enter>", "Cmp Status" },
						c = { function() require('cmp').mapping.complete() end, "Complete" }
					}

					-- -- Debug
					-- d = {
					-- 	name = "debug",
					-- 	-- b = { require('dap').toggle_breakpoint, "Toggle breakpoint" },
					-- }
				}
			})

			-- Toggle terminal
			wk.register({
				-- TODO: This is kinda ugly, I can't press escape in terminal mode
				["<esc>"] = { [[<C-\><C-n>]], "Exit terminal mode" },
			}, { mode = "t" })

			-- Non-leader mappings
			wk.register({
				-- Copilot
				{ "<M-l>", "<cmd>Copilot accept<cr>",  desc = "Accept copilot suggestion" },
				{ "<M-]>", "<cmd>Copilot next<cr>",    desc = "Next copilot suggestion" },
				{ "<M-[>", "<cmd>Copilot prev<cr>",    desc = "Previous copilot suggestion" },
				{ "<C-]>", "<cmd>Copilot dismiss<cr>", desc = "Dismiss copilot suggestion" },

				-- Hover
				K = { vim.lsp.buf.hover, "Hover" },
			})
		end,

		event = "VimEnter",
	},
}
