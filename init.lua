-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("core.autocmd")
require("core.options")
require("core.keymap")
require("core.lazy")

vim.cmd.colorscheme("vscode")
