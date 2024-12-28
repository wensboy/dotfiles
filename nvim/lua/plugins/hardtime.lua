return {
	"m4xshen/hardtime.nvim",
	dependencies = { "MunifTanjim/nui.nvim" },
	opts = {},
	config = function ()
		require("hardtime").setup{}
		vim.keymap.set('n', '<leader>ht', ':Hardtime toggle<cr>', {silent = true } )
	end
}
