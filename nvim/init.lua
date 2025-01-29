-- Disable netrw, because of `nvim-tree`
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)
-- Lazy package manager (above)

require("general")
require("neovide")

-- Lazy package manager
require("lazy").setup({
    { import = "plugins" },
    { import = "plugins.editor" },
    { import = "plugins.languages" },
  },
  { change_detection = { notify = false } }
)
