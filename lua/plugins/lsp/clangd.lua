return {
    -- Add C/C++ to treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        opts = { ensure_installed = { "cpp" } },
    },

    {
        "p00f/clangd_extensions.nvim",
        lazy = true,
        config = function() end,
        opts = {
            inlay_hints = {
                inline = false,
            },
            ast = {
                --These require codicons (https://github.com/microsoft/vscode-codicons)
                role_icons = {
                    type = "",
                    declaration = "",
                    expression = "",
                    specifier = "",
                    statement = "",
                    ["template argument"] = "",
                },
                kind_icons = {
                    Compound = "",
                    Recovery = "",
                    TranslationUnit = "",
                    PackExpansion = "",
                    TemplateTypeParm = "",
                    TemplateTemplateParm = "",
                    TemplateParamObject = "",
                },
            },
        },
    },

    -- Correctly setup lspconfig for clangd 🚀
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                -- Ensure mason installs the server
                clangd = {
                    keys = {
                    },
                    root_markers = {
                        '.clangd',
                        '.clang-tidy',
                        '.clang-format',
                        "compile_commands.json",
                        "compile_flags.txt",
                        "configure.ac", -- AutoTools
                        "Makefile",
                        "configure.ac",
                        "configure.in",
                        "config.h.in",
                        "meson.build",
                        "meson_options.txt",
                        "build.ninja",
                        ".git",
                    },
                    capabilities = {
                        offsetEncoding = { "utf-8", "utf-16" },
                    },
                    cmd = {
                        "clangd",
                        "--background-index",
                        "--clang-tidy",
                        "--header-insertion=iwyu",
                        "--completion-style=detailed",
                        "--function-arg-placeholders",
                        "--fallback-style=llvm",
                    },
                    single_file_support = true,
                    init_options = {
                        usePlaceholders = true,
                        completeUnimported = true,
                        clangdFileStatus = true,
                    },
                },
            },
            setup = {
                clangd = function(_, opts)
                    local clangd_ext_opts = require('util').opts("clangd_extensions.nvim")
                    require("clangd_extensions").setup(vim.tbl_deep_extend("force", clangd_ext_opts or {},
                        { server = opts }))
                    return false
                end,
            },
        },
    },
}
