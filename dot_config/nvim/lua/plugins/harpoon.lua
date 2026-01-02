---@diagnostic disable: undefined-global
return {
	"ThePrimeagen/harpoon",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
	},
	config = function()
		local mark = require("harpoon.mark")
		local ui = require("harpoon.ui")
		require("telescope").load_extension("harpoon")

		vim.keymap.set("n", "<leader>a", mark.add_file)
		vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)
		vim.keymap.set("n", "<leader>,", ui.nav_prev)
		vim.keymap.set("n", "<leader>,", ui.nav_next)

		vim.keymap.set("n", "<A-h>", function()
			ui.nav_file(1)
		end)
		vim.keymap.set("n", "<A-j>", function()
			ui.nav_file(2)
		end)
		vim.keymap.set("n", "<A-k>", function()
			ui.nav_file(3)
		end)
		vim.keymap.set("n", "<A-l>", function()
			ui.nav_file(4)
		end)
		vim.keymap.set("n", "<leader>se", "<Esc>:Telescope harpoon marks<CR>")
	end,
}
