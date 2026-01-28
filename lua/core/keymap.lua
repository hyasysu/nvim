local map = vim.keymap.set

local get_icon = require("util.icons").get_icon

map({ "n" }, "<C-q>", "<cmd>qa<CR>", { desc = "Quit Neovim" })
map({ "n" }, "<leader>q", "<cmd>wqa!<CR>", { desc = "Force quit Neovim" })

map({ "i", "n", "v", "s" }, "<C-s>", "<Cmd>w<CR>", { desc = "Save file", silent = true })

-- Ctrl+Insert Copy; Shift+Insert Paste
map({ "n", "v" }, "<C-Insert>", "\"+y", { silent = true, desc = "Copy to system clipboard" })
map("i", "<C-Insert>", "<Esc>\"+yya", { silent = true, desc = "Copy to system clipboard" })
map({ "n", "v" }, "<S-Insert>", "\"+p", { silent = true, desc = "Paste from system clipboard" })
map("i", "<S-Insert>", "<C-r>+", { silent = true, desc = "Paste from system clipboard" })

-- map({ "i", "n" }, "<C-a>", "<Cmd>normal! ggVG<CR>", { silent = true, desc = "Select all" })

if not pcall(require, 'tmux') then
    map({ 'v', 'n', 'i', 't' }, '<C-h>', [[<Cmd>wincmd h<CR>]], { desc = "Move to left window" })
    map({ 'v', 'n', 'i', 't' }, '<C-j>', [[<Cmd>wincmd j<CR>]], { desc = "Move to bottom window" })
    map({ 'v', 'n', 'i', 't' }, '<C-k>', [[<Cmd>wincmd k<CR>]], { desc = "Move to top window" })
    map({ 'v', 'n', 'i', 't' }, '<C-l>', [[<Cmd>wincmd l<CR>]], { desc = "Move to right window" })
else
    map({ 'v', 'i', 't' }, '<C-h>', [[<Cmd>lua require'tmux'.move_left()<CR>]], { desc = "Move to left tmux pane" })
    map({ 'v', 'i', 't' }, '<C-j>', [[<Cmd>lua require'tmux'.move_bottom()<CR>]], { desc = "Move to bottom tmux pane" })
    map({ 'v', 'i', 't' }, '<C-k>', [[<Cmd>lua require'tmux'.move_top()<CR>]], { desc = "Move to top tmux pane" })
    map({ 'v', 'i', 't' }, '<C-l>', [[<Cmd>lua require'tmux'.move_right()<CR>]], { desc = "Move to right tmux pane" })
end
map({ 'v', 'n', 'i', 't' }, '<C-S-h>', [[<Cmd>wincmd H<CR>]], { desc = "Move window to left" })
map({ 'v', 'n', 'i', 't' }, '<C-S-j>', [[<Cmd>wincmd J<CR>]], { desc = "Move window to bottom" })
map({ 'v', 'n', 'i', 't' }, '<C-S-k>', [[<Cmd>wincmd K<CR>]], { desc = "Move window to top" })
map({ 'v', 'n', 'i', 't' }, '<C-S-l>', [[<Cmd>wincmd L<CR>]], { desc = "Move window to right" })
map({ 'v', 'n', 'i', 't' }, '<M-r>', [[<Cmd>wincmd r<CR>]], { desc = "Rotate windows" })
map({ 'v', 'n', 'i', 't' }, '<M-x>', [[<Cmd>wincmd x<CR>]], { desc = "Swap windows" })
map({ 'v', 'n', 'i', 't' }, '<M-s>', [[<Cmd>wincmd s<CR>]], { desc = "Split window horizontally" })
map({ 'v', 'n', 'i', 't' }, '<M-v>', [[<Cmd>wincmd v<CR>]], { desc = "Split window vertically" })
map({ 'v', 'n', 'i', 't' }, '<M-=>', [[<Cmd>wincmd +<CR>]], { desc = "Increase window height" })
map({ 'v', 'n', 'i', 't' }, '<M-->', [[<Cmd>wincmd -<CR>]], { desc = "Decrease window height" })
map({ 'v', 'n', 'i', 't' }, '<M-,>', [[<Cmd>wincmd <Lt><CR>]], { desc = "Decrease window width" })
map({ 'v', 'n', 'i', 't' }, '<M-.>', [[<Cmd>wincmd ><CR>]], { desc = "Increase window width" })
map({ 'v', 'n', 'i', 't' }, '<M-q>', [[<Cmd>wincmd q<CR>]], { desc = "Close current window" })
map('n', '<Esc>', [[<Cmd>nohls<CR><Esc>]], { noremap = true, desc = "Clear search highlighting" })
map('t', '<Esc>', [[<C-\><C-n>]], { noremap = true, desc = "Exit terminal mode" })

-- Notify
map({ "n" }, "<Leader>uD", function() require("notify").dismiss { pending = true, silent = true } end,
    { desc = "Dismiss notifications", })

-- LSP, default `gra`
map({ "n", "x" }, "<Leader>la", function() vim.lsp.buf.code_action() end, { desc = "LSP code action" })
map({ "n" }, "<Leader>lA", function() vim.lsp.buf.code_action { context = { only = { "source" }, diagnostics = {} } } end,
    { desc = "LSP source action", })

local function lsp_references()
    if pcall(require, 'telescope.builtin') then
        require('telescope.builtin').lsp_references()
    else
        vim.lsp.buf.references()
    end
end
map({ "n", "v" }, "grr", lsp_references, { desc = "LSP references" })
map({ "n", "v" }, "<leader>lr", lsp_references, { desc = "LSP references" })

-- Rename symbol
map({ 'v', 'n' }, 'gn', function() return ":IncRename " .. vim.fn.expand("<cword>") end,
    { expr = true, desc = 'Rename symbol' })
map({ 'v', 'n' }, '<F2>', function() return ":IncRename " .. vim.fn.expand("<cword>") end,
    { expr = true, desc = 'Rename symbol' })
map({ 'v', 'n' }, 'gN', function() return ":IncRename " end, { expr = true, desc = 'Rename symbol' })
map({ "n" }, "grn", function() vim.lsp.buf.rename() end, { desc = "Rename current symbol" })

map({ "n", "v" }, "gy", "<cmd>Telescope lsp_type_definitions<CR>", { desc = 'Goto type definition' })

map({ "n", "v" }, "<leader>lR", "<cmd>LspStop | LspStart<CR>", { silent = true, desc = "Restart LSP" })

map({ "n", "v" }, "gri", "<cmd>Telescope lsp_implementations<CR>", { desc = 'Find implementations' })

map({ "n", "v" }, "gz", "<cmd>Trouble lsp toggle<CR>", { desc = 'Toggle LSP trouble' })

-- 查找符号定义
map("n", "gd", "<cmd>Telescope lsp_definitions<CR>", { desc = 'Goto definition' })
-- 查找符号声明
map("n", "gD", function() vim.lsp.buf.declaration() end, { desc = 'Goto declaration' })

-- 查看类型继承图
map({ "n", "v" }, "gst", function() vim.lsp.buf.typehierarchy("subtypes") end, { desc = 'List derived class hierarchy' })
map({ "n", "v" }, "gsT", function() vim.lsp.buf.typehierarchy("supertypes") end, { desc = 'List base class hierarchy' })

-- 头文件/源文件跳转
map({ "n", "v" }, "<A-o>", "<cmd>LspClangdSwitchSourceHeader<CR>", { silent = true, desc = "Switch source/header file" })
map({ "n" }, "<leader>lw", "<cmd>LspClangdSwitchSourceHeader<CR>", { silent = true, desc = "Switch source/header file" })

-- 开关静态分析错误列表
map("n", "gss", "<cmd>Trouble diagnostics toggle<CR>", { desc = 'Toggle LSP diagnostics trouble' })
-- 开关编译器报错列表
map("n", "gsl", "<cmd>cclose | Trouble qflist toggle<CR>", { desc = 'Toggle LSP loclist trouble' })
map("n", "gsg", "<cmd>Neogit<CR>")
-- 当前光标下的静态分析错误
map("n", "gsd", function()
    vim.diagnostic.open_float({
        scope = "cursor",
        focusable = false,
        close_events = {
            "CursorMoved",
            "CursorMovedI",
            "BufHidden",
            "InsertCharPre",
            "WinLeave",
            "BufEnter",
            "BufLeave",
        },
    })
end, { desc = 'Diagnostics under cursor' })

-- Toggle Inlay Hint
vim.api.nvim_create_user_command("LspInlayHintToggle", function()
    if vim.lsp.inlay_hint.is_enabled() then
        vim.lsp.inlay_hint.enable(false)
    else
        vim.lsp.inlay_hint.enable(true)
    end
end, { desc = 'Toggle inlay hints' })

vim.api.nvim_create_user_command("LspDiagnosticsToggle", function()
    if vim.diagnostic.is_enabled() then
        vim.diagnostic.enable(false)
    else
        vim.diagnostic.enable(true)
    end
end, { desc = 'Toggle diagnostics' })

map({ "v", "n" }, "<leader>li", function()
    if vim.lsp.inlay_hint ~= nil then
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
    end
end, { desc = "Toggle inlay hint" })

-- Lookup hover details
map({ 'v', 'n' }, 'K', function() vim.lsp.buf.hover({ border = "rounded" }) end, { desc = "Hover symbol details" })
-- Function signature help
map({ 'v', 'n' }, 'gK', function() vim.lsp.buf.signature_help() end, { desc = "Signature help" })
map({ 'n' }, '<leader>lh', function() vim.lsp.buf.signature_help() end, { desc = "Signature help" })

map({ "n" }, "<Leader>lf", function() vim.lsp.buf.format() end, { desc = "Format buffer", })
map({ "n", "i", "v" }, "<A-S-f>", function() vim.lsp.buf.format() end, { desc = "Format buffer", })
map({ "v" }, "<Leader>lf", function() vim.lsp.buf.format() end, { desc = "Format range buffer", })

map({ "n" }, "<Leader>/", "gcc", { remap = true, desc = "Toggle comment line" })
map({ "x" }, "<Leader>/", "gc", { remap = true, desc = "Toggle comment" })
map({ "n" }, "<C-_>", "gcc", { remap = true, desc = "Toggle comment line" })
map({ "x" }, "<C-_>", "gc", { remap = true, desc = "Toggle comment" })
