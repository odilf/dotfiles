-- Leader key
vim.keymap.set("n", "<Space>", "<Nop>")
vim.g.mapleader = " "

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = 'yes'

-- Don't show mode in messages
vim.opt.showmode = false

-- Wrap lines
vim.opt.linebreak = true

-- Tabs
vim.opt.tabstop = 4 -- Actual tabs
vim.opt.softtabstop = 4 -- Space tabs
vim.opt.shiftwidth = 4 -- Indentation (with `>>`)

-- Set the current working directory to passed path if it's valid
if vim.fn.isdirectory(vim.v.argv[3]) == 1 then
  vim.api.nvim_set_current_dir(vim.v.argv[3])
end
