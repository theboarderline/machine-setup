require("nvim-treesitter.configs").setup {
  ensure_installed = { "go", "python", "cpp", "lua", "vim", "json", "toml" },
  ignore_install = {}, -- List of parsers to ignore installing
  auto_install = true,
  highlight = {
    enable = true, -- false will disable the whole extension
    disable = { 'help' }, -- list of language that will be disabled
  },
}
