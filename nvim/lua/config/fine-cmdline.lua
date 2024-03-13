local fineline = require('fine-cmdline')
local fn = fineline.fn

fineline.setup({
  cmdline = {
    enable_keymaps = true,
    smart_history = true,
    prompt = ': '
  },
  popup = {
    position = {
      row = '10%',
      col = '50%',
    },
    size = {
      width = '40%',
    },
    border = {
      style = 'rounded',
    },
    win_options = {
      winhighlight = 'Normal:Normal,FloatBorder:FloatBorder',
    },
  },
  hooks = {
    before_mount = function(input)
      -- code
    end,
    after_mount = function(input)
      vim.keymap.set('i', '<Esc>', '<cmd>stopinsert<cr>', {buffer = input.bufnr})
      fn.complete_or_next_item()
    end,
    set_keymaps = function(imap, feedkeys)
      -- code
    end
  }
})
