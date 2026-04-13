vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set


map("i", "jk", "<Esc>", { noremap = true, silent = true })
map({ "i", "n" }, "<C-s>", "<Esc><cmd>wa<CR>", { noremap = true, silent = true })
map({ "i", "n" }, "<C-q>", "<cmd>q<CR>", { noremap = true, silent = true })
map("n", "<c-t>", "<c-w><c-v>:term ", { noremap = true, silent = true })

map("n", "<Esc>", "<cmd>nohlsearch<CR>", { noremap = true, silent = true })

map("n", "<leader>y", 'mbgoVG"+y`b')
map("v", "<leader>y", '"+ygv', { noremap = true, silent = true })

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

map("n", "n", "nzz")
map("n", "N", "Nzz")
map("n", "<C-u>", "<C-u>zz")
map("n", "<C-d>", "<C-d>zz")

map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("x", "<A-j>", ":move '>+1<CR>gv=gv")
map("x", "<A-k>", ":move '<-2<CR>gv=gv")
map("n", "<A-j>", "<cmd>m +1<CR>", { noremap = true, silent = true, desc = "Move Down" })
map("n", "<A-k>", "<cmd>m -2<CR>", { noremap = true, silent = true, desc = "Move Down" })

-- quality of life
map("n", "x", '"_x', { noremap = true, silent = true })
map("v", "p", '"_dP', { noremap = true, silent = true })

map("i", "<C-Space>", "<C-x><C-o>", {noremap = true, silent=true})
