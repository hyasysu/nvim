return {
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
    end,
}
