return {
	'SmiteshP/nvim-navic',
	dependencies = {
		'neovim/nvim-lspconfig'
	},
	config = function ()
		local navic = require("nvim-navic")

		navic.setup({
			icons = {
				File          = "󰈙 ",
				Module        = " ",
				Namespace     = "󰌗 ",
				Package       = " ",
				Class         = "󰌗 ",
				Method        = "󰆧 ",
				Property      = " ",
				Field         = " ",
				Constructor   = " ",
				Enum          = "󰕘",
				Interface     = "󰕘",
				Function      = "󰊕 ",
				Variable      = "󰆧 ",
				Constant      = "󰏿 ",
				String        = "󰀬 ",
				Number        = "󰎠 ",
				Boolean       = "◩ ",
				Array         = "󰅪 ",
				Object        = "󰅩 ",
				Key           = "󰌋 ",
				Null          = "󰟢 ",
				EnumMember    = " ",
				Struct        = "󰌗 ",
				Event         = " ",
				Operator      = "󰆕 ",
				TypeParameter = "󰊄 ",
			},
			lsp = {
				auto_attach = true,
				preference = nil,
			},
			highlight = true,
			separator = " > ",
			depth_limit = 6,
			depth_limit_indicator = "..",
			safe_output = true,
			lazy_update_context = false,
			click = false,
			format_text = function(text)
				return text
			end,
		})
		vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
	end
}

