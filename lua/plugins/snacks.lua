return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
        indent = {
            enabled = true,

            -- 背景灰色普通缩进线
            indent = {
                priority = 1,
                enabled = true,       -- enable indent guides
                char = "│",
                only_scope = false,   -- only show indent guides of the scope
                only_current = false, -- only show indent guides in the current window
            },

            -- 当前所在代码块
            scope = {
                enabled = true, -- enable highlighting the current scope
                priority = 200,
                char = "│",
                underline = false,    -- underline the start of the scope
                only_current = false, -- only show scope in the current window
                hl = "SnacksIndentScope", ---@type string|string[] hl group for scopes
            },
        },
        ---@class snacks.lazygit.Config: snacks.terminal.Opts
        ---@field args? string[]
        ---@field theme? snacks.lazygit.Theme
        lazygit = {
            enabled = true,
        },
        ---@class snacks.bigfile.Config
        ---@field enabled? boolean
        bigfile = {
            notify = true,            -- show notification when big file detected
            size = 1.5 * 1024 * 1024, -- 1.5MB
            line_length = 1000,       -- average line length (useful for minified files)
            -- Enable or disable features when big file detected
            ---@param ctx {buf: number, ft:string}
            setup = function(ctx)
                if vim.fn.exists(":NoMatchParen") ~= 0 then
                    vim.cmd([[NoMatchParen]])
                end
                Snacks.util.wo(0, { foldmethod = "manual", statuscolumn = "", conceallevel = 0 })
                vim.b.completion = false
                vim.b.minianimate_disable = true
                vim.b.minihipatterns_disable = true
                vim.schedule(function()
                    if vim.api.nvim_buf_is_valid(ctx.buf) then
                        vim.bo[ctx.buf].syntax = ctx.ft
                    end
                end)
            end,
        },
        bufdelete = {
            quit = true, -- close window if the last buffer is deleted
        },
    },
    keys = {
        {
            "<leader>gg",
            function()
                require('snacks').lazygit()
            end,
            desc = "Open LazyGit"
        },
    },
}
