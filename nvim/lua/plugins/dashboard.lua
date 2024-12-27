return {
	'nvimdev/dashboard-nvim',
	dependencies = {
		'nvim-tree/nvim-web-devicons'
	},
	event = 'VimEnter',
	config = function()
		local db = require("dashboard")
		db.setup({
			theme = 'doom',
			shortcut_type = 'letter',
			hide = {
			},
			config = {
				header = {
					'',

					' ██████╗  █████╗ ███████╗██╗  ██╗██████╗  ██████╗  █████╗ ██████╗ ██████╗  ',

					' ██╔══██╗██╔══██╗██╔════╝██║  ██║██╔══██╗██╔═══██╗██╔══██╗██╔══██╗██╔══██╗ ',

					' ██║  ██║███████║███████╗███████║██████╔╝██║   ██║███████║██████╔╝██║  ██║ ',

					' ██║  ██║██╔══██║╚════██║██╔══██║██╔══██╗██║   ██║██╔══██║██╔══██╗██║  ██║ ',

					' ██████╔╝██║  ██║███████║██║  ██║██████╔╝╚██████╔╝██║  ██║██║  ██║██████╔╝ ',

					' ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝  ',

					'',
				},
				center = {
					{
						icon = ' ',
						icon_hl = 'Title',
						desc = 'Find               ',
						desc_hl = 'String',
						key = 'f',
						keymap = 'SPC k f',
						key_hl = 'Number',
						key_format = ' %s',
						action = 'lua require("telescope.builtin").find_files()'
					},
					{
						icon = '󰒲 ',
						desc = 'Lazy               ',
						key = 'l',
						keymap = 'SPC k l',
						key_format = ' %s',
						action = ':Lazy'
					},
					{
						icon = '󰰑 ',
						desc = 'Mason               ',
						key = 'm',
						keymap = 'SPC k m',
						key_format = ' %s',
						action = ':Mason'
					},
					{
						icon = '󰿅 ',
						desc = 'Exit               ',
						key = 'e',
						keymap = 'SPC k e',
						key_format = ' %s',
						action = ':q'
					}
				},
				footer = {}
			}
		})
	end
}
