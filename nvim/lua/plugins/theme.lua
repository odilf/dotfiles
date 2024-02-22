return {
  "NLKNguyen/papercolor-theme",
  "savq/melange-nvim",

  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    config = function()
      vim.opt.termguicolors = true
      vim.cmd.colorscheme("kanagawa")
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
