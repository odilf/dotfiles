if vim.g.neovide then
  vim.g.neovide_input_macos_alt_is_meta = true
  vim.o.guifont = "GeistMono NF SemiBold:style=Medium:h14"

  vim.g.neovide_cursor_animate_command_line = false
  vim.g.neovide_cursor_animate_in_insert_mode = false
  vim.g.neovide_scale_factor = 1.0

  local change_scale_factor = function(delta)
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
  end

  vim.keymap.set("n", "<D-=>", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * 1.1<CR>")
  vim.keymap.set("n", "<D-->", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor / 1.1<CR>")
  vim.keymap.set({ "n", "v" }, "<D-0>", ":lua vim.g.neovide_scale_factor = 1.0<CR>")
end
