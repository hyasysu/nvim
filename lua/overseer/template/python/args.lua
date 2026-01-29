return {
    name = 'run python (args)',
    condition = {
        filetype = { 'python' },
    },
    params = {
        args = { optional = false, type = 'list', delimiter = ' ' },
        cwd = { optional = true, type = 'string', default = vim.fn.expand "%:p:h" },
        name = { optional = true, type = 'string', default = vim.fn.expand '%:t' },
    },
    builder = function(params)
        local cwd = params.cwd and params.cwd or vim.fn.expand '%:p:h'
        local name = params.name and params.name or vim.fn.expand '%:t'
        local program_name = ""
        -- If the last character of the cwd is a `/`
        if cwd:sub(-1) == '/' then
            program_name = cwd .. name
        else
            program_name = cwd .. '/' .. name
        end

        local args = { program_name }
        if params.args then
            args = vim.list_extend(args, params.args)
        end
        local res = {
            name = name,
            cmd = 'python3',
            args = args,
            cwd = cwd,
            components = {
                'task_list_on_complete',
                'on_exit_set_status',
                'on_complete_notify',
            },
        }
        return res
    end,
}
