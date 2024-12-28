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

			local to_attach = function(client, bufnr)
				if client.server_capabilities.documentSymbolProvider then
					require("nvim-navic").attach(client, bufnr)
				end
			end

			lsp.lua_ls.setup{
				on_init = function(client)
					if client.workspace_folders then
						local path = client.workspace_folders[1].name
						if vim.loop.fs_stat(path..'/.luarc.json') or vim.loop.fs_stat(path..'/.luarc.jsonc') then
							return
						end
					end
				client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua,
				{
					runtime = {
						 version = 'LuaJIT',
					},
					workspace = {
						checkThirdParty = false,
						library = {
							vim.env.VIMRUNTIME,
						}
					}
				})
				end,
				settings = {
					Lua = {
						diagnostics = {
							globals = {
								"vim",
							},
						}
					}
				},
				filetypes = {'lua'},
				on_attach = to_attach
				}
		end
	}
}
