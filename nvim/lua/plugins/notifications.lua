return {
	'rcarriga/nvim-notify',
	lazy = false,
	config = function()
		---@diagnostic disable-next-line: duplicate-set-field
		vim.notify = function(msg, level, opts)
			if msg == 'No information available' then
				return
			end

			return require('notify').notify(msg, level, opts)
		end
	end
}
