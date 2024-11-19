return {
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
    {
	'nvim-telescope/telescope.nvim', tag = '0.1.8',
	dependencies = { 'nvim-lua/plenary.nvim' }
    },
    {"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate"
    },
    {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
	    "nvim-lua/plenary.nvim",
	    "nvim-tree/nvim-web-devicons",
	    "MunifTanjim/nui.nvim",
	}
    },
    {
	'nvim-lualine/lualine.nvim',
	dependencies = { 'nvim-tree/nvim-web-devicons' }
    },
    {'romgrk/barbar.nvim',
	dependencies = {
	    'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
	    'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
	}
    },
    {
	"folke/which-key.nvim"
    },
    {
	"NvChad/nvim-colorizer.lua"
    },
}
