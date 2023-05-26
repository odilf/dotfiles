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

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

-- Neovide settings
if vim.g.neovide then
  vim.g.neovide_input_macos_alt_is_meta = true
  vim.o.guifont = "Fira Code"
  vim.g.neovide_remember_window_size = true
  vim.g.neovide_cursor_animate_command_line = false
  vim.g.neovide_cursor_animate_in_insert_mode = false
  vim.g.neovide_scale_factor = 0.95
end

vim.keymap.set("n", "<Space>", "<Nop>")
vim.g.mapleader = " "

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.showmode = false
vim.opt.signcolumn = 'yes'


require("lazy").setup({
  { import = "plugins" },
  { import = "plugins.editor" },
  { import = "plugins.languages" },
})



--[[
# TODOS:

- [ ] Look into Wilder.nvim (for cmd line autocomplete)
]]--
