return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts_extend = { "spec", "disable.ft", "disable.bt" },
    config = function(_, opts)
        local wk = require("which-key")
        local get_icon = require("util.icons").get_icon
        wk.setup(opts)
        wk.add({
            { "<leader>a", group = "Avante",         icon = get_icon("ui", "Avante", 1) },
            { "<leader>b", group = "Buffers",        icon = get_icon("ui", "Buffer", 1) },
            { "<leader>c", group = "AI",             icon = get_icon("ui", "AI", 1) },
            { "<leader>d", group = "Debugger",       icon = get_icon("dap", "Debugger", 1) },
            { "<leader>e", group = "Neotree",        icon = get_icon("ui", "NeoTree", 1) },
            { "<leader>f", group = "Find",           icon = get_icon("ui", "Search", 1) },
            { "<leader>F", group = "Snacks Picker",  icon = get_icon("ui", "Search2", 1) },
            { "<leader>g", group = "Git/Copilot",    icon = get_icon("git", "Git", 1) },
            { "<leader>l", group = "LSP",            icon = get_icon("ui", "ActiveLSP", 1) },
            { "<leader>m", group = "MultiCursor",    icon = get_icon("ui", "Cursor", 1) },
            { "<leader>M", group = "Markdown",       icon = get_icon("ui", "Markdown", 1) },
            { "<leader>o", group = "Overseer",       icon = get_icon("ui", "Overseer", 1) },
            { "<leader>p", group = "Paste",          icon = get_icon("ui", "Clipboard", 1) },
            { "<leader>r", group = "CodeRun",        icon = get_icon("ui", "Run", 1) },
            { "<leader>s", group = "Session/Switch", icon = get_icon("ui", "Session", 1) },
            { "<leader>t", group = "Terminal",       icon = get_icon("ui", "Terminal", 1) },
            { "<leader>u", group = "UI/UX",          icon = get_icon("ui", "Window", 1) },
            { "<leader>v", group = "venv",           icon = get_icon("ui", "Venv", 1) },
            { "<leader>w", group = "Tools",          icon = get_icon("ui", "Tools", 1) },
            { "<leader>x", group = "Quickfix/Lists", icon = get_icon("ui", "List", 1) },
            { "<leader>y", group = "Copy",           icon = get_icon("ui", "Copy", 1) },
            { "gr",        group = "LSP",            icon = get_icon("ui", "ActiveLSP", 1) },
        }, {
            mode = { "n", "v", "i", "t" },
        })
    end,
}
