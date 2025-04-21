return {
	"stevearc/conform.nvim",
	config = function()
		local tsjs = { "eslint_d", "prettierd", "prettier", stop_after_first = true }
		local prettier = { "prettierd", "prettier", stop_after_first = true }
		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				-- Conform will run the first available formatter
				javascript = tsjs,
				typescript = tsjs,
				javascriptreact = tsjs,
				typescriptreact = tsjs,
				svelte = tsjs,
				css = prettier,
				html = tsjs,
				json = tsjs,
				yaml = tsjs,
				markdown = prettier,
			},
			formatter = {
				eslint_d = {
					cwd = require("conform.util").root_file({
						".eslintrc.js",
						".eslintrc.json",
						"eslint.config.js",
						"eslint.config.ts",
						"package.json",
					}),
				},
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
