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


-- find and replace word on cursor
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
