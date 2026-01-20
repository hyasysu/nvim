local map = vim.keymap.set

map("n", "<C-q>", "<cmd>wqa<CR>", { desc = "Quit Neovim" })
map({ "i", "n", "v", "s" }, "<C-s>", "<Cmd>w<CR>", { silent = true, desc = "Save file" })

-- map({ "i", "n" }, "<C-a>", "<Cmd>normal! ggVG<CR>", { silent = true, desc = "Select all" })
