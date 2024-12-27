return {
	'nvim-treesitter/nvim-treesitter',
	build = ":TSUpdate",
	config = function ()
		local configs = require("nvim-treesitter.configs")
		configs.setup({
			ensure_installed = { "c", "lua", "vim", "elixir", "heex", "javascript", "html", "regex", "bash", "markdown", "markdown_inline"},
			sync_install = true,
			auto_install = true,
			highlight = { enable = true },
			indent = { enable = true }
		})
	end
}
