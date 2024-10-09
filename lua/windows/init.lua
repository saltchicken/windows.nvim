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

function Windows:yes_no_prompt(question, cb_yes, cb_no)
	local buf = vim.api.nvim_create_buf(false, true)
	local width = 50
	local height = 3
	local footer = "Press 'y' for yes, press 'n' for no"

	local win_opts = {
		relative = "editor",
		width = width,
		height = height,
		col = math.floor((vim.o.columns - width) / 2),
		row = math.floor(((vim.o.lines - height) / 2) - 1),
		style = "minimal",
		border = "single",
		footer = footer,
		footer_pos = "center",
	}

	vim.api.nvim_buf_set_lines(buf, 0, -1, false, { question })

	local win = vim.api.nvim_open_win(buf, true, win_opts)
	table.insert(self.active_windows, { win, buf })

	vim.api.nvim_buf_set_keymap(buf, "n", "y", "", {
		callback = function()
			print("callback called")
			cb_yes()
		end,
	})
	vim.api.nvim_buf_set_keymap(buf, "n", "n", "", {
		callback = function()
			cb_no()
		end,
	})
end

return Windows
