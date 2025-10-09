vim.g.mapleader = " "

-- ===============================
-- Clipboard & Deletion
-- ===============================
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank line to system clipboard" })

vim.keymap.set({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete without affecting default register" })
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste without overwriting yank buffer" })

-- ===============================
-- Text Formatting & Movement
-- ===============================
vim.keymap.set("n", "=ap", "ma=ap'a", { desc = "Re-indent paragraph and restore cursor" })
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines, keep cursor in place" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up" })

-- ===============================
-- Scrolling & Search
-- ===============================
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down, recenter" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up, recenter" })

vim.keymap.set("n", "n", "nzzzv", { desc = "Next search match centered and unfolded" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search match centered and unfolded" })

-- ===============================
-- Quickfix & Location List Navigation
-- ===============================
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz", { desc = "Next quickfix item" })
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz", { desc = "Previous quickfix item" })

vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz", { desc = "Next location list item" })
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz", { desc = "Previous location list item" })

-- ===============================
-- Utilities
-- ===============================
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], {
  desc = "Substitute word under cursor in file",
})

-- ===============================
-- Python
-- ===============================
vim.keymap.set("n", "<leader>ro", function()
  vim.cmd("silent! s/Optional\\[\\([^]]\\+\\)\\]/\\1 | None/g")
end, { desc = "Replace Optional[...] with ... | None (current line)" })

vim.keymap.set("n", "<leader>rao", function()
  vim.cmd("silent! %s/Optional\\[\\([^]]\\+\\)\\]/\\1 | None/g")
end, { desc = "Replace Optional[...] with ... | None (entire file)" })
