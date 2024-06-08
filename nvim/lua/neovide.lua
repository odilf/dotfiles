if vim.g.neovide then
  vim.g.neovide_input_macos_option_key_is_meta = "only_left"
  vim.o.guifont = "GeistMono NF SemiBold:style=Medium:h14"

  vim.g.neovide_cursor_animate_command_line = false
  vim.g.neovide_cursor_animate_in_insert_mode = false
  vim.g.neovide_scale_factor = 1.0

  vim.keymap.set("n", "<D-=>", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * 1.1<CR>")
  vim.keymap.set("n", "<D-->", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor / 1.1<CR>")
  vim.keymap.set({ "n", "v" }, "<D-0>", ":lua vim.g.neovide_scale_factor = 1.0<CR>")

  -- Allow copy-paste
  vim.keymap.set('n', '<D-s>', ':w<CR>') -- Save
  vim.keymap.set('v', '<D-c>', '"+y') -- Copy
  vim.keymap.set('n', '<D-v>', '"+P') -- Paste normal mode
  vim.keymap.set('v', '<D-v>', '"+P') -- Paste visual mode
  vim.keymap.set('c', '<D-v>', '<C-R>+') -- Paste command mode
  vim.keymap.set('i', '<D-v>', '<ESC>l"+Pli') -- Paste insert mode
end
