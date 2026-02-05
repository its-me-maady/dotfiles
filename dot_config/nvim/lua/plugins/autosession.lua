---@diagnostic disable: undefined-global
return {
	"rmagatti/auto-session",
	lazy = false,
	keys = {
		{ "<leader>sr", "<cmd>AutoSession search<CR>", desc = "Session search" },
	},
	opts = {
		-- Default values (can be customized)
		auto_save = true, -- Enables auto saving session on exit
		auto_restore = true, -- Enables auto restoring session on start
		auto_create = true, -- Enables auto creating new session files
		auto_delete_empty_sessions = true, -- Deletes session if only empty buffers were open
		sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions",
	},
}
