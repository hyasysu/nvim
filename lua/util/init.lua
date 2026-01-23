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

M.buffer = {}

--- Check if a buffer is valid
---@param bufnr? integer The buffer to check, default to current buffer
---@return boolean # Whether the buffer is valid or not
function M.buffer.is_valid(bufnr)
    if not bufnr then bufnr = 0 end
    return vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buflisted
end

local large_buf_cache, buf_size_cache = {}, {} -- cache large buffer detection results and buffer sizes
--- Check if a buffer is a large buffer (always returns false if large buffer detection is disabled)
---@param bufnr? integer the buffer to check the size of, default to current buffer
---@param large_buf_opts? AstroCoreMaxFile large buffer parameters, default to AstroCore configuration
---@return boolean is_large whether the buffer is detected as large or not
function M.buffer.is_large(bufnr, large_buf_opts)
    if not bufnr then bufnr = vim.api.nvim_get_current_buf() end
    local skip_cache = large_buf_opts ~= nil -- skip cache when called manually with custom options
    if not large_buf_opts then large_buf_opts = { notify = true, size = 1.5 * 1024 * 1024, lines = 100000, line_length = 1000 } end
    if large_buf_opts then
        if skip_cache or large_buf_cache[bufnr] == nil then
            local enabled = vim.tbl_get(large_buf_opts, "enabled")
            if type(enabled) == "function" then
                large_buf_opts = vim.deepcopy(large_buf_opts)
                enabled = enabled(bufnr, large_buf_opts)
                if type(enabled) == "table" then large_buf_opts = enabled end
            end
            local large_buf = false
            if vim.F.if_nil(enabled, true) then
                if not buf_size_cache[bufnr] then
                    local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(bufnr))
                    buf_size_cache[bufnr] = ok and stats and stats.size or 0
                end
                local file_size = buf_size_cache[bufnr]
                local line_count = vim.api.nvim_buf_line_count(bufnr)
                local too_large = large_buf_opts.size and file_size > large_buf_opts.size
                local too_long = large_buf_opts.lines and line_count > large_buf_opts.lines
                local too_wide = large_buf_opts.line_length and (file_size / line_count) - 1 > large_buf_opts
                    .line_length
                large_buf = too_large or too_long or too_wide or false
            end
            if skip_cache then return large_buf end
            large_buf_cache[bufnr] = large_buf
        end
        return large_buf_cache[bufnr]
    end
    return false
end

return M
