-- NeotreeAutoCmds

-- 1. Create an augroup for Neo-tree auto commands
local neotree_group = vim.api.nvim_create_augroup("NeotreeAutoCmds", { clear = true })

-- 2. Auto Command 1: Open Neo-Tree on startup with directory
vim.api.nvim_create_autocmd("BufEnter", {
    group = neotree_group,
    desc = "Open Neo-Tree on startup with directory",
    callback = function()
        -- If neo-tree is already loaded, return
        if package.loaded["neo-tree"] then
            return
        end

        -- Check if the current buffer is a directory
        local bufname = vim.api.nvim_buf_get_name(0)
        if bufname == "" then
            return
        end

        -- Use uv (Neovim's filesystem API) to check if it's a directory
        local stat
        if vim.uv then -- Neovim 0.10+
            stat = vim.uv.fs_stat(bufname)
        else           -- Neovim 0.9 and below
            stat = vim.loop.fs_stat(bufname)
        end

        if stat and stat.type == "directory" then
            require("lazy").load({ plugins = { "neo-tree.nvim" } })
        end
    end,
    once = false,
})

-- 3. autocmd 2: Refresh neo-tree when closing lazygit
vim.api.nvim_create_autocmd("TermClose", {
    group = neotree_group,
    pattern = "*lazygit*", -- Only trigger for lazygit terminal
    desc = "Refresh Neo-Tree sources when closing lazygit",
    callback = function()
        local manager_avail, manager = pcall(require, "neo-tree.sources.manager")
        if not manager_avail or not manager then
            return
        end

        -- Refresh relevant sources
        local sources_to_refresh = { "filesystem", "git_status", "document_symbols" }
        for _, source_name in ipairs(sources_to_refresh) do
            local module_name = "neo-tree.sources." .. source_name
            if package.loaded[module_name] then
                local source_module = require(module_name)
                manager.refresh(source_module.name)
            end
        end
    end,
})


-- BufferlineAutoCmds

local bufferline_group = vim.api.nvim_create_augroup("BufferlineAutoCmds", { clear = true })

-- Function to close empty and unnamed buffers
local function close_empty_unnamed_buffers()
    -- Get a list of all buffers
    local buffers = vim.api.nvim_list_bufs()

    -- Iterate over each buffer
    for _, bufnr in ipairs(buffers) do
        -- Check if the buffer is empty and doesn't have a name
        if vim.api.nvim_buf_is_loaded(bufnr) and vim.api.nvim_buf_get_name(bufnr) == '' and
            -- vim.api.nvim_buf_get_option(bufnr, 'buftype') == ''
            vim.bo[bufnr].buftype == '' then
            -- Close the buffer if it's empty:
            if vim.api.nvim_buf_line_count(bufnr) == 1 then
                local lines = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)
                if #lines == 0 or lines[0] == nil or #lines[0] == 0 then
                    vim.api.nvim_buf_delete(bufnr, {
                        force = true,
                    })
                end
            end
        end
    end
end

-- Clear the mandatory, empty, unnamed buffer when a real file is opened:
-- vim.api.nvim_command('autocmd BufReadPost * lua require("config.bufferline_setup").close_empty_unnamed_buffers()')
vim.api.nvim_create_autocmd("BufReadPost", {
    group = bufferline_group,
    desc = "Close empty and unnamed buffers when a real file is opened",
    callback = close_empty_unnamed_buffers,
})


-- Set up CursorHold autocommand to show diagnostics on hover
-- vim.api.nvim_create_autocmd("CursorHold", {
--     callback = function()
--         vim.diagnostic.open_float({
--             focusable = false,
--             close_events = {
--                 "BufLeave",
--                 "CursorMoved",
--                 "InsertEnter",
--                 "FocusLost"
--             },
--             border = "rounded", -- Changed from "rounded" to "none"
--             source = "if_many",
--             prefix = "",
--         })
--     end
-- })

-- Set up LspAttach autocmd for per-buffer configuration
vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        vim.notify("LSP attached " .. client.name .. ".", vim.log.levels.INFO,
            { icon = require("util.icons").get_icon("ui", "ActiveLSP"), title = "LSP" })
    end
})

-- Dashboard footer autocommand
-- local function show_dashboard()
--     if vim.fn.argc() == 0 and vim.bo.filetype == "" then
--         -- Only show dashboard if no files are opened
--         vim.schedule(function()
--             -- 使用 pcall 避免函数不存在时报错
--             local ok, result = pcall(function()
--                 return Snacks.dashboard()
--             end)

--             if not ok then
--                 -- dashboard failed to load, notify the user
--                 vim.notify("Failed to load Snacks dashboard: " .. result, vim.log.levels.ERROR, {
--                     title = "Snacks Dashboard",
--                 })
--             end
--         end)
--     end
-- end
local function show_dashboard()
    -- 只有在没有传递参数给neovim时才考虑session和dashboard
    if vim.fn.argc() == 0 then
        -- 检查persistence.nvim是否可用
        local has_persistence, persistence = pcall(require, "persistence")
        local has_session = false

        if has_persistence then
            -- 获取当前目录
            local cwd = persistence.current()
            if vim.fn.filereadable(cwd) == 0 then
                cwd = persistence.current({ branch = false })
            end
            -- 获取所有session
            local sessions = persistence.list()
            if cwd and vim.fn.filereadable(cwd) ~= 0 then
                vim.schedule(function()
                    persistence.load()
                end)
                return
            end
        end

        vim.schedule(function()
            -- 使用pcall安全地调用dashboard
            if Snacks and Snacks.dashboard then
                Snacks.dashboard()
            else
                -- 后备方案，比如显示一个空缓冲区或者什么都不做
                print("No session found and Snacks.dashboard not available")
            end
        end)
    end
end

-- 创建 User 事件
vim.api.nvim_create_autocmd("User", {
    pattern = "LazyVimStarted", -- Custom event name
    desc = "Add snacks.nvim dashboard footer",
    once = true,
    callback = show_dashboard,
})

-- vim.api.nvim_create_autocmd("User", {
--     pattern = "PersistenceLoadPost",
--     desc = "Open Neo-Tree after loading session",
--     callback = function()
--         vim.cmd [[Neotree]]
--         if vim.bo.filetype == "neo-tree" then
--             vim.cmd.wincmd "p"
--         end
--     end
-- })

-- 确保 normal 模式的函数
local function ensure_normal_mode()
    local mode = vim.api.nvim_get_mode().mode
    if mode == "i" or mode == "t" then
        vim.cmd("stopinsert")
    end
end

-- 监听 session 加载完成事件
vim.api.nvim_create_autocmd("User", {
    pattern = "PersistenceLoadPost",
    desc = "Ensure normal mode after loading session",
    callback = function()
        vim.defer_fn(ensure_normal_mode, 1000)
    end,
})

-- MarkdownAutoCmds

local markdown_group = vim.api.nvim_create_augroup("MarkdownAutoCmds", { clear = true })

-- Function if filetype is markdown, and buftype is '' then enable render-markdown.nvim and disable markview.nvim
local function markdown_ensure_right_plugins(args)
    if vim.bo.filetype == "markdown" then
        if vim.bo.buftype == "" then
            -- Enable render-markdown.nvim
            local ok, render_markdown = pcall(require, "render-markdown.core.manager")
            if ok and render_markdown then
                render_markdown.set_buf(args.buf, true)
            end

            -- Disable markview.nvim
            local ok2, markview = pcall(require, "markview")
            if ok2 and markview then
                vim.schedule(function()
                    markview.actions.disable(args.buf)
                end)
            end
        elseif vim.bo.buftype == "nofile" then
            -- Disable render-markdown.nvim
            local ok, render_markdown = pcall(require, "render-markdown.core.manager")
            if ok and render_markdown then
                vim.schedule(function()
                    render_markdown.set_buf(args.buf, false)
                end)
            end

            -- Enable markview.nvim
            local ok2, markview = pcall(require, "markview")
            if ok2 and markview then
                vim.schedule(function()
                    markview.actions.enable(args.buf)
                end)
            end
        end
    end
end

vim.api.nvim_create_autocmd({ "FileType" }, {
    group = markdown_group,
    pattern = "markdown",
    desc = "Enable render-markdown.nvim and disable markview.nvim for markdown files",
    callback = markdown_ensure_right_plugins,
})

-- lualine autocmd on ColorScheme
local lualine_winbar_group = vim.api.nvim_create_augroup("lualine_group", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
    group = lualine_winbar_group,
    callback = function()
        if not require('core.options').lualine_winbar_show then
            vim.defer_fn(function()
                require('lualine').hide({
                    place = { 'winbar' }, -- The segment this change applies to.
                    unhide = false,       -- whether to re-enable lualine again/
                })
            end, 100)
        end
    end,
})

-- LSP - blink.cmp
vim.api.nvim_create_autocmd('InsertEnter', {
    group = vim.api.nvim_create_augroup('blink_capabilities', {clear = true}),
    once = true,
    callback = function ()
        -- Set default capabilities for all LSP servers
        if require("core.options").cmp == "blink" and require("util").is_available('blink.cmp') then
            vim.notify("Configuring blink.cmp capabilities to all LSP servers", vim.log.levels.INFO,
                { icon = require("util.icons").get_icon("ui", "ActiveLSP"), title = "LSP" })
            vim.lsp.config('*', {
                capabilities = require('blink.cmp').get_lsp_capabilities(),
            })
        end
    end,
})

