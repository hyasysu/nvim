return {
    "linux-cultist/venv-selector.nvim",
    ft = "python", -- Load when opening Python files
    dependencies = {
        "neovim/nvim-lspconfig",
        "nvim-telescope/telescope.nvim",
        "mfussenegger/nvim-dap-python",
    },
    keys = {
        { "<leader>vs", "<cmd>VenvSelect<cr>",       desc = "Select VirtualEnv" },        -- Open picker on keymap
        { "<leader>vc", "<cmd>VenvSelectCached<cr>", desc = "Select Cached VirtualEnv" }, -- Open cached picker on keymap
    },
    cmd = {
        "VenvSelect",
        "VenvSelectCached",
    },
    opts = {
        settings = {
            options = {
                cached_venv_automatic_activation = false, -- enable VenvSelectCached
            },
        },
    },
}
