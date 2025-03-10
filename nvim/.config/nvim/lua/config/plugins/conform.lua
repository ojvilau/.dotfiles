return {
	"stevearc/conform.nvim",
	config = function()
		local prettier = { "prettierd", "prettier", stop_after_first = true }
		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				-- Conform will run the first available formatter
				javascript = prettier,
				typescript = prettier,
				javascriptreact = prettier,
				typescriptreact = prettier,
				svelte = prettier,
				css = prettier,
				html = prettier,
				json = prettier,
				yaml = prettier,
				markdown = prettier,
			},
			format_on_save = function(bufnr)
				-- Disable with a global or buffer-local variable
				if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
					return
				end
				return { timeout_ms = 500, lsp_format = "fallback" }
			end,
		})

		vim.api.nvim_create_user_command("FormatDisable", function(args)
			if args.bang then
				-- FormatDisable! will disable formatting globally
				vim.g.disable_autoformat = true
			else
				-- FormatDisable will disable formatting for current buffer
				vim.b.disable_autoformat = true
			end
		end, {
			desc = "Disable autoformat-on-save",
			bang = true,
		})
		vim.api.nvim_create_user_command("FormatEnable", function()
			vim.b.disable_autoformat = false
			vim.g.disable_autoformat = false
		end, {
			desc = "Re-enable autoformat-on-save",
		})
	end,
}
