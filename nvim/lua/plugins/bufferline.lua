return {
	'akinsho/bufferline.nvim',
	version = "*",
	dependencies = {
		'nvim-tree/nvim-web-devicons'
	},
	config = function()
		vim.opt.termguicolors = true
		require("bufferline").setup({
			options = {
				mode = "buffers",
				separator_style = "thick",
				show_buffer_icons = true,
				color_icons = true,
				show_buffer_close_icons = true,
				show_tab_indicators = true,
				indicator = {
					icon = '',
					style = 'icon'
				},
				offsets = {
					{
						filetype = "NvimTree",
						text = "File Explorer",
						text_align = "center",
						separator = true
					}
				},
				sort_by = 'insert_at_end',
			}
		})
		vim.keymap.set('n', '<leader>bn', ':BufferLineCycleNext<CR>',{ silent = true })
		vim.keymap.set('n', '<leader>bp', ':BufferLineCyclePrev<CR>',{ silent = true })
	end
}
