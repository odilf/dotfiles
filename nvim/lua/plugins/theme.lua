return {
  "NLKNguyen/papercolor-theme",
  "savq/melange-nvim",
  "rebelot/kanagawa.nvim",

  {
    "marko-cerovac/material.nvim",
    lazy = false,
    opts = {
      plugins = {  -- Uncomment the plugins that you use to highlight them
        -- Available plugins:
        -- "dap",
        -- "dashboard",
        "eyeliner",
        -- "fidget",
        -- "flash",
        "gitsigns",
        "illuminate",
        "lspsaga",
        "neogit",
        "neo-tree",
        "nvim-cmp",
        "nvim-tree",
        "nvim-web-devicons",
        "telescope",
        "trouble",
        "which-key",
      },
      lualine_style = "stealth",
      disable = {
        background = false,
      },
    },
    config = function(_, opts)
      require("material").setup(opts)
      vim.opt.termguicolors = false
      vim.g.material_style = "darker"
      vim.cmd.colorscheme("material")
    end,
  },

  -- VSCode-like zen mode
  { "folke/zen-mode.nvim" },

  -- Neovim plugin to improve the default vim.ui interfaces
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {
      input = {
        insert_only = false,
        start_in_insert = true,
      },
      select = {
        backend = { "telescope", "fzf_lua", "fzf", "builtin", "nui" },
      }
    }
  },
}
