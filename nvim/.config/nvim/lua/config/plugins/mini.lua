-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- optionally enable 24-bit colour
vim.opt.termguicolors = true

return {
	{
		"nvim-mini/mini.icons",
		config = function()
			local mini_icons = require("mini.icons")
			mini_icons.setup()
			mini_icons.mock_nvim_web_devicons()
		end,
	},
	{ "nvim-mini/mini.statusline", version = false, use_icons = true },
	{ "nvim-mini/mini.notify", version = false, opts = {} },
	{ "nvim-mini/mini.surround", version = false, opts = {} },
	{ "nvim-mini/mini.pairs", version = false, opts = {} },
	{ "nvim-mini/mini.trailspace", version = false, opts = {} },
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			-- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
		},
		lazy = false, -- neo-tree will lazily load itself
		keys = {
			{ "<Leader>e", "<Cmd>Neotree reveal toggle<CR>" }, -- change or remove this line if relevant.
		},
		opts = {
			sources = { "filesystem" },
			close_if_last_window = true,
			filesystem = {
				hijack_netrw_behavior = "open_current",
				follow_current_file = {
					enabled = true, -- This will find and focus the file in the active buffer every time
					leave_dirs_open = true, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
				},
			},
		},
	},
}
