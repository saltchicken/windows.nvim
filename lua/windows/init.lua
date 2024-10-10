local Windows = {}
Windows.__index = Windows

function Windows:new()
	local obj = setmetatable({}, Windows)
	obj.active_windows = {}
	obj.floating_window_id = 1777
	return obj
end

function Windows:floating_window(opts, content)
	print("Creating window") -- print("hello")
	local buf = vim.api.nvim_create_buf(false, true)

	if opts.fullscreen == true then
		local screen_width = vim.o.columns
		local screen_height = vim.o.lines
		opts.width = math.floor(screen_width * 0.9)
		opts.height = math.floor(screen_height * 0.9)
	end

	if opts.centered == true then
		opts.col = math.floor((vim.o.columns - opts.width) / 2)
		opts.row = math.floor(((vim.o.lines - opts.height) / 2) - 1)
	end

	local win_opts = {
		relative = "editor",
		width = opts.width,
		height = opts.height,
		col = opts.col,
		row = opts.row,
		style = "minimal",
		border = "single",
		footer = opts.footer,
		win = self.floating_window_id,
	}

	vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)

	local win = vim.api.nvim_open_win(buf, true, win_opts)

	vim.api.nvim_create_autocmd({ "BufWipeout", "BufDelete", "BufWinLeave" }, {
		buffer = buf,
		callback = function()
			if opts.on_exit then
				opts.on_exit()
			end
		end,
	})

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
