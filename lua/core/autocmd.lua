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
