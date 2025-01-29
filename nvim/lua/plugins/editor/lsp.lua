local toggle_inlay_hints = function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end

return {
    -- Lazydev config from `https://github.com/folke/lazydev.nvim`
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "luvit-meta/library", words = { "vim%.uv" } },
            },
        },
    },

    {
        "dundalek/lazy-lsp.nvim",
        event = "VeryLazy",
        dependencies = {
            "neovim/nvim-lspconfig",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/nvim-cmp",
        },
        opts = {
            excluded_servers = {
                "ccls",          -- prefer clangd
                "flow",          -- prefer eslint and tsserver
                "ltex",          -- grammar tool using too much CPU
                "quick_lint_js", -- prefer eslint and tsserver
                "rnix",          -- archived on Jan 25, 2024
                "scry",          -- archived on Jun 1, 2023
                "als",           -- deprecated, it seems
                -- "docker_compose_language_service", -- yamlls should be enough?
                -- "tailwindcss",   -- associates with too many filetypes
            },
            preferred_servers = {
                python = { "pyright", "ruff_lsp" },
            },
			prefer_local = true,
        },
        keys = {
            { "<leader>lG", "<cmd>Telescope diagnostics<enter>",                   desc = "Show diagnostics" },
            { "<leader>la", vim.lsp.buf.code_action,                               desc = "Show code action" },
            { "<leader>ld", vim.lsp.buf.definition,                                desc = "Go to definition" },
            { "<leader>lD", vim.lsp.buf.declaration,                               desc = "Go to declaration" },
            { "<leader>li", vim.lsp.buf.implementation,                            desc = "Go to implementation" },
            { "<leader>lf", function() vim.lsp.buf.format { async = true } end,    desc = "Format" },
            { "<leader>lg", vim.diagnostic.open_float,                             desc = "Show diagnostics" },
            { "<leader>lh", toggle_inlay_hints,                                    desc = "Inlay hints" },
            { "<leader>lj", vim.diagnostic.goto_next,                              desc = "Next diagnostic" },
            { "<leader>lk", vim.diagnostic.goto_prev,                              desc = "Previous diagnostic" },
            { "<leader>lr", vim.lsp.buf.rename,                                    desc = "Rename" },
            { "<leader>lR", vim.lsp.buf.references,                                desc = "Go to references" },
            { "<leader>lt", vim.lsp.buf.type_definition,                           desc = "Type definition" },
            { "<leader>lw", "<cmd>Telescope lsp_dynamic_workspace_symbols<enter>", desc = "Workspace symbol" },
            { "K",          vim.lsp.buf.hover,                                     desc = "Hover" },
        },
		-- config = function(_, opts)
		-- 	require("lspconfig").setup({})
		-- 	require("lspconfig").harper_ls.setup()
		-- 	require("lazy-lsp").setup(opts)
		-- 	print("Setting up")
		-- end
    },

    -- top status bar
    {
        'glepnir/lspsaga.nvim',
        event = 'LspAttach',
        dependencies = {
            { 'nvim-tree/nvim-web-devicons' },
            { 'nvim-treesitter/nvim-treesitter' }
        }
    },

    -- inline fancy diagnostics
    {
        "rachartier/tiny-inline-diagnostic.nvim",
        event = "VeryLazy",
        config = function()
            vim.opt.updatetime = 100
            vim.diagnostic.config({ virtual_text = false })
            require('tiny-inline-diagnostic').setup()
        end
    }
}
