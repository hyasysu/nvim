local map = vim.keymap.set

-- Quickfix and Location list
map({ "n" }, "<Leader>xq", "<Cmd>copen<CR>", { desc = "Quickfix List" })
map({ "n" }, "<Leader>xl", "<Cmd>lopen<CR>", { desc = "Location List" })

-- Code Runner
map({ "n" }, "<Leader>rr", function() require("custom_plugins.compile_run").compileRun() end,
    { silent = true, desc = "Compile and Run" })


map({ "n" }, "<leader>lo", "<Cmd>AerialToggle!<CR>", { desc = "Toggle Aerial" })
map({ "n" }, "<leader>lO", "<Cmd>Lspsaga outline<CR>", { desc = "Toggle Lspsaga Outline" })

-- LSP, default `gra`
map({ "n", "x" }, "<Leader>la", function() vim.lsp.buf.code_action() end, { desc = "LSP code action" })
map({ "n" }, "<Leader>lA", function() vim.lsp.buf.code_action { context = { only = { "source" }, diagnostics = {} } } end,
    { desc = "LSP source action", })

local function lsp_references()
    Snacks.picker.lsp_references()
    -- if pcall(require, 'telescope.builtin') then
    --     require('telescope.builtin').lsp_references()
    -- else
    --     vim.lsp.buf.references()
    -- end
end
map({ "n", "v" }, "grr", lsp_references, { desc = "LSP references" })
map({ "n", "v" }, "<leader>lr", lsp_references, { desc = "LSP references" })

map({ "n" }, "<leader>lz", "<cmd>Lspsaga finder<CR>", { desc = "Lspsags references and implementation" })
map({ "n" }, "<leader>lZ", "<cmd>Lspsaga finder def+ref+imp+tyd+dec<CR>",
{ desc = "Lspsags references and implementation" })
map({ "n" }, "<F60>", "<cmd>Lspsaga finder def+ref+imp+tyd+dec<CR>", { desc = "Lspsags references and implementation" })
map({ "n" }, "<M-F12>", "<cmd>Lspsaga finder def+ref+imp+tyd+dec<CR>", { desc = "Lspsags references and implementation" })

-- map({ "n", "v" }, "gy", "<cmd>Telescope lsp_type_definitions<CR>", { desc = 'Goto type definition' })
map({ "n", "v" }, "grt", function() Snacks.picker.lsp_type_definitions() end, { desc = 'Goto type definition' })
map({ "n", "v" }, "<leader>lt", function() Snacks.picker.lsp_type_definitions() end, { desc = 'Goto type definition' })

-- map({ "n", "v" }, "gri", "<cmd>Telescope lsp_implementations<CR>", { desc = 'Find implementations' })
map({ "n", "v" }, "gri", function() Snacks.picker.lsp_implementations() end, { desc = 'Goto Implementation' })
map({ "n", "v" }, "<leader>li", function() Snacks.picker.lsp_implementations() end, { desc = 'Goto Implementation' })

map({ "n" }, "grT", "<cmd>Lspsaga peek_type_definition<CR>", { desc = "Lspsaga peek_type_definition" })
map({ "n" }, "grI", "<cmd>Lspsaga peek_definition<CR>", { desc = "Lspsaga peek_definition" })

map({ "n" }, "<leader>lc", function() Snacks.picker.lsp_incoming_calls() end, { desc = "C[a]lls Incoming", })
map({ "n" }, "<leader>lC", function() Snacks.picker.lsp_outgoing_calls() end, { desc = "C[a]lls Outgoing", })

-- 查看类型继承图
map({ "n", "v" }, "<leader>lu", function() vim.lsp.buf.typehierarchy("subtypes") end,
    { desc = 'List derived class hierarchy' })
map({ "n", "v" }, "<leader>lU", function() vim.lsp.buf.typehierarchy("supertypes") end,
    { desc = 'List base class hierarchy' })

-- 查找符号定义
-- map("n", "gd", "<cmd>Telescope lsp_definitions<CR>", { desc = 'Goto definition' })
map("n", "gd", function() Snacks.picker.lsp_definitions() end, { desc = 'Goto definition' })
map("n", "<F12>", function() Snacks.picker.lsp_definitions() end, { desc = 'Goto definition' })
-- 查找符号声明
map("n", "gD", function() vim.lsp.buf.declaration() end, { desc = 'Goto declaration' })

map({ "n" }, "<leader>lS", function() Snacks.picker.lsp_symbols() end,
    { desc = 'LSP[Snacks] Symbols' })

map({ "n" }, "<Leader>ls",
    function()
        if require("util").is_available "aerial.nvim" then
            require("telescope").extensions.aerial.aerial()
        else
            require("telescope.builtin").lsp_document_symbols()
        end
    end, { desc = "Search symbols", })

-- Rename symbol
map({ 'v', 'n' }, 'gn', function() return ":IncRename " .. vim.fn.expand("<cword>") end,
    { expr = true, desc = 'Rename symbol' })
map({ 'v', 'n' }, '<F2>', function() return ":IncRename " .. vim.fn.expand("<cword>") end,
    { expr = true, desc = 'Rename symbol' })
map({ 'v', 'n' }, 'gN', function() return ":IncRename " end, { expr = true, desc = 'Rename symbol' })
map({ "n" }, "grn", function() vim.lsp.buf.rename() end, { desc = "Rename current symbol" })
map({ "n" }, "<leader>ln", "Lspsaga rename<CR>", { desc = "Rename current symbol" })

map({ "n", "v" }, "<leader>lR", "<cmd>LspStop | LspStart<CR>", { silent = true, desc = "Restart LSP" })

map({ "n", "v" }, "gz", "<cmd>Trouble lsp toggle<CR>", { desc = 'Toggle LSP trouble' })

-- 头文件/源文件跳转
map({ "n", "v" }, "<A-o>", "<cmd>LspClangdSwitchSourceHeader<CR>", { silent = true, desc = "Switch source/header file" })
map({ "n" }, "<leader>lw", "<cmd>LspClangdSwitchSourceHeader<CR>", { silent = true, desc = "Switch source/header file" })

-- 开关静态分析错误列表
map("n", "gss", "<cmd>Trouble diagnostics toggle<CR>", { desc = 'Toggle LSP diagnostics trouble' })
-- 开关编译器报错列表
map("n", "gsl", "<cmd>cclose | Trouble qflist toggle<CR>", { desc = 'Toggle LSP loclist trouble' })

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

map({ "v", "n" }, "<leader>le", function()
    if vim.lsp.inlay_hint ~= nil then
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
    end
end, { desc = "Toggle inlay hint" })

-- Lookup hover details
map({ 'v', 'n' }, '<leader>lk', function() vim.lsp.buf.hover({ border = "rounded" }) end,
    { desc = "Hover symbol details" })
map({ 'v', 'n' }, 'K', "<cmd>Lspsaga hover_doc<CR>", { desc = "Hover symbol details" })

-- Function signature help
map({ 'v', 'n' }, 'gK', function() vim.lsp.buf.signature_help() end, { desc = "Signature help" })
map({ 'n' }, '<leader>lh', function() vim.lsp.buf.signature_help() end, { desc = "Signature help" })

map({ "n" }, "<Leader>lf", function() vim.lsp.buf.format() end, { desc = "Format buffer", })
-- map({ "n", "i", "v" }, "<M-S-f>", function() vim.lsp.buf.format() end, { desc = "Format buffer", })
map({ "v" }, "<Leader>lf", function() vim.lsp.buf.format() end, { desc = "Format range buffer", })

map({ "n" }, "<Leader>/", "gcc", { remap = true, desc = "Toggle comment line" })
map({ "x" }, "<Leader>/", "gc", { remap = true, desc = "Toggle comment" })
map({ "n" }, "<C-_>", "gcc", { remap = true, desc = "Toggle comment line" })
map({ "x" }, "<C-_>", "gc", { remap = true, desc = "Toggle comment" })
-- kitty need
map({ "n" }, "<C-/>", "gcc", { remap = true, desc = "Toggle comment line" })
map({ "x" }, "<C-/>", "gc", { remap = true, desc = "Toggle comment" })

map({ "n", "x" }, "<leader>cr", function() vim.lsp.codelens.run() end, { desc = "Run Codelens", })
map({ "n" }, "<leader>cR", function() vim.lsp.codelens.refresh() end, { desc = "Refresh & Display Codelens", })
