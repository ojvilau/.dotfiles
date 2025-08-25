-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- optionally enable 24-bit colour
vim.opt.termguicolors = true

return {
	{
		"echasnovski/mini.nvim",
		config = function()
			require("mini.icons").setup()
			MiniIcons.mock_nvim_web_devicons()

			require("mini.statusline").setup({ use_icons = true })
			require("mini.notify").setup()
			require("mini.surround").setup()
			require("mini.pairs").setup()
		end,
	},
	{
		--[[ 		"nvim-tree/nvim-tree.lua",
		config = function()
			require("nvim-tree").setup({
				git = { timeout = 5000 },
			})

			vim.keymap.set("n", "<leader>e", "<Cmd>NvimTreeToggle<Cr>", { desc = "Toggle NvimTree", silent = true })
		end, ]]
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			-- "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
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
