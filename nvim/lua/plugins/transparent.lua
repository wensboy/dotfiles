return {
	'xiyaowong/transparent.nvim',
	lazy = false,
	keys = {
		{"<leader>tp", "<cmd>TransparentToggle<cr>", desc = "troggle transparent for neovim"},
		{"<leader>te", "<cmd>TransparentEnable<cr>", desc = "enable transparent for neovim"},
		{"<leader>td", "<cmd>TransparentDisable<cr>", desc = "disable transparent for neovim"}
	},
	config = function ()
		require("transparent").setup({})
	end
}
