return {
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
    }
