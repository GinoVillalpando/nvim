vim.g.mapleader = " "

-- :Ex command exit file
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- remove mapping for paste on _p
vim.keymap.set("n", "<leader>p", "<nop>")

-- move highlighted lines up and down
vim.keymap.set("v", "K", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "J", ":m '<-2<CR>gv=gv")

-- page up and down (centered cursor)
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-f>", "<C-u>zz")

-- copy paragraph
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- no Q (bad)
vim.keymap.set("n", "Q", "<nop>")

-- make script executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- i still dont know paste for something idk
vim.keymap.set("x", "<leader>p", [["_dP]])

-- save current file
vim.keymap.set("n", "<leader>w", ":file<CR>")

-- auto closing pairs
vim.keymap.set('i', '{<cr>', '{<cr>}<ESC>kA<CR>', {})
closing_pairs = {'}', ')', ']', '"', "'", '>'}
opening_pairs = {'{', '(', '[', '"', "'", '<'}
for key, chr in pairs(opening_pairs)
do
  vim.keymap.set('i', chr, chr..closing_pairs[key]..'<esc>i', {})
end


-- find and replace word on cursor
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
