return {
    {
        'MeanderingProgrammer/render-markdown.nvim',
        ft = { "markdown" },
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' }, -- if you use the mini.nvim suite
        -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' },        -- if you use standalone mini plugins
        -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
        ---@module 'render-markdown'
        ---@type render.md.UserConfig
        opts = {
            sign = { enabled = false },
        },
    },
    {
        "OXY2DEV/markview.nvim",
        ft = { "markdown" },
        opts = {
            headings = {
                heading_1 = { sign = "" },
                heading_2 = { sign = "" },
            },
            code_blocks = { sign = false },
        },
    },
    {
        "toppair/peek.nvim",
        ft = { "markdown" },
        event = { "VeryLazy" },
        build = "deno task --quiet build:fast",
        config = function()
            require("peek").setup()
            vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
            vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
        end,
    },
}
