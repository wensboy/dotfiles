return {
	"m4xshen/hardtime.nvim",
	dependencies = { "MunifTanjim/nui.nvim" },
	opts = {},
	config = function()
		vim.notify = require("notify")
		local is_enabled = false
		local toggle_with_notification = function()
			vim.cmd("Hardtime toggle")
			if is_enabled then
				vim.notify("Hardtime is enabled!")
			else
				vim.notify("Hardtime is disabled!")
				is_enabled = true
			end
		end
		require("hardtime").setup {
			disabled_filetypes = {
				"NvimTree",
				"lazy",
				"mason",
			}
		}
		vim.keymap.set('n', '<leader>ht', toggle_with_notification, { silent = true })
	end
}
