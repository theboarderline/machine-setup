
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath
  })
end

local lazy_opts = {
  ui = {
    border = "rounded",
    title = "Plugin Manager",
    title_pos = "center",
  },
}

vim.opt.rtp:prepend(lazypath)

local firenvim_not_active = function()
  return not vim.g.started_by_firenvim
end

local plugin_specs = {

  -- Plenary
  "nvim-lua/plenary.nvim",

  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("core.config.nvim-tree")
    end,
  },

  -- Sublime Monokai Color Scheme
  {
    "tanvirtin/monokai.nvim",
    config = function()
      -- Set the Monokai color scheme (by default it's 'monokai')
      -- Other variants: monokai_soda, monokai_pro, etc.
      vim.cmd("colorscheme monokai")
    end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("core.config.treesitter")
    end,
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      -- Example LSP servers
      -- lspconfig.lua_ls.setup{}
      -- lspconfig.pyright.setup{}
      -- ...
    end,
  },

  -- Completion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
    },
    config = function()
      local cmp = require("cmp")
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = {
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
      })

      -- Example: attach capabilities to a server
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
          },
        },
      })
    end,
  },

  -- Telescope (fuzzy finder)
  {
    "nvim-telescope/telescope.nvim",
    version = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("core.config.telescope")
    end,
  },

  -- Bufferline (buffer management)
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("core.config.bufferline")
    end,
  },

  -- AutoSave
  {
    "pocco81/auto-save.nvim",
    config = function()
      require("auto-save").setup({
        -- optional configuration
        enabled = true, -- start auto-save enabled
        execution_message = {
          message = function() -- message to show on save
            return ("AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S"))
          end,
        },
        events = {"InsertLeave", "TextChanged"},
        conditions = {
          exists = true,
          filename_is_not = {},
          filetype_is_not = {},
          modifiable = true
        },
        -- you can specify write_all_buffers = true to write all
        -- buffers when auto-saving (default is false)
      })
    end,
  },

  -- The missing auto-completion for cmdline!
  {
    "gelguy/wilder.nvim",
    build = ":UpdateRemotePlugins",
  },

  -- show and trim trailing whitespaces
  { "jdhao/whitespace.nvim", event = "VeryLazy" },

  -- NPM Updates
  {
    "vuki656/package-info.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    config = function()
      require('core.config.package-info')
    end
  },

  -- Highlight URLs inside vim
  { "itchyny/vim-highlighturl", event = "VeryLazy" },

  -- notification plugin
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    config = function()
      require("core.config.nvim-notify")
    end,
  },

  -- Dotenv
  {
    "ellisonleao/dotenv.nvim",
    config = function()
      require('dotenv').setup({
        enable_on_load = true,
        verbose = false,
      })
    end
  },

  -- Toggle Term
  {
    'akinsho/toggleterm.nvim',
    version = "*",
    config = function()
      require("core.config.toggleterm")
    end
  },

  -- Status Line
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    cond = firenvim_not_active,
    config = function()
      require("core.config.statusline")
    end
  },

  -- DAP
  {
    'mfussenegger/nvim-dap-python',
    config = function()
      require('dap-python').setup('~/.virtualenvs/debugpy/bin/python')
    end,
  },

  -- Debugger plugin
  {
    "sakhnik/nvim-gdb",
    enabled = function()
      if vim.g.is_win or vim.g.is_linux then
        return true
      end
      return false
    end,
    build = { "bash install.sh" },
    lazy = true,
  },

  -- DAP Extensions
  {
    'mfussenegger/nvim-dap',
    version = "*",
    event = "VeryLazy",
    dependencies = {
      { "theHamsta/nvim-dap-virtual-text", opts = { virt_text_pos = 'eol' }, },

      "nvim-telescope/telescope-dap.nvim",

      {
        "leoluz/nvim-dap-go",
        module = "dap-go",
        opts = {}
      },

      { 'nvim-treesitter/nvim-treesitter' },

      -- fancy UI for the debugger
      {
        "rcarriga/nvim-dap-ui",
        dependencies = {
          "nvim-neotest/nvim-nio",
        },
        -- stylua: ignore
        keys = {
          { "<leader>di", function() require("dapui").toggle({}) end, desc = "Dap UI" },

          {
            "<leader>de",
            function()
              -- Calling this twice to open and jump into the window.
              require('dapui').eval()
              require('dapui').eval()
            end,
            mode = { "n", "v" },
            desc = "Evaluate"
          },
        },
        opts = {
          icons = { expanded = "▾", collapsed = "▸" },
          -- floating = { border = 'rounded' },
          layouts = {
            {
              elements = {
                -- { id = 'stacks',      size = 0.30 },
                -- { id = 'breakpoints', size = 0.20 },
                { id = 'scopes',  size = 0.50 },
                { id = 'watches', size = 0.50 },
              },
              position = 'right',
              size = 40,
            },
            {
              elements = {
                { id = "repl",    size = 0.5 },
                { id = "console", size = 0.5 }
              },
              position = "bottom",
              size = 10
            }
          },
          floating = {
            max_height = nil,
            max_width = nil,
            border = "rounded",
            mappings = {
              close = { "q", "<Esc>" },
            },
          },
          render = {
            max_type_length = nil,
          },
        },
        config = function(_, opts)
          local dapui = require("dapui")
          dapui.setup(opts)
        end
      },
      -- mason.nvim integration
      -- {
      --   "jay-babu/mason-nvim-dap.nvim",
      --   dependencies = "mason.nvim",
      --   cmd = { "DapInstall", "DapUninstall" },
      --   opts = {
      --     -- Makes a best effort to setup the various debuggers with
      --     -- reasonable debug configurations
      --     automatic_setup = true,
      --     -- You can provide additional configuration to the handlers,
      --     -- see mason-nvim-dap README for more information
      --     handlers = {},
      --     -- You'll need to check that you have the required things installed
      --     -- online, please don't ask me how to install them :)
      --     ensure_installed = {
      --       -- Update this to ensure that you have the debuggers for the langs you want
      --     },
      --   },
      -- },

      -- JS/TS debugging.
      {
        "mxsdev/nvim-dap-vscode-js",
        dependencies = {
          {
            'microsoft/vscode-js-debug',
            build = 'npm i && npm run compile vsDebugServerBundle && rm -rf out && mv -f dist out',
          },
        },

      },
      -- Lua adapter.
      {
        "jbyuki/one-small-step-for-vimkind",
        -- stylua: ignore
        keys = {
          { "<leader>daL", function() require("osv").launch({ port = 8086 }) end, desc = "Adapter Lua Server" },
          { "<leader>dal", function() require("osv").run_this() end,              desc = "Adapter Lua" },
        },
        config = function()
          local dap = require("dap")
          dap.adapters.nlua = function(callback, config)
            callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
          end
          dap.configurations.lua = {
            {
              type = "nlua",
              request = "attach",
              name = "Attach to running Neovim instance",
            },
          }
        end,
      },
    },
  },

  -- LazyGit
  {
    "kdheepak/lazygit.nvim",
    cmd = {
        "LazyGit",
        "LazyGitConfig",
        "LazyGitCurrentFile",
        "LazyGitFilter",
        "LazyGitFilterCurrentFile",
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
  },

  -- Search make recipes
  { 'sopa0/telescope-makefile' },

  -- Go Helpers
  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("core.config.go")
    end,
    event = {"CmdlineEnter"},
    ft = {"go", 'gomod'},
    build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
  },

  -- Test Coverage
  {
    "andythigpen/nvim-coverage",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("core.config.coverage")
    end
  },

  -- Easily delete buffers
  { "famiu/bufdelete.nvim" },

  -- fancy start screen
  {
    "nvimdev/dashboard-nvim",
    cond = firenvim_not_active,
    config = function()
      require("core.config.dashboard-nvim")
    end,
  },

  -- Automatic insertion and deletion of a pair of characters
  { "Raimondi/delimitMate", event = "InsertEnter" },

  -- Manage your yank history
  {
    "gbprod/yanky.nvim",
    cmd = { "YankyRingHistory" },
    config = function()
      require("core.config.yanky")
    end,
  },

  -- Show git change (change, delete, add) signs in vim sign column
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("core.config.gitsigns")
    end,
  },

  -- K8s
  {
    "hsalem7/nvim-k8s",
    config = function()
      vim.g.vim_k8s_toggle_key_map = '<leader>k'
    end
  },

  -- cucumber-ls
  { "yaegassy/coc-cucumber" },

  -- helm-ls
  { "towolf/vim-helm" },

  -- Python indent (follows the PEP8 style)
  { "Vimjas/vim-python-pep8-indent", ft = { "python" } },

  -- Python-related text object
  { "jeetsukumaran/vim-pythonsense", ft = { "python" } },

  -- coc
  {
    "neoclide/coc.nvim",
    build = "npm ci",
  },

  -- Plugin to manipulate character pairs quickly
  { "machakann/vim-sandwich", event = "VeryLazy" },

  -- Markdown
  {
    "toppair/peek.nvim",
    event = { "VeryLazy" },
    build = "deno task --quiet build:fast",
    config = function()
        require("peek").setup()
        vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
        vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
    end,
  },

  -- Toggler
  {
    "nguyenvukhang/nvim-toggler",
    config = function()
      require('nvim-toggler').setup({
        inverses = {
          ['!=='] = '==='
        },
        remove_default_keybinds = false,
        remove_default_inverses = false,
      })
    end
  },

  -- Asynchronous command execution
  { "skywind3000/asyncrun.vim", lazy = true, cmd = { "AsyncRun" } },

  -- Toml
  { "cespare/vim-toml", ft = { "toml" }, branch = "main" },

  -- Finer looking cmdline
  {
    "VonHeikemen/fine-cmdline.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    config = function()
      require("core.config.fine-cmdline")
    end
  },

  -- ChatGPT
  {
    "jackMort/ChatGPT.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "folke/trouble.nvim",
      "nvim-telescope/telescope.nvim"
    },
    event = "VeryLazy",
    config = function()
      require("core.config.chatgpt")
    end,
  },

  -- showing keybindings
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("core.config.which-key")
    end,
  },

  -- Data files
  {
    'vidocqh/data-viewer.nvim',
    opts = {},
    dependencies = {
      "nvim-lua/plenary.nvim",
      "kkharji/sqlite.lua", -- Optional, sqlite support
    }
  },

  -- Github Copilot
  { 'github/copilot.vim' },

}

require("lazy").setup(plugin_specs, lazy_opts)
