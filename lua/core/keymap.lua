local map = vim.keymap.set

map({ "n" }, "<C-q>", "<cmd>qa<CR>", { desc = "Quit Neovim" })
map({ "n" }, "<leader>q", "<cmd>wqa!<CR>", { desc = "Force quit Neovim" })

map({ "i", "n", "v", "s" }, "<C-s>", "<Cmd>w<CR>", { desc = "Save file", silent = true })

-- map({ "i", "n" }, "<C-a>", "<Cmd>normal! ggVG<CR>", { silent = true, desc = "Select all" })
