vim.opt.number = true                           -- Show line numbers
vim.opt.relativenumber = false                  -- Do not show relative line numbers
vim.opt.signcolumn = "yes"                      -- Always show the sign column

vim.opt.ignorecase = true                       -- Ignore case in search patterns
vim.opt.smartcase = true                        -- Override 'ignorecase' if search pattern contains uppercase letters

vim.opt.clipboard = "unnamedplus"               -- Use system clipboard for all operations

vim.opt.tabstop = 4                             -- Number of spaces that a <Tab> counts formatted
vim.opt.shiftwidth = 4                          -- Number of spaces to use for each step of (auto)indent
vim.opt.expandtab = true                        -- Use spaces instead of tabs
vim.opt.smartindent = true                      -- Enable smart indentation

vim.opt.cursorline = true                       -- Highlight the current line

vim.opt.termguicolors = true                    -- Enable 24-bit RGB colors

vim.opt.scrolloff = 6                           -- Minimum number of screen lines to keep above and below the cursor
vim.opt.sidescrolloff = 8                       -- Minimum number of screen columns to keep to the left and right of the cursor

vim.opt.undofile = true                         -- Enable persistent undofile

vim.opt.laststatus = 2                          -- Always show the status line

vim.opt.formatoptions:remove({ "c", "r", "o" }) -- Do not continue comments on new lines

local default_opts = {
    nerd_fonts = true,
    disable_notify = false,
    transparent_color = true,
    more_cpp_ftdetect = true,
    enable_signature_help = false,
    enable_inlay_hint = true,
    enable_clipboard = true,
    cmp = "blink", -- The engineer of cmp ["blink", "nvim.cmp"]
}

return default_opts
