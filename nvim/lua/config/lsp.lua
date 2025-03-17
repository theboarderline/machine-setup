
-- For a local 'BufEnter' or 'FileType go' autocmd:
autocmd("FileType", {
  pattern = "go",
  callback = function()
    vim.api.nvim_buf_del_keymap(0, "n", "<leader>e")
    vim.api.nvim_buf_set_keymap(0, "n", "<leader>e", ":NvimTreeToggle<CR>", { noremap=true, silent=true })
  end,
})

local M = {}

-- Function to set up keymaps after LSP attaches to the buffer
M.on_attach = function(client, bufnr)
  local opts = { noremap=true, silent=true }

  -- Define buffer-local keymaps
  local set_keymap = vim.api.nvim_buf_set_keymap

  -- LSP Keymaps
  set_keymap(bufnr, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  set_keymap(bufnr, 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  set_keymap(bufnr, 'n', '<leader>i', '<Cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  set_keymap(bufnr, 'n', '<leader>k', '<Cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  set_keymap(bufnr, 'n', '<leader>wa', '<Cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  set_keymap(bufnr, 'n', '<leader>wr', '<Cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  set_keymap(bufnr, 'n', '<leader>wl', '<Cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  set_keymap(bufnr, 'n', '<leader>D', '<Cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  set_keymap(bufnr, 'n', '<leader>rn', '<Cmd>lua vim.lsp.buf.rename()<CR>', opts)
  set_keymap(bufnr, 'n', '<leader>ca', '<Cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  set_keymap(bufnr, 'n', 'gr', '<Cmd>lua vim.lsp.buf.references()<CR>', opts)
  set_keymap(bufnr, 'n', '<leader>o', '<Cmd>lua vim.diagnostic.open_float()<CR>', opts)
  set_keymap(bufnr, 'n', '[d', '<Cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  set_keymap(bufnr, 'n', ']d', '<Cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  set_keymap(bufnr, 'n', '<leader>l', '<Cmd>lua vim.diagnostic.setloclist()<CR>', opts)

  -- Optional: Highlight symbol under cursor
  if client.server_capabilities.documentSymbolProvider then
    require("illuminate").on_attach(client)
  end
end

-- Function to set up capabilities, especially for auto-completion
M.capabilities = vim.lsp.protocol.make_client_capabilities()

-- Integrate with nvim-cmp for enhanced auto-completion
local cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if cmp_ok then
  M.capabilities = cmp_nvim_lsp.update_capabilities(M.capabilities)
end

-- List of LSP servers to set up
local servers = {
  "pyright",
  "gopls",
  "rust_analyzer",
  "tsserver",
  "zls",
  "bashls",
  "sqls",
  "yamlls",
  "helm_ls",
  "clangd",
}

for _, lsp in ipairs(servers) do
  require("lspconfig")[lsp].setup({
    on_attach = M.on_attach,
    capabilities = M.capabilities,
    flags = {
      debounce_text_changes = 150,
    },
    -- Optional: Server-specific settings
    -- settings = {
    --   pyright = { ... },
    --   gopls = { ... },
    --   rust_analyzer = { ... },
    --   -- etc.
    -- },
  })
end

-- Define diagnostic signs with icons
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }

for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Update capabilities for nvim-cmp
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Ensure your LSP server setups use these capabilities
require("lspconfig").pyright.setup({
  on_attach = M.on_attach,
  capabilities = capabilities,
})

return M
