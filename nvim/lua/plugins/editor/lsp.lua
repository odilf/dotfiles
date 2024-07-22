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
    { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings


    {
        'neovim/nvim-lspconfig',
        event = { 'BufRead', 'BufNewFile' },
        dependencies = {
            'nvim-lua/lsp-status.nvim', -- status bar

            -- Language Server installation
            'williamboman/mason-lspconfig.nvim',
            'williamboman/mason.nvim',
        },
        cmd = { 'Mason' },

        config = function()
            -- Each entry can be name for defaults or an { name, opts } table
            local servers = {

                -- web dev
                'tsserver',
                'svelte',
                'tailwindcss',
                'unocss',
                'biome',
                'cssls',
                'html',

                -- markdown
                'marksman',
                'vale_ls',
                'typos_lsp',

                -- standalones
                'rust_analyzer', -- Apparently has problems in beta?
                'typst_lsp',
                'lua_ls',
                'pyright',
                'wgsl_analyzer',
                'clangd',
                'taplo',
                'nil_ls',
                'wgsl_analyzer',
                'yamlls',
                'zk',
            }

            local server_names = {}
            for key, value in pairs(servers) do
                if type(value) == 'table' then
                    server_names[key] = value[1]
                else
                    server_names[key] = value
                end
            end

            require('mason').setup()
            require('mason-lspconfig').setup({
                ensure_installed = server_names
            })

            local capabilities = require('cmp_nvim_lsp').default_capabilities()
            local lspconfig = require('lspconfig')

            for _, lsp in ipairs(servers) do
                if type(lsp) == 'string' then
                    -- Default config
                    lspconfig[lsp].setup({
                        capabilities = capabilities,
                        diagnostics = { enable = true }
                    })
                else
                    -- Override config
                    lspconfig[lsp[1]].setup(lsp[2])
                end
            end
        end,

    },

    {
        'hrsh7th/nvim-cmp',
        event = { 'BufRead', 'BufNewFile' },
        dependencies = {
            'saadparwaiz1/cmp_luasnip',
            'L3MON4D3/LuaSnip',
            'onsails/lspkind.nvim', -- lsp symbols

            -- Sources
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-nvim-lsp-signature-help',
            'hrsh7th/cmp-calc',

            'zbirenbaum/copilot-cmp',
            'zbirenbaum/copilot.lua',
        },
        config = function()
            local lspkind = require('lspkind')
            local luasnip = require('luasnip')
            local cmp = require('cmp')
            require("copilot_cmp").setup()

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },

                mapping = cmp.mapping.preset.insert({
                    ['<C-u>'] = cmp.mapping.scroll_docs(-4), -- Up
                    ['<C-d>'] = cmp.mapping.scroll_docs(4),  -- Down

                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-K>'] = cmp.mapping.confirm {
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                    },
                }),

                sources = {
                    { name = 'copilot' },
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                    { name = 'path' },
                    { name = 'nvim_lsp_signature_help' },
                    { name = 'calc' },
                    { name = 'lazydev',                group_index = 0 },
                },

                -- view = {
                --     entries = "custom",
                -- },

                experimental = {
                    ghost_text = true,
                },

                -- honestly, 🤷
                ---@diagnostic disable-next-line: missing-fields
                formatting = {
                    format = lspkind.cmp_format({
                        mode = 'symbol', -- show only symbol annotations
                    })
                }
            })

            -- Completions for search
            cmp.setup.cmdline({ '/', '?' }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = 'buffer' }
                }
            })

            -- Completions for command line
            cmp.setup.cmdline(':', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = 'path' }
                }, {
                    { name = 'cmdline' }
                })
            })
        end,
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

    -- inline diagnostics
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
