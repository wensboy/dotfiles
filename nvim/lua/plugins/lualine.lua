return {
	'nvim-lualine/lualine.nvim',
	dependencies = {
		'nvim-tree/nvim-web-devicons',
		'neovim/nvim-lspconfig',
		'SmiteshP/nvim-navic',
	},
	config = function()

		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = 'nord',
				ignore_focus = {
				},
				globalstatus = true,
				section_separators = { left = '', right = '' },
				component_separators = { left = '', right = '' }
			},
		})
	end
}
