local cmake_callback = function(res)
    local get_icon = require("util.icons").get_icon
    if res.code == 0 then
        vim.notify("Build successful", vim.log.levels.INFO, { title = get_icon("cmake", "Default") .. " CMake" })
    else
        vim.notify(res.message, vim.log.levels.WARN, { title = get_icon("cmake", "Default") .. " CMake" })
    end
end

return {
    'nvim-lualine/lualine.nvim',
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function(_, opts)
        local found_cmake, cmake = pcall(require, "cmake-tools")
        if not found_cmake then
            cmake = {
                is_cmake_project = function() return false end,
            }
        end
        local get_icon = require("util.icons").get_icon
        local cmake_component = {
            {
                function()
                    if cmake.has_cmake_preset() then
                        local b_preset = cmake.get_build_preset()
                        if not b_preset then
                            return get_icon("cmake", "CMake")
                        end
                        return get_icon("cmake", "CMake") .. string.format(" [%s]", b_preset)
                    else
                        local b_type = cmake.get_build_type()
                        if not b_type then
                            return get_icon("cmake", "CMake")
                        end
                        return get_icon("cmake", "CMake") .. string.format(" [%s]", b_type)
                    end
                end,
                cond = function()
                    return cmake.is_cmake_project() and (
                        vim.bo.buftype == '' or vim.bo.buftype == 'quickfix')
                end,
                on_click = function(n, mouse)
                    if (n == 1) then
                        if (mouse == "l") then
                            cmake.generate {}
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
            {
                function()
                    local b_target = cmake.get_build_target()
                    if not b_target or b_target == 'all' then
                        return get_icon("cmake", "Build")
                    end
                    return get_icon("cmake", "Build") .. string.format(" [%s]", b_target)
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
                                    }, cmake_callback)
                                    return
                                end
                                cmake.build({
                                    target = 'all',
                                }, cmake_callback)
                            else
                                cmake.build({}, cmake_callback)
                            end
                        elseif (mouse == "r") then
                            cmake.select_build_target()
                        end
                    end
                end
            },
            {
                function()
                    return get_icon("cmake", "Debug")
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
            {
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
                return vim.bo.buftype == ''
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
                        vim.cmd [[LazyGit]]
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

        require 'lualine'.setup {
            options = {
                theme = 'auto',
                component_separators = '', -- not require("core.options").nerd_fonts and '' or nil,
                section_separators = '',   -- not require("core.options").nerd_fonts and '' or nil,
                -- component_separators = { left = '', right = '' },
                -- section_separators = { left = '', right = '' },
            },
            sections = {
                lualine_a = { 'mode' },
                lualine_b = { opencode, branch, diagnostics },
                lualine_c = { filename },
                lualine_x = { encoding, --[['fileformat', diff,--]] filetype, "lsp_status" },
                lualine_y = { 'searchcount', 'quickfix' },
                lualine_z = { 'progress', 'location' },
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { filename },
                lualine_x = { location },
                lualine_y = {},
                lualine_z = {},
            },
            tabline = {},
            winbar = {
                lualine_a = {},
                lualine_b = { cmake_component[1], cmake_component[2] },
                lualine_c = { cmake_component[3], cmake_component[4] },
                lualine_x = { aerial },
                lualine_y = {},
                lualine_z = {},
            },
            inactive_winbar = {},
            extensions = {},
        }
    end,
}
