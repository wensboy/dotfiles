return {
	'nvim-tree/nvim-tree.lua',
	version = "*",
	lazy = false,
	dependencies = {
		'nvim-tree/nvim-web-devicons',
	},
	config = function()
		vim.keymap.set('n', '<C-h>', ':NvimTreeToggle<cr>', { silent = true, noremap = true} )
		vim.keymap.set('n', '<leader>hf', ':NvimTreeFocus<cr>', { silent = true} )
		require("nvim-tree").setup({})
	end,

}


