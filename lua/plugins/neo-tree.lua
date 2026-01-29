return {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
    },
    cmd = "Neotree",
    keys = {
        { "<leader>e", "<cmd>Neotree toggle<CR>", desc = "Toggle NeoTree" },
        {
            "<Leader>n",
            function()
                if vim.bo.filetype == "neo-tree" then
                    vim.cmd.wincmd "p"
                else
                    vim.cmd.Neotree "focus"
                end
            end,
            desc = "Toggle Explorer Focus",
        }
    },
    opts = function(_, opts)
        -- 1. Check if related features are available
        local git_available = vim.fn.executable "git" == 1
        local get_icon = require("util.icons").get_icon

        -- 2. Define configuration table
        local sources = {
            { source = "filesystem",  display_name = get_icon("documents", "Folder", 1) .. "File" },
            { source = "buffers",     display_name = get_icon("documents", "DefaultFile", 1) .. "Bufs" },
            { source = "diagnostics", display_name = get_icon("diagnostics", "General", 1) .. "Diagnostic" },
        }
        if git_available then
            table.insert(sources, 3, { source = "git_status", display_name = get_icon("git", "Git", 1) .. "Git" })
        end

        local opts = require("util").extend_tbl(opts, {
            enable_git_status = git_available,
            auto_clean_after_session_restore = true,
            close_if_last_window = true,
            sources = { "filesystem", "buffers", git_available and "git_status" or nil },
            source_selector = {
                winbar = true,
                content_layout = "center",
                sources = sources,
            },
            default_component_configs = {
                indent = {
                    padding = 0,
                    expander_collapsed = get_icon("documents", "Folder"),
                    expander_expanded = get_icon("documents", "OpenFolder"),
                },
                icon = {
                    folder_closed = get_icon("documents", "Folder"),
                    folder_open = get_icon("documents", "OpenFolder"),
                    folder_empty = get_icon("documents", "EmptyFolder"),
                    folder_empty_open = get_icon("documents", "EmptyOpenFolder"),
                    default = get_icon("documents", "DefaultFile"),
                },
                modified = { symbol = get_icon("documents", "FileModified") },
                git_status = {
                    symbols = {
                        added = get_icon("git", "Add"),
                        deleted = get_icon("git", "Remove"),
                        modified = get_icon("git", "Mod"),
                        renamed = get_icon("git", "Rename"),
                        untracked = get_icon("git", "Untrack"),
                        ignored = get_icon("git", "Ignored"),
                        unstaged = get_icon("git", "Unstaged"),
                        staged = get_icon("git", "Staged"),
                        conflict = get_icon("git", "Conflict"),
                    },
                },
            },
            commands = {
                system_open = function(state)
                    (vim.ui.open)(state.tree:get_node():get_id())
                end,
                parent_or_close = function(state)
                    local node = state.tree:get_node()
                    if node:has_children() and node:is_expanded() then
                        state.commands.toggle_node(state)
                    else
                        require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
                    end
                end,
                child_or_open = function(state)
                    local node = state.tree:get_node()
                    if node:has_children() then
                        if not node:is_expanded() then -- if unexpanded, expand
                            state.commands.toggle_node(state)
                        else                           -- if expanded and has children, select the next child
                            if node.type == "file" then
                                state.commands.open(state)
                            else
                                require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
                            end
                        end
                    else -- if has no children
                        state.commands.open(state)
                    end
                end,
                copy_selector = function(state)
                    local node = state.tree:get_node()
                    local filepath = node:get_id()
                    local filename = node.name
                    local modify = vim.fn.fnamemodify

                    local vals = {
                        ["BASENAME"] = modify(filename, ":r"),
                        ["EXTENSION"] = modify(filename, ":e"),
                        ["FILENAME"] = filename,
                        ["PATH (CWD)"] = modify(filepath, ":."),
                        ["PATH (HOME)"] = modify(filepath, ":~"),
                        ["PATH"] = filepath,
                        ["URI"] = vim.uri_from_fname(filepath),
                    }

                    local options = vim.tbl_filter(function(val) return vals[val] ~= "" end, vim.tbl_keys(vals))
                    if vim.tbl_isempty(options) then
                        vim.notify("No values to copy", vim.log.levels.WARN)
                        return
                    end
                    table.sort(options)
                    vim.ui.select(options, {
                        prompt = "Choose to copy to clipboard:",
                        format_item = function(item) return ("%s: %s"):format(item, vals[item]) end,
                    }, function(choice)
                        local result = vals[choice]
                        if result then
                            vim.notify(("Copied: `%s`"):format(result))
                            vim.fn.setreg("+", result)
                        end
                    end)
                end,
            },
            window = {
                width = 30,
                mappings = {
                    ["<S-CR>"] = "system_open",
                    ["<Space>"] = false,
                    ["[b"] = "prev_source",
                    ["]b"] = "next_source",
                    O = "system_open",
                    Y = "copy_selector",
                    h = "parent_or_close",
                    l = "child_or_open",
                },
                fuzzy_finder_mappings = {
                    ["<C-J>"] = "move_cursor_down",
                    ["<C-K>"] = "move_cursor_up",
                },
            },
            filesystem = {
                follow_current_file = { enabled = true },
                filtered_items = { hide_gitignored = git_available },
                hijack_netrw_behavior = "open_current",
                use_libuv_file_watcher = vim.fn.has "win32" ~= 1,
                filtered_items = {
                    visible = false,
                    hide_dotfiles = false,
                    hide_gitignored = false,
                    hide_hidden = false,
                }
            },
        })

        -- 3. add event handlers
        if not opts.event_handlers then opts.event_handlers = {} end
        table.insert(opts.event_handlers, {
            event = "neo_tree_buffer_enter",
            handler = function(_)
                vim.opt_local.signcolumn = "auto"
                vim.opt_local.foldcolumn = "0"
            end,
        })

        -- 4. Conditional integration with other plugins (Telescope)
        if require("util").is_available("telescope.nvim") then
            opts.commands.find_in_dir = function(state)
                local node = state.tree:get_node()
                local path = node.type == "file" and node:get_parent_id() or node:get_id()
                require("telescope.builtin").find_files { cwd = path }
            end
            opts.window.mappings.F = "find_in_dir"
        end

        -- 5. Conditional integration with other plugins (ToggleTerm)
        if require("util").is_available "toggleterm.nvim" then
            local function toggleterm_in_direction(state, direction)
                local node = state.tree:get_node()
                local path = node.type == "file" and node:get_parent_id() or node:get_id()
                require("toggleterm.terminal").Terminal:new({ dir = path, direction = direction }):toggle()
            end
            local prefix = "T"
            ---@diagnostic disable-next-line: assign-type-mismatch
            opts.window.mappings[prefix] =
            { "show_help", nowait = false, config = { title = "New Terminal", prefix_key = prefix } }
            for suffix, direction in pairs { f = "float", h = "horizontal", v = "vertical" } do
                local command = "toggleterm_" .. direction
                opts.commands[command] = function(state) toggleterm_in_direction(state, direction) end
                opts.window.mappings[prefix .. suffix] = command
            end
        end

        return opts
    end
}
