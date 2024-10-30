 return {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim',lazy=true }, 
	 config = function()
	   local builtin = require('telescope.builtin')
	    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
	    vim.keymap.set('n','<leader>gs',builtin.grep_string,{desc = 'Telescope grep string'}) 
	 end
 }
