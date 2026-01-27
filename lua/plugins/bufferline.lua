local plain = not require("core.options").nerd_fonts

return {
    "akinsho/bufferline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    -- dependencies = { "famiu/bufdelete.nvim" },
    opts = {
        options = {
            buffer_close_icon = plain and 'x' or nil,  -- Close icon for each buffer
            modified_icon = plain and '*' or nil,      -- "●"
            left_trunc_marker = plain and '<' or nil,  -- ""
            right_trunc_marker = plain and '>' or nil, -- ""

            offsets = {
                {
                    filetype = "NvimTree", -- 文件树，如 Neo-tree 窗口左侧的偏移
                    text = "Project",      -- Display text for the offsets
                    text_align = "left",
                    separator = true,      -- Show separator line
                    padding = 0,
                },
                {
                    filetype = "neo-tree",  -- Neo-tree 的文件类型
                    text = "File Explorer", -- Display text for the offsets
                    text_align = "left",
                    separator = true,
                    padding = 0,
                },
            },

            close_command = function(bufnum)
                require('bufdelete').bufdelete(bufnum, true)
            end,
            diagnostics = "nvim_lsp",
            diagnostics_indicator = function(count, level, diagnostics_dict, context)
                return "(" .. count .. ")"
            end,
            sort_by = 'insert_after_current',
            custom_filter = function(buf_number, buf_numbers)
                -- filter out filetypes you don't want to see
                if vim.bo[buf_number].filetype == "qf" then
                    return false
                end
                if vim.bo[buf_number].buftype == "terminal" then
                    return false
                end
                if vim.bo[buf_number].buftype == "nofile" then
                    return false
                end
                if vim.bo[buf_number].filetype == "Trouble" then
                    return false
                end
                -- if string.find(vim.fn.bufname(buf_number), 'term://') == 1 then
                --     return false
                -- end
                return true
            end,
        },
    },
    keys = {
        { "]b",         "<cmd>BufferLineCycleNext<cr>", mode = { "n", "v" }, desc = "Switch to next buffer" },
        { "[b",         "<cmd>BufferLineCyclePrev<cr>", mode = { "n", "v" }, desc = "Switch to previous buffer" },
        { "<b",         "<cmd>BufferLineMovePrev<cr>",  mode = { "n", "v" }, desc = "Move buffer to previous position" },
        { ">b",         "<cmd>BufferLineMoveNext<cr>",  mode = { "n", "v" }, desc = "Move buffer to next position" },

        { "<leader>bp", "<cmd>BufferLineTogglePin<cr>", mode = { "n", "v" }, desc = "Toggle buffer pin" },
        {
            "<leader>bc",
            function()
                Snacks.bufdelete.delete()
            end,
            mode = { "n" },
            desc = "Close buffer"
        },
        { "<leader>bd", "<cmd>BufferLineCloseOthers<cr>",          mode = { "n" }, desc = "Close other buffers" },
        { "<leader>bf", "<cmd>BufferLinePick<cr>",                 mode = { "n" }, desc = "Search and jump to buffer" },

        { "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<cr>", mode = { "n" }, desc = "Close ungrouped buffers", },
    },
}
