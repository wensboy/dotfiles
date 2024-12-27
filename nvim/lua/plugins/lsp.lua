return {
	{
		'williamboman/mason.nvim',
		build = ":MasonUpdate",
		config = function()
			require("mason").setup()
		end
	},
	{
		'williamboman/mason-lspconfig.nvim',
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {"lua_ls"}
			})
		end
	},
	{
		'neovim/nvim-lspconfig',
		config = function()
			local lsp = require("lspconfig")
			local navic = require("nvim-navic")

		local on_attach = function (client, bufnr)
			if client.server_capabilities.documentSymbolProvider then
				navic.attach(client, bufnr)
			end
		end

		lsp.lua_ls.setup({
			on_attach = on_attach
		})

		end
	}
}
