return {
    {
        "AndrewRadev/switch.vim",
        lazy = true,
        keys = {
            { '<leader>st', function() vim.cmd [[Switch]] end, desc = "Switch strings" },
        },
        config = function(_, opts)
            vim.cmd [[
                let g:switch_mapping = "-"
            ]]
            vim.g.switch_custom_definitions = {
                { "> [!TODO]", "> [!WIP]", "> [!DONE]", "> [!FAIL]" },
                { "- [ ]",     "- [>]",    "- [x]" },
                { "height",    "width" },
            }
        end
    }
}
