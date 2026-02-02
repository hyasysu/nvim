return {
    {
        "RRethy/vim-illuminate",
        event = { "BufReadPost", "BufNewFile", "BufWritePost" },
        keys = {
            { "]r",         function() require("illuminate")["goto_next_reference"](false) end, desc = "Next reference" },
            { "[r",         function() require("illuminate")["goto_prev_reference"](false) end, desc = "Previous reference" },
            { "<Leader>ur", function() require("illuminate").toggle_buf() end,                  desc = "Toggle reference highlighting (buffer)" },
            { "<Leader>uR", function() require("illuminate").toggle() end,                      desc = "Toggle reference highlighting (global)" },
        },
        opts = {
            delay = 200,
            min_count_to_highlight = 1,
            should_enable = function(bufnr)
                local buf_utils = require "util".buffer
                return buf_utils.is_valid(bufnr) and not buf_utils.is_large(bufnr)
            end,
        },
        config = function(_, opts)
            require("illuminate").configure(opts)
            local group = vim.api.nvim_create_augroup("vim_illuminate_autocmds", { clear = true })
            vim.api.nvim_create_autocmd("ColorScheme", {
                group = group,
                callback = function()
                    --     vim.cmd [[
                    -- hi def IlluminatedWordText guifg=none guibg=#3a3f45 gui=bold
                    -- hi def IlluminatedWordRead guifg=none guibg=#3a3f45 gui=bold
                    -- hi def IlluminatedWordWrite guifg=none guibg=#3a3f45 gui=bold
                    -- ]]
                    local bg = vim.o.background
                    if bg == "dark" then
                        vim.api.nvim_set_hl(0, "IlluminatedWordText", { fg = "none", bg = "#3a3f45", bold = true })
                        vim.api.nvim_set_hl(0, "IlluminatedWordRead", { fg = "none", bg = "#3a3f45", bold = true })
                        vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { fg = "none", bg = "#3a3f45", bold = true })
                    else
                        vim.api.nvim_set_hl(0, "IlluminatedWordText", { fg = "none", bg = "#e0e0e0", bold = true })
                        vim.api.nvim_set_hl(0, "IlluminatedWordRead", { fg = "none", bg = "#e0e0e0", bold = true })
                        vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { fg = "none", bg = "#e0e0e0", bold = true })
                    end
                end,
            })
        end,
    },
    {
        "brenoprata10/nvim-highlight-colors",
        event = "VeryLazy",
        cmd = "HighlightColors",
        opts = { enabled_named_colors = false },
    }
}
