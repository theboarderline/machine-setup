local keymap = vim.keymap
local api = vim.api
local uv = vim.loop

-- ToggleTerm
keymap.set({ "n", "i", "v", "t"  }, "<c-\\>", "<cmd>ToggleTerm<CR>", { desc = "toggle terminal" })

-- Turn the word under cursor to upper case
keymap.set("i", "<a-u>", "<Esc>viwUea")

-- Turn the current word into title case
keymap.set("i", "<c-t>", "<Esc>b~lea")

-- Paste non-linewise text above or below current line, see https://stackoverflow.com/a/1346777/6064933
keymap.set("n", "<space>p", "m`o<ESC>p``", { desc = "paste below current line" })
keymap.set("n", "<space>P", "m`O<ESC>p``", { desc = "paste above current line" })

-- Shortcut for faster save and quit
keymap.set("n", "<space>w", "<cmd>update<CR>", { silent = true, desc = "save buffer" })

-- Saves the file if modified and quit
keymap.set("n", "<space>q", "<cmd>x<CR>", { silent = true, desc = "quit current window" })

-- Quit all opened buffers
keymap.set("n", "<space>Q", "<cmd>qa!<CR>", { silent = true, desc = "quit nvim" })

-- Navigation in the location and quickfix list
keymap.set("n", "[l", "<cmd>lprevious<CR>zv", { silent = true, desc = "previous location item" })
keymap.set("n", "]l", "<cmd>lnext<CR>zv", { silent = true, desc = "next location item" })

keymap.set("n", "[L", "<cmd>lfirst<CR>zv", { silent = true, desc = "first location item" })
keymap.set("n", "]L", "<cmd>llast<CR>zv", { silent = true, desc = "last location item" })

keymap.set("n", "[q", "<cmd>cprevious<CR>zv", { silent = true, desc = "previous qf item" })
keymap.set("n", "]q", "<cmd>cnext<CR>zv", { silent = true, desc = "next qf item" })

keymap.set("n", "[Q", "<cmd>cfirst<CR>zv", { silent = true, desc = "first qf item" })
keymap.set("n", "]Q", "<cmd>clast<CR>zv", { silent = true, desc = "last qf item" })

-- Cmdline prompt
-- keymap.set({ "n", "v", "i", "x" }, ":", "<cmd>FineCmdline<CR><bs>", { desc = "command line prompt" })
keymap.set({ "n", "v", "i", "x" }, ":", "<cmd>lua require('fine-cmdline').open({default_value = ''})<CR>", { desc = "command line prompt" })

-- Save key strokes (now we do not need to press shift to enter command mode).
keymap.set({ "n", "x" }, ";", ":")

-- Close location list or quickfix list if they are present, see https://superuser.com/q/355325/736190
keymap.set("n", [[\x]], "<cmd>windo lclose <bar> cclose <CR>", {
  silent = true,
  desc = "close qf and location list",
})

-- Delete a buffer, without closing the window, see https://stackoverflow.com/q/4465095/6064933
keymap.set("n", [[\d]], "<cmd>bprevious <bar> bdelete #<CR>", {
  silent = true,
  desc = "delete buffer",
})

-- Insert a blank line below or above current line (do not move the cursor),
-- see https://stackoverflow.com/a/16136133/6064933
keymap.set("n", "<space>o", "printf('m`%so<ESC>``', v:count1)", {
  expr = true,
  desc = "insert line below",
})

keymap.set("n", "<space>O", "printf('m`%sO<ESC>``', v:count1)", {
  expr = true,
  desc = "insert line above",
})

-- Move the cursor based on physical lines, not the actual lines.
keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })
keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })
keymap.set("n", "^", "g^")

-- Do not include white space characters when using $ in visual mode,
-- see https://vi.stackexchange.com/q/12607/15292
keymap.set("x", "$", "g_")

-- Continuous visual shifting (does not exit Visual mode), `gv` means
-- to reselect previous visual area, see https://superuser.com/q/310417/736190
keymap.set("x", "<", "<gv")
keymap.set("x", ">", ">gv")

-- Edit and reload nvim config file quickly
keymap.set({ "n", "v" }, "<leader>ev", "<cmd>tabnew $MYVIMRC <bar> tcd %:h<CR>", {
  silent = true,
  desc = "open init.lua",
})

keymap.set({ "n", "v" }, "<leader>sv", function()
  vim.cmd([[
      update $MYVIMRC
      source $MYVIMRC
    ]])
  vim.notify("Nvim config successfully reloaded!", vim.log.levels.INFO, { title = "nvim-config" })
end, {
  silent = true,
  desc = "reload init.lua",
})

-- Reselect the text that has just been pasted, see also https://stackoverflow.com/a/4317090/6064933.
keymap.set("n", "<space>v", "printf('`[%s`]', getregtype()[0])", {
  expr = true,
  desc = "reselect last pasted area",
})

-- Always use very magic mode for searching
keymap.set("n", "/", [[/\v]])

-- Search in selected region
-- xnoremap / :<C-U>call feedkeys('/\%>'.(line("'<")-1).'l\%<'.(line("'>")+1)."l")<CR>

-- Change current working directory locally and print cwd after that,
-- see https://vim.fandom.com/wiki/Set_working_directory_to_the_current_file
keymap.set("n", "<space>cd", "<cmd>lcd %:p:h<CR><cmd>pwd<CR>", { desc = "change cwd" })

-- Use Esc to quit builtin terminal
keymap.set("t", "<Esc>", [[<c-\><c-n>]])

-- Toggle spell checking
keymap.set("n", "<F11>", "<cmd>set spell!<CR>", { desc = "toggle spell" })
keymap.set("i", "<F11>", "<c-o><cmd>set spell!<CR>", { desc = "toggle spell" })

-- Change text without putting it into the vim register,
-- see https://stackoverflow.com/q/54255/6064933
keymap.set("n", "c", '"_c')
keymap.set("n", "C", '"_C')
keymap.set("n", "cc", '"_cc')
keymap.set("x", "c", '"_c')

-- Remove trailing whitespace characters
keymap.set("n", "<space><space>", "<cmd>StripTrailingWhitespace<CR>", { desc = "remove trailing space" })

-- check the syntax group of current cursor position
keymap.set("n", "<space>st", "<cmd>call utils#SynGroup()<CR>", { desc = "check syntax group" })

-- Copy entire buffer.
keymap.set("n", "<space>y", "<cmd>%yank<CR>", { desc = "yank entire buffer" })

-- Toggle cursor column
keymap.set("n", "<space>cl", "<cmd>call utils#ToggleCursorCol()<CR>", { desc = "toggle cursor column" })

-- Move current line up and down
keymap.set("n", "<c-k>", '<cmd>call utils#SwitchLine(line("."), "up")<CR>', { desc = "move line up" })
keymap.set("n", "<c-j>", '<cmd>call utils#SwitchLine(line("."), "down")<CR>', { desc = "move line down" })

-- Move highlighted lines up and down
keymap.set("x", "J", ":move '>+1<CR>gv-gv")
keymap.set("x", "K", ":move '<-2<CR>gv-gv")

-- Resize with arrows
keymap.set("n", "<C-i>", ":resize -3<CR>")
keymap.set("n", "<C-m>", ":resize +3<CR>")
keymap.set("n", "<C-u>", ":vertical resize -3<CR>")
keymap.set("n", "<S-u>", ":vertical resize +3<CR>")

-- Navigate buffers
keymap.set("n", "<S-h>", ":bprevious<CR>")
keymap.set("n", "<S-l>", ":bnext<CR>")

-- Replace visual selection with text in register, but not contaminate the register,
-- see also https://stackoverflow.com/q/10723700/6064933.
keymap.set("x", "p", '"_c<Esc>p')

-- Text objects for URL
keymap.set({ "x", "o" }, "iu", "<cmd>call text_obj#URL()<CR>", { desc = "URL text object" })

-- Text objects for entire buffer
keymap.set({ "x", "o" }, "iB", ":<C-U>call text_obj#Buffer()<CR>", { desc = "buffer text object" })

-- Remove highlighting for search results
keymap.set({ "n", "v" }, "<space>h", "<cmd>nohlsearch<CR>", { desc = "No Highlight" })

-- Do not move my cursor when joining lines.
keymap.set("n", "J", function()
  vim.cmd([[
      normal! mzJ`z
      delmarks z
    ]])
end, {
  desc = "join lines without moving cursor",
})

-- Break inserted text into smaller undo units when we insert some punctuation chars.
local undo_ch = { ",", ".", "!", "?", ";", ":" }
for _, ch in ipairs(undo_ch) do
  keymap.set("i", ch, ch .. "<c-g>u")
end

-- Go to the beginning and end of current line in insert mode quickly
keymap.set("i", "<C-A>", "<HOME>")
keymap.set("i", "<C-E>", "<END>")

-- Delete the character to the right of the cursor
keymap.set("i", "<C-D>", "<DEL>")

-- Find cursor
keymap.set("n", "<space>cb", function()
  local cnt = 0
  local blink_times = 7
  local timer = uv.new_timer()

  timer:start(0, 100, vim.schedule_wrap(function()
    vim.cmd[[
      set cursorcolumn!
      set cursorline!
    ]]

    if cnt == blink_times then
      timer:close()
    end

    cnt = cnt + 1
  end))
end)
