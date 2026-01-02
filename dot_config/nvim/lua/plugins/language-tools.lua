---@diagnostic disable: undefined-global
return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>f",
			function()
				require("conform").format({ async = true, lsp_format = "fallback" })
			end,
			mode = "n",
			desc = "[F]ormat buffer",
		},
	},
	opts = {
		notify_on_error = false,
		format_on_save = function(bufnr)
			local disable_filetypes = { c = true, cpp = true }
			if disable_filetypes[vim.bo[bufnr].filetype] then
				return nil
			else
				return {
					timeout_ms = 500,
					lsp_format = "fallback",
				}
			end
		end,
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "ruff" },
			javascript = { "prettierd", "prettier", stop_after_first = true },
			-- 1. Add djlint for html files
			html = { "djlint" },
			htmldjango = { "djlint" },
		},
		-- 2. Configure djlint specific arguments
		formatters = {
			djlint = {
				-- This forces djlint to use the jinja profile even on .html files
				prepend_args = { "--profile", "jinja" },
			},
		},
	},
}
