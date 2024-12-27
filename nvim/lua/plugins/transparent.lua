return {
	'xiyaowong/transparent.nvim',
	lazy = false,
	keys = {
		{"<leader>op", "<cmd>TransparentToggle<cr>", desc = "troggle transparent for neovim"},
		{"<leader>oe", "<cmd>TransparentEnable<cr>", desc = "enable transparent for neovim"},
		{"<leader>od", "<cmd>TransparentDisable<cr>", desc = "disable transparent for neovim"}
	},
	config = function ()
		require("transparent").setup({
			extra_groups = {
				"NormalFloat",
				"NvimTreeNormal",
				"CmpPmenu",
				"CmpPmenuBorder",
				"CmpPmenuSel",
				"CmpPmenuThumb",
				"FloatBorder",
			}
		})
	end
}
