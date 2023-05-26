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

  { "stevearc/dressing.nvim", event = "VeryLazy" }, -- Neovim plugin to improve the default vim.ui interfaces 
  { "nvim-tree/nvim-web-devicons", lazy = false },
}
