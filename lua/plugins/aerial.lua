return {
    'stevearc/aerial.nvim',
    event = { "LspAttach" },
    keys = {
        { "<F12>",      "<Cmd>AerialToggle!<CR>", desc = "Toggle Aerial" },
        { "<leader>lo", "<Cmd>AerialToggle!<CR>", desc = "Toggle Aerial" },
    },
    opts = {
        -- optionally use on_attach to set keymaps when aerial has attached to a buffer
        -- on_attach = function(bufnr)
        --     -- Jump forwards/backwards with '{' and '}'
        --     -- vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
        --     -- vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
        -- end,
        nerd_font = require("core.options").nerd_fonts and "auto" or false,
        use_icon_provider = require("core.options").nerd_fonts,
        dense = not require("core.options").nerd_fonts,
        layout = {
            max_width = { 40, 0.25 },
            min_width = 16,
            resize_to_content = true,
            preserve_equality = true,
        },
        keymaps = {
            ["q"] = {
                callback = function() vim.cmd [[ :AerialClose ]] end,
                desc = "Close the aerial window",
                nowait = true,
            },
        },
    },
}
