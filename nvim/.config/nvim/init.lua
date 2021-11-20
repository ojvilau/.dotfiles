vim.bo.expandtab = true
vim.bo.shiftwidth = 2
vim.bo.softtabstop = 2
vim.o.number = true

require('packer').startup(function()
  use 'Mofiqul/vscode.nvim'
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use 'neovim/nvim-lspconfig'
  use {
    'hoob3rt/lualine.nvim',
    requires = {'kyazdani42/nvim-web-devicons', opt = true}
  }
  use 'glepnir/lspsaga.nvim'
end)

vim.g.vscode_style = "dark"
vim.cmd[[colorscheme vscode]]

require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", 
  ignore_install = { "jsonc" },
  highlight = {
    enable = true,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

require'lspconfig'.tsserver.setup{}
require'lspsaga'.init_lsp_saga()
require('lualine').setup {
  options = {
    theme = 'vscode'
  }
}

local keymap = vim.api.nvim_set_keymap
local opts = { noremap=true, silent=true }
keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)

