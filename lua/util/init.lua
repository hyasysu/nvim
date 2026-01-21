local M = {}

--- A table to manage ToggleTerm terminals created by the user, indexed by the command run and then the instance number
---@type table<string,table<integer,table>>
M.user_terminals = {}

--- Merge extended options with a default table of options
---@param default? table The default table that you want to merge into
---@param opts? table The new options that should be merged with the default table
---@return table extended The extended table
function M.extend_tbl(default, opts)
    opts = opts or {}
    return default and vim.tbl_deep_extend("force", default, opts) or opts
end

--- Get a plugin spec from lazy
---@param plugin string The plugin to search for
---@return LazyPlugin? spec The found plugin spec from Lazy
function M.get_plugin(plugin)
    local lazy_config_avail, lazy_config = pcall(require, "lazy.core.config")
    return lazy_config_avail and lazy_config.spec.plugins[plugin] or nil
end

--- Check if a plugin is defined in lazy. Useful with lazy loading when a plugin is not necessarily loaded yet
---@param plugin string The plugin to search for
---@return boolean available Whether the plugin is available
function M.is_available(plugin) return M.get_plugin(plugin) ~= nil end

--- Toggle a user terminal if it exists, if not then create a new one and save it
---@param opts string|table A terminal command string or a table of options for Terminal:new() (Check toggleterm.nvim documentation for table format)
function M.toggle_term_cmd(opts)
    local terms = M.user_terminals
    -- if a command string is provided, create a basic table for Terminal:new() options
    if type(opts) == "string" then opts = { cmd = opts } end
    opts = M.extend_tbl({ hidden = true }, opts)
    local num = vim.v.count > 0 and vim.v.count or 1
    -- if terminal doesn't exist yet, create it
    if not terms[opts.cmd] then terms[opts.cmd] = {} end
    if not terms[opts.cmd][num] then
        if not opts.count then opts.count = vim.tbl_count(terms) * 100 + num end
        local on_exit = opts.on_exit
        opts.on_exit = function(...)
            terms[opts.cmd][num] = nil
            if on_exit then on_exit(...) end
        end
        terms[opts.cmd][num] = require("toggleterm.terminal").Terminal:new(opts)
    end
    -- toggle the terminal
    terms[opts.cmd][num]:toggle()
end

return M
