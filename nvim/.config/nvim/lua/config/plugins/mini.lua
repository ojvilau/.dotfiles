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
		"nvim-tree/nvim-tree.lua",
		config = function()
			require("nvim-tree").setup({
				git = { timeout = 5000 },
			})

			vim.keymap.set("n", "<leader>e", "<Cmd>NvimTreeToggle<Cr>", { desc = "Toggle NvimTree", silent = true })
		end,
	},
}
