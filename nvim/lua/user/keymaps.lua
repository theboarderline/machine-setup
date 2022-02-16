local opts = { noremap = true, silent = true }


-- Shorten function name
local term_opts = { silent = true }
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
--
keymap("n", "<leader>o", ":Format<CR>", opts)

-- Better window navigation
keymap("n", "<leader>j", "<C-w>v", opts)
keymap("n", "<leader>k", "<C-w>s", opts)

-- keymap("n", "<leader>v", "<C-w>h", opts)
-- keymap("n", "<leader>b", "<C-w>j", opts)
-- keymap("n", "<leader>n", "<C-w>k", opts)
-- keymap("n", "<leader>m", "<C-w>l", opts)

-- Resize with arrows
keymap("n", "<C-i>", ":resize -2<CR>", opts)
keymap("n", "<C-m>", ":resize +2<CR>", opts)
keymap("n", "<C-u>", ":vertical resize -2<CR>", opts)
keymap("n", "<S-u>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Move text up and down
keymap("n", "<C-k>", "<Esc>:m .-2<CR>", opts)
keymap("n", "<C-j>", "<Esc>:m .+1<CR>", opts)

-- Insert --
-- Press jk fast to enter
keymap("i", "jk", "<ESC>", opts)

-- Visual --

keymap("v", "<leader>k", "<ESC>", opts)

-- Move highlighted text
keymap("v", "<C-k>", ":m .-2<CR>", opts)
keymap("v", "<C-j>", ":m .+1<CR>", opts)

-- Move text up and down
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)
keymap("v", "p", '"_dP', opts)

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- Terminal --
-- Better terminal navigation
keymap("t", "<C-j>", "clear<CR>", term_opts)
-- keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
-- keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
-- keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
-- keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)

