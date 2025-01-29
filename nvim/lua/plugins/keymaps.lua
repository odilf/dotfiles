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
				{ "<leader>fs", function() require("persistence").load() end,                 desc = "Load session" },


				{ "<leader>l",  group = "lsp" },
				{ "<leader>n",  group = "notifications" },
				{ "<leader>g",  group = "git" },

				{ "<leader>s",  group = "search" },
				{ "<leader>sr", require("spectre").open,                                      desc = "Replace in files (Spectre)" },

				{ "<leader>t",  group = "terminal" },

				{ "<leader>?",  function() require("which-key").show({ global = false }) end, desc = "Buffer Local Keymaps (which-key)" },
			})
		end,
	},
}
