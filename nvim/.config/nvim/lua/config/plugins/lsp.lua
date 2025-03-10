local servers = {
  "cssls",
  "html",
  "eslint",
  "ts_ls",
  "jsonls",
  "lua_ls",
}

local lsp = {
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
      {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
          library = {
            -- Load luvit types when the `vim.uv` word is found
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      }
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = servers,
        automatic_installation = false,
        handlers = {
          function(server_name)
            require("lspconfig")[server_name].setup {}
          end
        }
      })
    end
  }
}

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then return end

    ---@diagnostic disable-next-line
    if client.supports_method("textDocument/formatting") then
      -- Format the current buffer on save
      vim.api.nvim_create_autocmd('BufWritePre', {
        buffer = args.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
        end,
      })
    end

    local opts = { buffer = args.buf }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  end,
})

return lsp
