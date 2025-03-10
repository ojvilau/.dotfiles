local _opts = { noremap = false, silent = false }
local set = function(mode, keys, command, opts)
	vim.keymap.set(mode, keys, command, opts or _opts)
end

-- set("i", "kj", "<ESC>")

-- set("n", "<leader>rw", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>", {})

-- Move text up and down
set("i", "<C-j>", "<Esc>v :m '>+1<CR>== i")
set("i", "<C-k>", "<Esc>v :m '<-2<CR>== i")
set("n", "<C-j>", "v :m '>+1<CR>==")
set("n", "<C-k>", "v :m '<-2<CR>==")
set("v", "<C-j>", ":m '>+1<CR>gv=gv")
set("v", "<C-k>", ":m '<-2<CR>gv=gv")

-- Stay in indent mode
set("n", "<", "V<")
set("n", ">", "V>")
set("v", "<", "<gv")
set("v", ">", ">gv")

-- -- Save and quit
-- set({ "n", "i" }, "<C-s>", "<Esc>:w<CR>")
-- set({ "n", "i" }, "<C-S>", "<Esc>:wa<CR>")
-- set("n", "<leader>q", ":Bdelete<CR>")
-- set("n", "<leader>x", ":qa<CR>")

-- -- Remap eol and sol
-- set("n", "H", "^")
-- set("n", "L", "$")
-- set("v", "H", "^")
-- set("v", "L", "$")
-- set("x", "H", "^")
-- set("x", "L", "$")
-- set("o", "H", "^")
-- set("o", "L", "$")

-- -- Better window navigation
-- set("n", "<m-h>", "<C-w>h")
-- set("n", "<m-j>", "<C-w>j")
-- set("n", "<m-k>", "<C-w>k")
-- set("n", "<m-l>", "<C-w>l")
--
-- -- Resize with arrows
-- set("n", "<C-Up>", ":resize -2<CR>")
-- set("n", "<C-Down>", ":resize +2<CR>")
-- set("n", "<C-Left>", ":vertical resize +2<CR>")
-- set("n", "<C-Right>", ":vertical resize -2<CR>")
--
-- -- Buffers navigation
-- set("n", "<Tab>", ":bn<CR>")
-- set("n", "<S-Tab>", ":bp<CR>")
-- set("n", "<C-l>", ":bn<CR>")
-- set("n", "<C-h>", ":bp<CR>")
-- set("i", "<C-l>", ":bn<CR>")
-- set("i", "<C-h>", ":bp<CR>")
--
-- -- Search and replace
-- set("v", "<leader>sr", '"hy:%s/<C-r>h//gc<left><left><left>')
