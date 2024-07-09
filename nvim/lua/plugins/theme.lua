return {
  "NLKNguyen/papercolor-theme",
  "savq/melange-nvim",
  "rebelot/kanagawa.nvim",

  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    config = function(opts)
      require("nightfox").setup(opts)
      vim.cmd("colorscheme duskfox")
    end
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

  -- Auto switch light/dark theme
  {
    "f-person/auto-dark-mode.nvim",
    opts = {
      update_interval = 1000,
      set_dark_mode = function()
        vim.api.nvim_set_option_value("background", "dark", {})
        vim.cmd("colorscheme duskfox")
      end,
      set_light_mode = function()
        vim.api.nvim_set_option_value("background", "light", {})
        vim.cmd("colorscheme dayfox")
      end,
    },
  }
}
