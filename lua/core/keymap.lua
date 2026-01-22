local map = vim.keymap.set

local get_icon = require("util.icons").get_icon

map({ "n" }, "<C-q>", "<cmd>qa<CR>", { desc = "Quit Neovim" })
map({ "n" }, "<leader>q", "<cmd>wqa!<CR>", { desc = "Force quit Neovim" })

map({ "i", "n", "v", "s" }, "<C-s>", "<Cmd>w<CR>", { desc = "Save file", silent = true })

-- map({ "i", "n" }, "<C-a>", "<Cmd>normal! ggVG<CR>", { silent = true, desc = "Select all" })

-- LSP
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
map({ 'v', 'n' }, 'K', function() vim.lsp.buf.hover() end, { desc = "Hover symbol details" })
-- Function signature help
map({ 'v', 'n' }, 'gK', function() vim.lsp.buf.signature_help() end, { desc = "Signature help" })
map({ 'n' }, '<leader>lh', function() vim.lsp.buf.signature_help() end, { desc = "Signature help" })

map({ "n" }, "<Leader>lf", function() vim.lsp.buf.format() end, { desc = "Format buffer", })
map({ "n" }, "<A-S-f>", function() vim.lsp.buf.format() end, { desc = "Format buffer", })
map({ "v" }, "<Leader>lf", function() vim.lsp.buf.format() end, { desc = "Format range buffer", })

map({ "n" }, "<Leader>/", "gcc", { remap = true, desc = "Toggle comment line" })
map({ "x" }, "<Leader>/", "gc", { remap = true, desc = "Toggle comment" })
map({ "n" }, "<C-_>", "gcc", { remap = true, desc = "Toggle comment line" })
map({ "x" }, "<C-_>", "gc", { remap = true, desc = "Toggle comment" })
