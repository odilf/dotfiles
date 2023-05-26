return {
	{
		"folke/which-key.nvim",
		config = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
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
				},

				-- LSP
				l = {
					name = "lsp",
					a = { vim.lsp.buf.code_action, "Code Action" },
					d = { vim.lsp.buf.definition, "Definition" },
					f = { function() vim.lsp.buf.format { async = true } end, "Format" },
					g = { vim.diagnostic.open_float, "Show Diagnostics" },
					j = { vim.diagnostic.goto_next, "Next Diagnostic" },
					k = { vim.diagnostic.goto_prev, "Previous Diagnostic" },
					l = { vim.lsp.diagnostic.set_loclist, "Set Location List" },
					r = { vim.lsp.buf.rename, "Rename" },
					t = { vim.lsp.buf.type_definition, "Type Definition" },
					w = { vim.lsp.buf.workspace_symbol, "Workspace Symbol" },
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
			}, { prefix = "<leader>" })

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
				["<esc>"] = { [[<C-\><C-n>]], "Exit terminal mode" },
			}, { mode = "t" })

			wk.register({
				K = { vim.lsp.buf.hover, "Hover" }
			})
		end,

		lazy = false
	},
}
