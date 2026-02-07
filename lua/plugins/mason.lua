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
        cmd = "Mason",
        opts_extend = { "ensure_installed" },
        opts = {
            ensure_installed = {
                "clangd",
                "cmake-language-server", -- LSP
                "cmakelang",             -- Format
                "cmakelint",             -- Lint
                "lua-language-server",
                "python-lsp-server",
                "codelldb",
            }
        },
        dependencies = {
            { "mason-org/mason-registry" },
        },
        ---@param opts MasonSettings | {ensure_installed: string[]}
        config = function(_, opts)
            require("mason").setup(opts)
            local mr = require("mason-registry")
            mr:on("package:install:success", function()
                vim.defer_fn(function()
                    -- trigger FileType event to possibly load this newly installed LSP server
                    require("lazy.core.handler.event").trigger({
                        event = "FileType",
                        buf = vim.api.nvim_get_current_buf(),
                    })
                end, 100)
            end)

            mr.refresh(function()
                for _, tool in ipairs(opts.ensure_installed) do
                    local p = mr.get_package(tool)
                    if not p:is_installed() then
                        p:install()
                    end
                end
            end)
        end,
    },
}
