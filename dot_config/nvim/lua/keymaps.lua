---@diagnostic disable: undefined-global
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set

map("n", "<leader>i", "gg=G``", { noremap = true, silent = true })
map("i", "jk", "<Esc>", { noremap = true, silent = true })
map("n", "<leader>gf", vim.lsp.buf.code_action, { noremap = true, silent = true })

map({ "i", "n" }, "<C-n>", "<cmd>saveas ", { noremap = true, silent = true })
map({ "i", "n" }, "<C-w>", "<Esc><cmd>w<CR>", { noremap = true, silent = true })
map({ "i", "n" }, "<C-s>", "<Esc><cmd>noautocmd w<CR>", { noremap = true, silent = true })
map({ "i", "n" }, "<C-a>", "<cmd>wa<CR>", { noremap = true, silent = true })
map({ "i", "n" }, "<C-q>", "<cmd>q<CR>", { noremap = true, silent = true })
map("n", "<C-x>", "<cmd>!chmod +x %<CR>", { noremap = true, silent = true })

map({ "n", "v" }, "<C-t>", "<cmd>term<CR>", { noremap = true, silent = true })
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { noremap = true, silent = true })
map("t", "<Esc><Esc>", "<C-\\><C-n>", { noremap = true, silent = true })

--  See `:help wincmd` for a list of all window commands
map("n", "<C-h>", "<C-w><C-h>", { noremap = true, silent = true })
map("n", "<C-l>", "<C-w><C-l>", { noremap = true, silent = true })
map("n", "<C-j>", "<C-w><C-j>", { noremap = true, silent = true })
map("n", "<C-k>", "<C-w><C-k>", { noremap = true, silent = true })

map("n", "<leader>y", 'ggVG"+y``')
map("v", "<leader>y", '"+y', { noremap = true, silent = true })

-- TIP: Disable arrow keys in normal mode
map("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
map("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
map("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
map("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

map("n", "<Tab>", "<cmd>bnext<CR>", { noremap = true, silent = true })
map("n", "<S-Tab>", "<cmd>bprevious<CR>", { noremap = true, silent = true })
map({ "n", "t", "v" }, "<leader>d", "<cmd>bdelete<CR>", { noremap = true, silent = true })
map("n", "cp", "<cmd>cprevious<CR>", { noremap = true, silent = true })
map("n", "cn", "<cmd>cnext<CR>", { noremap = true, silent = true })
map("n", "co", "<cmd>cclose<CR>", { noremap = true, silent = true })

map("v", "<", "<gv")
map("v", ">", ">gv")

map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })

map("v", "<A-j>", "<cmd>m '>+1<CR>gv=gv", { noremap = true, silent = true, desc = "Move Down" })
map("v", "<A-k>", "<cmd>m '<-2<CR>gv=gv", { noremap = true, silent = true, desc = "Move Down" })

map("n", "<A-k>", "<cmd>m -2<CR>", { noremap = true, silent = true, desc = "Move Down" })
map("n", "<A-j>", "<cmd>m +1<CR>", { noremap = true, silent = true, desc = "Move Down" })

-- quality of life
map("n", "x", '"_x', { noremap = true, silent = true })
map("v", "p", '"_dP', { noremap = true, silent = true })
