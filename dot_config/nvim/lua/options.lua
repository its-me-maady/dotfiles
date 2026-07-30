vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.o.so = 10

vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4

vim.opt.foldenable = false
vim.opt.foldlevelstart = 99


vim.o.undofile = true
vim.o.swapfile = false
vim.o.confirm = true

vim.o.mouse = ""
vim.g.have_nerd_font = true

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.signcolumn = "yes"
vim.o.colorcolumn = "88"

vim.o.updatetime = 250
vim.o.timeoutlen = 300

vim.o.splitright = true
vim.o.splitbelow = true

vim.o.inccommand = 'split'



vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})


vim.o.completeopt = "menuone,noinsert,noselect"
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    vim.bo[args.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
  end,
})


