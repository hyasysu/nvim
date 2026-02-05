return {
    {
        "mason-org/mason-lspconfig.nvim",
        opts = {
            ensure_installed = {},
        },
        event = "VeryLazy",
        keys = {
            {
                "<leader>lI",
                function()
                    -- "<cmd>MasonInstall clangd cmake-language-server lua-language-server python-lsp-server codelldb<cr>",
                    local registry = require("mason-registry")
                    local packages = {
                        "clangd",
                        "cmake-language-server",
                        "lua-language-server",
                        "python-lsp-server",
                        "codelldb",
                    }
                    for _, package_name in ipairs(packages) do
                        if not registry.is_installed(package_name) then
                            local package = registry.get_package(package_name)
                            package:install()
                            vim.notify("Installing " .. package_name .. " via Mason.", vim.log.levels.INFO,
                                { icon = require("util.icons").get_icon("ui", "Mason"), title = "Mason" })
                        else
                            vim.notify(package_name .. " is already installed.", vim.log.levels.INFO,
                                { icon = require("util.icons").get_icon("ui", "Mason"), title = "Mason" })
                        end
                    end
                end,
                mode = { "n" },
                desc = "Mason Install clangd, cmake, lua, python, codelldb",
            },
        },
        dependencies = {
            { "mason-org/mason.nvim",    opts = {} },
            { "mason-org/mason-registry" },
            { "neovim/nvim-lspconfig", }
        },
    },
    {
        "mason-org/mason.nvim",
        opts_extend = { "ensure_installed" },
        opts = { ensure_installed = { "tree-sitter-cli" } },
    },
}
