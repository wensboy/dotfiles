return {
	"m4xshen/hardtime.nvim",
	dependencies = { "MunifTanjim/nui.nvim" },
	opts = {},
	config = function()
		local is_enabled = false
		local toggle_with_notification = function()
			vim.cmd("Hardtime toggle")
			if is_enabled then
				vim.notify("Hardtime is enabled!", 2, {
					title = "Hardtime"
				})
			else
				vim.notify("Hardtime is disabled!", 2, {
					title = "Hardtime"
				})
				is_enabled = true
			end
		end
		require("hardtime").setup {
			disabled_filetypes = {
				"NvimTree",
				"lazy",
				"mason",
				"dashboard",
			}
		}
		vim.keymap.set('n', '<leader>ht', toggle_with_notification, { silent = true })
	end
}
