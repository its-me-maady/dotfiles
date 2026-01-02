return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("tokyonight").setup({
				style = "storm",
				transparent = true,
				styles = {
					sidebars = "transparent",
					floats = "transparent",
				},
			})
			vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
			vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
			vim.cmd([[colorscheme tokyonight]])
		end,
	},
}
