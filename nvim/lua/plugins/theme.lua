return {
  "NLKNguyen/papercolor-theme",
  "savq/melange-nvim",

  {
    "rebelot/kanagawa.nvim",
    name = "kanagawa",
    lazy = false,
    config = function()
      vim.cmd.colorscheme("kanagawa-dragon")
    end,
  },

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
