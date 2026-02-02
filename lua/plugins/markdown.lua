return {
    {
        'MeanderingProgrammer/render-markdown.nvim',
        ft = { "markdown" },
        -- enabled = false,
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' }, -- if you use the mini.nvim suite
        -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' },        -- if you use standalone mini plugins
        -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
        ---@module 'render-markdown'
        ---@type render.md.UserConfig
        opts_extend = { "file_types" },
        keys = {
            { "<leader>Mr", "<cmd>RenderMarkdown enable<cr>",  desc = "Enable Render Markdown" },
            { "<leader>Mc", "<cmd>RenderMarkdown disable<cr>", desc = "Disable Render Markdown" },
        },
        opts = {
            file_types = { 'markdown' },
            sign = { enabled = false },
            heading = {
                icons = { '󰼏 ', '󰎨 ', '󰼑 ', '󰎲 ', '󰼓 ', '󰎴 ' },
            }
        },
    },
    {
        "OXY2DEV/markview.nvim",
        ft = { "markdown" },
        keys = {
            { "<leader>Mp", "<cmd>Markview splitToggle<cr>", desc = "Toggle MarkView" },
        },
        opts = {
            headings = {
                heading_1 = { sign = "" },
                heading_2 = { sign = "" },
            },
            code_blocks = { sign = false },
        },
    },
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = ":call mkdp#util#install()",
        keys = {
            { "<leader>MP", "<cmd>MarkdownPreviewToggle<cr>", desc = "Toggle Markdown Preview(browser)" },
            { "<leader>Ms", "<cmd>MarkdownPreviewStop<cr>",   desc = "Stop Markdown Preview" },
            { "<leader>Mm", "<cmd>MarkdownPreview<cr>",       desc = "Start Markdown Preview" },
        }
    },
}
