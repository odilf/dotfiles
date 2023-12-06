return {
	{
		"folke/which-key.nvim",
		config = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 500
			local wk = require("which-key")

			wk.setup({})

			wk.register({
				-- Files and telescope
				f = {
					name = "file", -- optional group name
					f = { "<cmd>Telescope find_files<enter>", "Find File" },
					g = { "<cmd>Telescope live_grep<enter>", "Find in file (grep)" },
					r = { "<cmd>Telescope oldfiles<enter>", "Open recent file" },
					e = { "<cmd>Neotree toggle<enter>", "Toggle file explorer" },
					[","] = { "<cmd>Telescope buffers<enter>", "Search buffers" },
				},

				-- Git
				g = {
					name = "git",
					g = { "<cmd>Neogit<enter>", "Open neogit" },
					d = { "<cmd>DiffviewOpen<enter>", "Open diff" },
				},

				-- Terminal
				t = {
					name = "terminal",
					h = { "<cmd>ToggleTerm direction=horizontal<enter>", "Horizontal terminal" },
					f = { "<cmd>ToggleTerm direction=float<enter>", "Floating terminal" },
					v = { "<cmd>ToggleTerm direction=vertical size=80<enter>", "Vertical terminal" },
					t = { "<cmd>ToggleTerm direction=tab size=80<enter>", "Tab terminal" },
					[","] = { "<cmd>ToggleTerm<enter>", "Toggle terminal" },
					-- TODO: Currently broken if the terminal is already open
					r = { "<cmd>ToggleTerm<enter>i<up><enter>", "Repeat last terminal command" }
				},

				-- LSP
				l = {
					name = "lsp",
					a = { vim.lsp.buf.code_action, "Code action" },
					d = { vim.lsp.buf.definition, "Definition" },
					f = { function() vim.lsp.buf.format { async = true } end, "Format" },
					g = { vim.diagnostic.open_float, "Show diagnostics"},
					G = { "<cmd>Telescope diagnostics<enter>", "Show diagnostics" },
					j = { vim.diagnostic.goto_next, "Next diagnostic" },
					k = { vim.diagnostic.goto_prev, "Previous diagnostic" },
					l = { vim.lsp.diagnostic.setloclist, "Set location list" },
					r = { vim.lsp.buf.rename, "Rename" },
					t = { vim.lsp.buf.type_definition, "Type definition" },
					w = { "<cmd>Telescope lsp_dynamic_workspace_symbols<enter>", "Workspace symbol"
					},
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

				-- Debug
				d = {
					name = "debug",
					b = { require('dap').toggle_breakpoint, "Toggle breakpoint" },
					
				}
			}, { prefix = "<leader>" })

			wk.register({
				["<lt>"] = { "<nop>" },
			}, { mode = "n" })

			-- Creating and closing tabs
			wk.register({
				["<S-D-w>"] = { "<cmd>tabclose<enter>", "Close tab" },
				["<D-w>"] = { "<cmd>q<enter>", "Close buffer" },
				["<D-t>"] = { "<cmd>tabnew<enter>", "New tab" },
			})

			-- Tab navigation with <D-1> through <D-9>
			for i = 1, 9 do
				wk.register({
					["<D-" .. i .. ">"] = { i .. "gt", "Go to tab " .. i },
				})
			end

			-- Toggle terminal
			wk.register({
				-- TODO: This is kinda ugly, I can't press escape in terminal mode
				["<esc>"] = { [[<C-\><C-n>]], "Exit terminal mode" },
			}, { mode = "t" })
			
			-- Hover
			wk.register({
				K = { vim.lsp.buf.hover, "Hover" }
			})

			-- Copy paste from clipboard
			-- TODO: Figure out interaction with tmux 🙄
			-- wk.register({
			-- 	["<C-c>"] = { "\"*y", "Copy to clipboard" },
			-- 	["<C-v>"] = { "\"*p", "Paste from clipboard" },
			-- })
		end,

		event = "VimEnter",
	},
}
