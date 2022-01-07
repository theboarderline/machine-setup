vim.cmd [[
try
  colorscheme monokai
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme darkplus
  set background=dark
endtry
]]
