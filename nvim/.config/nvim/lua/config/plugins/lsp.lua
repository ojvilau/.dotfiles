local M = {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "williamboman/mason.nvim", opts = {} },
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)

		local servers = {
			-- See `:help lspconfig-all` for a list of all the pre-configured LSPs
			-- ts_ls = {},
			cssls = {},
			cssmodules_ls = {},
			html = {},
			lua_ls = {
				settings = {
					Lua = {
						completion = {
							callSnippet = "Replace",
						},
						diagnostics = {
							globals = { "vim" },
							disable = { "missing-fields" },
						},
					},
				},
			},
			-- tsgo = {},
		}

		local ensure_installed = vim.tbl_keys(servers or {})
		vim.list_extend(ensure_installed, {
			"stylua", -- Used to format Lua code
			"eslint_d",
			"prettierd",
			"prettier",
		})
		require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

		require("mason-lspconfig").setup({
			ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
			automatic_installation = false,
		})

		for server, config in pairs(servers) do
			config.capabilities = vim.tbl_deep_extend("force", {}, capabilities, config.capabilities or {})
			vim.lsp.config(server, config)
			vim.lsp.enable(server)
		end

		-- vim.lsp.config("tsgo", { capabilities = capabilities })
		-- vim.lsp.enable("tsgo")

		AddDiagnostics()
		CreateAutoCmd()
	end,
}

function AddDiagnostics()
	-- See :help vim.diagnostic.Opts
	vim.diagnostic.config({
		update_in_insert = true,
		severity_sort = true,
		float = { border = "rounded", source = "if_many" },
		underline = { severity = vim.diagnostic.severity.ERROR },
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = "󰅚 ",
				[vim.diagnostic.severity.WARN] = "󰀪 ",
				[vim.diagnostic.severity.INFO] = "󰋽 ",
				[vim.diagnostic.severity.HINT] = "󰌶 ",
			},
		},
		virtual_lines = { current_line = true },
	})
end

function CreateAutoCmd()
	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
		callback = function(event)
			local map = function(keys, func, desc, mode)
				mode = mode or "n"
				vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
			end

			-- Jump to the definition of the word under your cursor.
			--  This is where a variable was first declared, or where a function is defined, etc.
			--  To jump back, press <C-t>.
			map("gd", require("fzf-lua").lsp_definitions, "[G]oto [D]efinition")

			map("K", vim.lsp.buf.hover, "[K] Hover")

			map("<leader>sh", vim.lsp.buf.signature_help, "[S]ignature [H]elp")

			-- Find references for the word under your cursor.
			map("gr", require("fzf-lua").lsp_references, "[G]oto [R]eferences")

			-- Jump to the implementation of the word under your cursor.
			--  Useful when your language has ways of declaring types without an actual implementation.
			map("gI", require("fzf-lua").lsp_implementations, "[G]oto [I]mplementation")

			-- Jump to the type of the word under your cursor.
			--  Useful when you're not sure what type a variable is and you want to see
			--  the definition of its *type*, not where it was *defined*.
			map("<leader>D", require("fzf-lua").lsp_typedefs, "Type [D]efinition")

			-- Fuzzy find all the symbols in your current document.
			--  Symbols are things like variables, functions, types, etc.
			-- map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

			-- Fuzzy find all the symbols in your current workspace.
			--  Similar to document symbols, except searches over your entire project.
			-- map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

			-- Rename the variable under your cursor.
			--  Most Language Servers support renaming across files, etc.
			map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

			-- Execute a code action, usually your cursor needs to be on top of an error
			-- or a suggestion from your LSP for this to activate.
			map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })

			-- WARN: This is not Goto Definition, this is Goto Declaration.
			--  For example, in C this would take you to the header.
			map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

			map("<leader>cl", vim.lsp.codelens.run, "[C]ode[L]ens run")

			-- The following two autocommands are used to highlight references of the
			-- word under your cursor when your cursor rests there for a little while.
			--    See `:help CursorHold` for information about when this is executed
			--
			-- When you move your cursor, the highlights will be cleared (the second autocommand).
			local client = vim.lsp.get_client_by_id(event.data.client_id)
			if
				client
				and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf)
			then
				local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
				vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
					buffer = event.buf,
					group = highlight_augroup,
					callback = vim.lsp.buf.document_highlight,
				})

				vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
					buffer = event.buf,
					group = highlight_augroup,
					callback = vim.lsp.buf.clear_references,
				})

				vim.api.nvim_create_autocmd("LspDetach", {
					group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
					callback = function(event2)
						vim.lsp.buf.clear_references()
						vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
					end,
				})
			end

			-- The following code creates a keymap to toggle inlay hints in your
			-- code, if the language server you are using supports them
			--
			-- This may be unwanted, since they displace some of your code
			if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
				map("<leader>th", function()
					vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
				end, "[T]oggle Inlay [H]ints")
			end
		end,
	})
end

return M
