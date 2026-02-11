return {
    "lewis6991/gitsigns.nvim",
    enabled = vim.fn.executable "git" == 1,
    event = { "BufReadPost", "BufNewFile", "BufWritePost" },
    keys = {
        -- { "<leader>gl", function() require("gitsigns").blame_line() end,                                    mode = { "n" },           desc = "View Git blame" },
        -- { "<leader>gL", function() require("gitsigns").blame_line { full = true } end,                      mode = { "n" },           desc = "View full Git blame" },
        { "<leader>gl", function() Snacks.picker.git_log() end,                                             mode = { "n" },           desc = "View Git Log" },
        { "<leader>gL", function() Snacks.git.blame_line() end,                                             mode = { "n" },           desc = "View Git blame line" },
        { "<leader>gb", function() Snacks.picker.git_branches() end,                                        mode = { "n" },           desc = "View Git Branches" },
        { "<leader>gp", function() require("gitsigns").preview_hunk_inline() end,                           mode = { "n" },           desc = "Preview Git hunk" },
        { "<leader>gr", function() require("gitsigns").reset_hunk() end,                                    mode = { "n" },           desc = "Reset Git hunk" },
        { "<leader>gr", function() require("gitsigns").reset_hunk { vim.fn.line ".", vim.fn.line "v" } end, mode = { "v" },           desc = "Reset Git hunk", },
        { "<leader>gR", function() require("gitsigns").reset_buffer() end,                                  mode = { "n" },           desc = "Reset Git buffer" },
        { "<leader>gs", function() require("gitsigns").stage_hunk() end,                                    mode = { "n" },           desc = "Stage Git hunk" },
        { "<leader>gs", function() require("gitsigns").stage_hunk { vim.fn.line ".", vim.fn.line "v" } end, mode = { "v" },           desc = "Stage Git hunk", },
        { "<leader>gS", function() require("gitsigns").stage_buffer() end,                                  desc = "Stage Git buffer" },
        { "<leader>gu", function() require("gitsigns").undo_stage_hunk() end,                               desc = "Unstage Git hunk" },
        { "<leader>gd", function() require("gitsigns").diffthis() end,                                      desc = "View Git diff" },

        { "[G",         function() require("gitsigns").nav_hunk "first" end,                                mode = { "n" },           desc = "First Git hunk" },
        { "]G",         function() require("gitsigns").nav_hunk "last" end,                                 mode = { "n" },           desc = "Last Git hunk" },
        { "]g",         function() require("gitsigns").nav_hunk "next" end,                                 mode = { "n" },           desc = "Next Git hunk" },
        { "[g",         function() require("gitsigns").nav_hunk "prev" end,                                 mode = { "n" },           desc = "Previous Git hunk" },

        { "ig",         ":<C-U>Gitsigns select_hunk<CR>",                                                   mode = { "o", "x" },      desc = "inside Git hunk" },
    },
    opts = {
        current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
    },
}
