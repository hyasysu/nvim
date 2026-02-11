return {
    {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-live-grep-args.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                lazy = true,
                enabled = vim.fn.executable "make" == 1 or vim.fn.executable "cmake" == 1,
                build = vim.fn.executable "make" == 1 and "make"
                    or
                    "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
            },
            'stevearc/dressing.nvim',
        },
        opts = function()
            local actions = require "telescope.actions"
            local function open_selected(prompt_bufnr)
                local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
                local selected = picker:get_multi_selection()
                if vim.tbl_isempty(selected) then
                    actions.select_default(prompt_bufnr)
                else
                    actions.close(prompt_bufnr)
                    for _, file in pairs(selected) do
                        if file.path then vim.cmd("edit" .. (file.lnum and " +" .. file.lnum or "") .. " " .. file.path) end
                    end
                end
            end
            local function open_all(prompt_bufnr)
                actions.select_all(prompt_bufnr)
                open_selected(prompt_bufnr)
            end
            return {
                defaults = {
                    path_display = { "truncate" },
                    sorting_strategy = "ascending",
                    layout_config = {
                        horizontal = { prompt_position = "top", preview_width = 0.55 },
                        vertical = { mirror = false },
                        width = 0.87,
                        height = 0.80,
                        preview_cutoff = 120,
                    },
                    mappings = {
                        i = {
                            ["<C-J>"] = actions.move_selection_next,
                            ["<C-K>"] = actions.move_selection_previous,
                            ["<CR>"] = open_selected,
                            ["<M-CR>"] = open_all,
                        },
                        n = {
                            q = actions.close,
                            ["<CR>"] = open_selected,
                            ["<M-CR>"] = open_all,
                        },
                    },
                },
            }
        end,
        config = function(plugin, opts)
            local telescope = require("telescope")
            telescope.setup(opts)

            local is_available = require("util").is_available
            if is_available "nvim-notify" then pcall(telescope.load_extension, "notify") end
            if is_available "aerial.nvim" then pcall(telescope.load_extension, "aerial") end

            local ok, err = pcall(require("telescope").load_extension, "fzf")
            if not ok then
                vim.notify("Failed to load `telescope-fzf-native.nvim`:\n" .. err, vim.log.levels.ERROR)
            end

            ok, err = pcall(require("telescope").load_extension, "live_grep_args")
            if not ok then
                vim.notify("Failed to load `telescope-live-grep-args.nvim`:\n" .. err, vim.log.levels.ERROR)
            end
        end,
        keys = {
            {
                "<leader>Fg",
                function()
                    if vim.fn.executable "rg" == 1 then
                        require('telescope').extensions.live_grep_args.live_grep_args()
                    else
                        vim.notify("rg (ripgrep) is not installed!", vim.log.levels.WARN)
                    end
                end,
                mode = { "n" },
                desc = "Advanced Live Grep"
            },
            {
                "<leader>Fw",
                function()
                    if vim.fn.executable "rg" == 1 then
                        require("telescope.builtin").live_grep()
                    else
                        vim.notify("rg (ripgrep) is not installed!", vim.log.levels.WARN)
                    end
                end,
                mode = { "n" },
                desc = "Find words"
            },
            {
                "<leader>FW",
                function()
                    if vim.fn.executable "rg" == 1 then
                        require("telescope.builtin").live_grep {
                            additional_args = function(args) return vim.list_extend(args, { "--hidden", "--no-ignore" }) end,
                        }
                    else
                        vim.notify("rg (ripgrep) is not installed!", vim.log.levels.WARN)
                    end
                end,
                mode = { "n" },
                desc = "Find words in all files",
            },
            { "<leader>Ff", function() require("telescope.builtin").find_files() end,  mode = { "n" }, desc = "Find files" },
            {
                "<leader>FF",
                function() require("telescope.builtin").find_files { hidden = false, no_ignore = true } end,
                mode = { "n" },
                desc = "Find all files",
            },

            { "<leader>Fb", function() require("telescope.builtin").buffers() end,     mode = { "n" }, desc = "Find buffers" },
            { "<leader>Fc", function() require("telescope.builtin").grep_string() end, mode = { "n" }, desc = "Find word under cursor" },
            { "<leader>FC", function() require("telescope.builtin").commands() end,    mode = { "n" }, desc = "Find commands" },

            { "<leader>Fh", function() require("telescope.builtin").help_tags() end,   mode = { "n" }, desc = "Find help" },
            { "<leader>Fk", function() require("telescope.builtin").keymaps() end,     mode = { "n" }, desc = "Find keymaps" },
            { "<leader>FM", function() require("telescope.builtin").man_pages() end,   mode = { "n" }, desc = "Find man pages" },
            { "<leader>Fm", function() require("telescope.builtin").marks() end,       mode = { "n" }, desc = "Find marks" },
            {
                "<leader>fn",
                function()
                    if require("util").is_available "nvim-notify" then
                        require("telescope").extensions.notify.notify()
                    else
                        vim.notify("nvim-notify is not installed!", vim.log.levels.WARN)
                    end
                end,
                mode = { "n" },
                desc = "Find notifications(Telescope)"
            },
            { "<leader>Fo", function() require("telescope.builtin").oldfiles() end,                                                    mode = { "n" }, desc = "Find history" },
            { "<leader>Fr", function() require("telescope.builtin").registers() end,                                                   mode = { "n" }, desc = "Find registers" },
            { "<leader>Ft", function() require("telescope.builtin").colorscheme { enable_preview = true, ignore_builtins = true } end, mode = { "n" }, desc = "Find themes" },

            { "<Leader>lD", function() require("telescope.builtin").diagnostics() end,                                                 mode = { "n" }, desc = "Search diagnostics" },
        },
    },
    {
        "ibhagwan/fzf-lua",
        -- optional for icon support
        dependencies = { "nvim-tree/nvim-web-devicons" },
        -- or if using mini.icons/mini.nvim
        -- dependencies = { "nvim-mini/mini.icons" },
        ---@module "fzf-lua"
        ---@type fzf-lua.Config|{}
        ---@diagnostic disable: missing-fields
        opts = {}
        ---@diagnostic enable: missing-fields
    },
    -- better vim.ui with telescope
    -- {
    --     "stevearc/dressing.nvim",
    --     lazy = true,
    --     init = function()
    --         ---@diagnostic disable-next-line: duplicate-set-field
    --         vim.ui.select = function(...)
    --             require("lazy").load({ plugins = { "dressing.nvim" } })
    --             return vim.ui.select(...)
    --         end
    --         ---@diagnostic disable-next-line: duplicate-set-field
    --         vim.ui.input = function(...)
    --             require("lazy").load({ plugins = { "dressing.nvim" } })
    --             return vim.ui.input(...)
    --         end
    --     end,
    -- },
}
