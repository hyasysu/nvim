local cmake_callback = function(res, title)
    local get_icon = require("util.icons").get_icon
    if res.code == 0 then
        vim.notify("Successful", vim.log.levels.INFO, { icon = get_icon("cmake", "Default"), title = title })
    else
        vim.notify(res.message, vim.log.levels.WARN, { icon = get_icon("cmake", "Default"), title = title })
    end
end

local cmake_generate_callback = function(res)
    cmake_callback(res, "CMake Generate")
end

local cmake_build_callback = function(res)
    cmake_callback(res, "CMake Build")
end

local cmake_clean_callback = function(res)
    cmake_callback(res, "CMake Clean")
end

local get_dependencies = function()
    local dependencies = { 'nvim-tree/nvim-web-devicons' }
    if require("core.options").ai_assistant.copilot_lua.enabled then
        table.insert(dependencies, "AndreM222/copilot-lualine")
    end
    return dependencies
end

local function switch_tabstop()
    vim.ui.select({ "Spaces:2", "Spaces:4", "Spaces:8", "Tab:2", "Tab:4", "Tab:8" }, {
        prompt = "Select tabstop setting:",
    }, function(choice, idx)
        if idx == nil then
            return
        end
        if choice:find("Spaces") then
            local ts = tonumber(choice:match("Spaces:(%d+)"))
            vim.bo.expandtab = true
            vim.bo.tabstop = ts
            vim.bo.shiftwidth = ts
        elseif choice:find("Tab") then
            local ts = tonumber(choice:match("Tab:(%d+)"))
            vim.bo.expandtab = false
            vim.bo.tabstop = ts
            vim.bo.shiftwidth = ts
        end
    end)
end

local lualine_winbar_enabled = false
local function switch_winbar()
    lualine_winbar_enabled = not lualine_winbar_enabled
    if lualine_winbar_enabled then
        require('lualine').hide({
            place = { 'winbar' }, -- The segment this change applies to.
            unhide = true,        -- whether to re-enable lualine again/
        })
    else
        require('lualine').hide({
            place = { 'winbar' }, -- The segment this change applies to.
            unhide = false,       -- whether to re-enable lualine again/
        })
    end
end

return {
    'nvim-lualine/lualine.nvim',
    event = { "BufReadPost", "BufNewFile" },
    dependencies = get_dependencies(),
    keys = {
        { "<leader>ws", switch_winbar,  desc = "Toggle Lualine Winbar" },
        { "<leader>wt", switch_tabstop, desc = "Change Tabstop" },
    },
    config = function(_, opts)
        local found_cmake, cmake = pcall(require, "cmake-tools")
        if not found_cmake then
            cmake = {
                is_cmake_project = function() return false end,
            }
        end
        local get_icon = require("util.icons").get_icon
        local cmake_component = {
            preset_or_build_type = {
                function()
                    if cmake.has_cmake_preset() then
                        local b_preset = cmake.get_build_preset()
                        if not b_preset then
                            return get_icon("cmake", "Build")
                        end
                        return get_icon("cmake", "Build") .. string.format(" [%s]", b_preset)
                    else
                        local b_type = cmake.get_build_type()
                        if not b_type then
                            return get_icon("cmake", "Build")
                        end
                        return get_icon("cmake", "Build") .. string.format(" [%s]", b_type)
                    end
                end,
                cond = function()
                    return cmake.is_cmake_project() and (
                        vim.bo.buftype == '' or vim.bo.buftype == 'quickfix')
                end,
                on_click = function(n, mouse)
                    if (n == 1) then
                        if (mouse == "l") then
                            cmake.generate({}, cmake_generate_callback)
                        elseif (mouse == "r") then
                            if cmake.has_cmake_preset() then
                                cmake.select_build_preset()
                            else
                                cmake.select_build_type()
                            end
                        end
                    end
                end
            },
            build_target = {
                function()
                    local b_target = cmake.get_build_target()
                    if not b_target then
                        return get_icon("cmake", "Target")
                    end
                    if type(b_target) == "table" then
                        b_target = table.concat(b_target, ", ")
                    end
                    return get_icon("cmake", "Target") .. string.format(" [%s]", b_target)
                end,
                cond = function()
                    return cmake.is_cmake_project() and vim.bo.buftype == ''
                end,
                on_click = function(n, mouse)
                    if (n == 1) then
                        if (mouse == "l") then
                            local b_target = cmake.get_build_target()
                            if not b_target then
                                local l_target = cmake.get_launch_target()
                                if l_target then
                                    cmake.build({
                                        target = l_target,
                                    }, cmake_build_callback)
                                    return
                                end
                                cmake.build({
                                    target = 'all',
                                }, cmake_build_callback)
                            else
                                cmake.build({}, cmake_build_callback)
                            end
                        elseif (mouse == "r") then
                            cmake.select_build_target()
                        end
                    end
                end
            },
            kit = {
                function()
                    local kit = cmake.get_kit()
                    return "[" .. (kit and kit or "X") .. "]"
                end,
                icon = get_icon("cmake", "CMake"),
                cond = function()
                    return cmake.is_cmake_project() and not cmake.has_cmake_preset() and cmake.get_kit() ~= nil and
                        vim.bo.buftype == ''
                end,
                on_click = function(n, mouse)
                    if (n == 1) then
                        if (mouse == "l") then
                            vim.cmd("CMakeSelectKit")
                        end
                    end
                end
            },
            clean = {
                function()
                    return get_icon("cmake", "Reset")
                end,
                cond = function()
                    return cmake.is_cmake_project() and vim.bo.buftype == ''
                end,
                on_click = function(n, mouse)
                    if (n == 1) then
                        if (mouse == "l") then
                            cmake.clean(cmake_clean_callback)
                        end
                    end
                end
            },
            debug = {
                function()
                    return get_icon("cmake", "Debug")
                end,
                cond = function()
                    return cmake.is_cmake_project() and vim.bo.buftype == ''
                end,
                on_click = function(n, mouse)
                    if (n == 1) then
                        if (mouse == "l") then
                            if cmake.debug == nil then
                                vim.notify(
                                    "CMake debug function not found. Please check the `dap` is already installed.",
                                    vim.log.levels.WARN,
                                    {
                                        icon = get_icon("cmake", "Default"),
                                        title = "CMake Debug"
                                    })
                                return
                            end
                            local l_target = cmake.get_launch_target()
                            if not l_target then
                                local b_target = cmake.get_build_target()
                                if b_target then
                                    cmake.debug {
                                        target = b_target,
                                    }
                                    return
                                end
                            end
                            cmake.debug {}
                        elseif (mouse == "r") then
                            cmake.select_launch_target()
                        end
                    end
                end
            },
            run = {
                function()
                    local l_target = cmake.get_launch_target()
                    if not l_target then
                        return get_icon("cmake", "Run")
                    end
                    return get_icon("cmake", "Run") .. string.format(" [%s]", l_target)
                end,
                cond = function()
                    return cmake.is_cmake_project() and vim.bo.buftype == ''
                end,
                on_click = function(n, mouse)
                    if (n == 1) then
                        if (mouse == "l") then
                            local l_target = cmake.get_launch_target()
                            if not l_target then
                                local b_target = cmake.get_build_target()
                                if b_target then
                                    cmake.run {
                                        target = b_target,
                                    }
                                    return
                                end
                            end
                            cmake.run {}
                        elseif (mouse == "r") then
                            cmake.select_launch_target()
                        end
                    end
                end
            },
        }

        local filetype = {
            'filetype',
            colored = true,
            cond = function()
                return vim.bo.buftype == '' and vim.fn.winwidth(0) > 80
            end,
        }
        local filename = {
            'filename',
            file_status = true,
            path = 1,
            cond = function()
                return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
            end,
            -- shorting_target = 50,
            fmt = function(str)
                return str:gsub("^term://.*$", require("core.options").nerd_fonts and " " or "[terminal]")
            end,
            on_click = function(n, mouse)
                if (n == 1) then
                    if (mouse == "l") then
                        vim.cmd [[Neotree toggle]]
                    end
                end
            end,
            color = { gui = "bold" },
        }
        local diagnostics = {
            'diagnostics',
            cond = function()
                return vim.fn.winwidth(0) > 60
            end,
            on_click = function(n, mouse)
                if (n == 1) then
                    if (mouse == "l") then
                        vim.cmd [[Trouble diagnostics toggle focus=false]]
                    elseif (mouse == "r") then
                        vim.cmd [[Trouble diagnostics toggle focus=false filter.buf=0]]
                    end
                end
            end,
        }
        local branch = {
            'branch',
            on_click = function(n, mouse)
                if (n == 1) then
                    if (mouse == "l") then
                        require('snacks').lazygit()
                    end
                end
            end,
        }
        local diff = {
            'diff',
            colored = true,
            diff_color = {
                added    = 'diffAdded',
                modified = 'diffChanged',
                removed  = 'diffRemoved',
            },
            cond = function()
                return vim.fn.winwidth(0) > 80
            end,
        }
        local ctime = {
            'ctime',
            format = '%m/%d %H:%M',
            cond = function()
                return vim.fn.winwidth(0) > 80
            end,
        }
        local encoding = {
            'encoding',
            fmt = string.upper,
            cond = function()
                return vim.fn.winwidth(0) > 50
            end,
            show_bomb = true,
        }
        local location = {
            'location',
            cond = function()
                return vim.bo.buftype == ''
            end,
            show_bomb = true,
        }
        local aerial = {
            'aerial',
            cond = function()
                return vim.bo.buftype == ''
            end,
            on_click = function(n, mouse)
                if (n == 1) then
                    if (mouse == "l") then
                        vim.cmd [[AerialToggle]]
                    end
                end
            end,
        }
        local opencode = {
            function() return require("opencode").statusline() end,
            cond = function()
                return pcall(require, "opencode")
            end,
            on_click = function(n, mouse)
                if (n == 1) then
                    if (mouse == "l") then
                        require("opencode").toggle()
                    end
                end
            end,
        }
        local lsp_status = {
            "lsp_status",
            on_click = function(n, mouse)
                if (n == 1) then
                    if (mouse == "l") then
                        vim.cmd [[LspInfo]]
                    end
                end
            end,
        }

        local venv_component = {
            'venv-selector',
            -- icon = get_icon("ui", "Python"),
            on_click = function(n, mouse)
                if (n == 1) then
                    if (mouse == "l") then
                        vim.cmd [[VenvSelect]]
                    end
                end
            end,
        }

        local switch_winbar_component = {
            function()
                return "Nav"
            end,
            icon = get_icon("ui", "Expand"),
            cond = function()
                return vim.bo.buftype == ''
            end,
            on_click = function(n, mouse)
                if (n == 1) then
                    switch_winbar()
                end
            end,
        }

        local switch_winbar_section_component = {
            function()
                return "WinBar"
            end,
            icon = get_icon("ui", "SwitchOff"),
            cond = function()
                return vim.bo.buftype == '' and not lualine_winbar_enabled
            end,
            on_click = function(n, mouse)
                if (n == 1) then
                    switch_winbar()
                end
            end,
        }

        local switch_tabstop_component = {
            function()
                local expandtab = vim.bo.expandtab and "Spaces:" or "Tab:"
                local tabstop = vim.bo.tabstop
                return string.format("%s%d", expandtab, tabstop)
            end,
            cond = function()
                return vim.bo.buftype == ''
            end,
            on_click = function(n, mouse)
                if (n == 1) then
                    switch_tabstop()
                end
            end,
        }

        local compile_run_section_component = {
            function()
                return "Run"
            end,
            icon = get_icon("ui", "Run"),
            cond = function()
                return vim.bo.buftype == '' and vim.bo.filetype ~= '' and
                    require("custom_plugins.compile_run").filetype_map_func[vim.bo.filetype] ~= nil
            end,
            on_click = function(n, mouse)
                if (n == 1) then
                    if mouse == "l" then
                        require("custom_plugins.compile_run").compileRun()
                    elseif (mouse == "r") then
                        vim.cmd [[OverseerRun]]
                    end
                end
            end,
        }

        local copilot_component = {
            'copilot',
            cond = function()
                return require("core.options").ai_assistant.copilot_lua.enabled
            end,
            on_click = function(n, mouse)
                if (n == 1) then
                    if (mouse == "l") then
                        vim.cmd [[Copilot disable]]
                        vim.notify("GitHub Copilot Disabled", vim.log.levels.INFO, {
                            icon = get_icon("ui", "Copilot"),
                            title = "GitHub Copilot"
                        })
                    elseif (mouse == "r") then
                        vim.cmd [[Copilot enable]]
                        vim.notify("GitHub Copilot Enabled", vim.log.levels.INFO, {
                            icon = get_icon("ui", "Copilot"),
                            title = "GitHub Copilot"
                        })
                    end
                end
            end,
        }

        if require("core.options").nerd_fonts then
            -- diagnostics.symbols = { error = icons.diagnostics.Error, warn = icons.diagnostics.Warning, info = icons.diagnostics.Information, hint = icons.diagnostics.Question }
            branch.icon = get_icon("git", "Branch")
            diff.symbols = { added = ' ', modified = ' ', removed = ' ' }
            filetype.icon = get_icon("documents", "File")
            filetype.icon_only = false
            filetype.icon = { align = 'left' }
            filetype.fmt = function(str) return str:gsub("%s*$", "") end
            filename.symbols = {
                modified = get_icon("git", "Mod"),
                readonly = get_icon("git", "Remove"),
                unnamed = get_icon("git", "Untrack"),
                newfile = get_icon("git", "Add"),
            }
            ctime.icon = get_icon("ui", "Clock")
        else
            diagnostics.symbols = { error = 'E', warn = 'W', info = 'I', hint = '?' }
            branch.icon = ''
        end

        local opts = {
            options = {
                theme = 'auto',
                -- component_separators = '', -- not require("core.options").nerd_fonts and '' or nil,
                -- section_separators = '',   -- not require("core.options").nerd_fonts and '' or nil,
                component_separators = { left = '', right = '' },
                -- section_separators = { left = '', right = '' },
                -- section_separators = { left = '', right = '' },
                section_separators = { left = '', right = '' },
                -- component_separators = { left = '', right = '' },
                disabled_filetypes = {
                    -- "dashboard",
                    -- "lspinfo",
                    -- "mason",
                    -- "startuptime",
                    -- "checkhealth",
                    -- "help",
                    -- "toggleterm",
                    -- "alpha",
                    -- "lazy",
                    -- "packer",
                    -- "NvimTree",
                    -- "neo-tree",
                    -- "sagaoutline",
                    -- "TelescopePrompt",
                    "dap-repl",
                    "dapui_watches",
                    "dapui_console",
                    "dapui_scopes",
                    "dapui_breakpoints",
                    "dapui_stacks",
                    winbar = {
                        "neo-tree",
                        "NvimTree",
                    }
                },
            },
            sections = {
                lualine_a = { 'mode' },
                lualine_b = { opencode, branch, diagnostics },
                lualine_c = { filename, switch_winbar_section_component, compile_run_section_component, copilot_component },
                lualine_x = { encoding, 'filetype', lsp_status, venv_component },
                lualine_y = { 'searchcount', 'quickfix' },
                lualine_z = { switch_tabstop_component, 'progress', 'location' },
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { filename },
                lualine_x = { location, 'filetype' },
                lualine_y = {},
                lualine_z = {},
            },
            tabline = {},
            winbar = {
                lualine_a = { switch_winbar_component },
                lualine_b = { cmake_component.preset_or_build_type, cmake_component.build_target, cmake_component.kit, cmake_component.clean },
                lualine_c = { cmake_component.debug, cmake_component.run },
                lualine_x = { aerial },
                lualine_y = {},
                lualine_z = {},
            },
            inactive_winbar = {},
            extensions = {
                'nvim-dap-ui',
                'neo-tree',
            },
        }

        require 'lualine'.setup(opts)
        if not lualine_winbar_enabled then
            vim.defer_fn(function()
                require('lualine').hide({
                    place = { 'winbar' }, -- The segment this change applies to.
                    unhide = false,       -- whether to re-enable lualine again/
                })
            end, 100)
        end
    end,
}
