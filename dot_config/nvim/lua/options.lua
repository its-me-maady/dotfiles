vim.o.so = 10
vim.o.number = true
vim.o.relativenumber = true
vim.o.tabstop = 4
vim.o.expandtab = true
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.undofile = true
vim.o.swapfile = false
vim.o.confirm = true
vim.o.mouse = ""
vim.g.have_nerd_font = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = "yes"
vim.o.colorcolumn = "100"
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.cursorline = true

vim.diagnostic.config({
	signs = false,
})

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})
