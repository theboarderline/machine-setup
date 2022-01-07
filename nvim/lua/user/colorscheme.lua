vim.cmd [[
try
  colorscheme monokai_soda
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme darkplus
  set background=dark
endtry
]]
