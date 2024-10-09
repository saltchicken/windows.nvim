local Windows = {}
Windows.__index = Windows

function Windows:new()
	local obj = setmetatable({}, Windows)
	obj.active_windows = {}
	return obj
end

function Windows:floating_window(width, height, col, row, footer)
	local buf = vim.api.nvim_create_buf(false, true)

	local win_opts = {
		relative = "editor",
		width = width,
		height = height,
		col = col,
		row = row,
		style = "minimal",
		border = "single",
		footer = footer,
	}
	local win = vim.api.nvim_open_win(buf, true, win_opts)
	table.insert(self.active_windows, { win, buf })
end

return Windows
