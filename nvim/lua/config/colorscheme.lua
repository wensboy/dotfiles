local colorScheme = "tokyonight"

local state_ok, err = pcall(vim.cmd,"colorscheme "..colorScheme)

if not state_ok then 
	vim.notify("colorScheme "..colorScheme.." not found!".."\n"..err,vim.log.levels.ERROR)
	return
end

vim.cmd("colorscheme "..colorScheme)
