
_G.map = vim.keymap.set

_G.autocmd = vim.api.nvim_create_autocmd

_G.augroup = vim.api.nvim_create_augroup

_G.opts = function(desc)
  return { desc = desc, noremap = true, silent = true, nowait = true }
end

