local M = {}

-- 配置选项
local config = {
    default_commands = {
        cpp = {
            cmd = "g++",
            args = { "-std=c++17", "-Wall", "-Wextra" },
        },
        c = {
            cmd = "gcc",
            args = { "-Wall", "-Wextra" },
        },
    },
    save_before_run = true,
}

-- 获取文件类型特定的默认命令
local function get_default_command()
    local ft = vim.bo.filetype
    local cmds = config.default_commands[ft]
    if cmds == nil then
        vim.notify("No default command for filetype: " .. ft, vim.log.levels.ERROR)
        return ""
    end

    local cmd = cmds.cmd ..
        " " .. table.concat(cmds.args, " ") .. " " .. vim.fn.shellescape(vim.api.nvim_buf_get_name(0));

    local target = vim.fn.shellescape(vim.fn.expand("%:r") .. ".out")
    cmd = cmd .. " -o " .. target .. " && " .. target

    cmd = cmd .. " && " .. "rm " .. target

    return cmd
end

-- 保存文件（如果配置要求）
local function save_if_needed()
    if config.save_before_run and vim.bo.modified then
        vim.cmd('write')
    end
end

-- 打开命令输入浮动窗口
function M.open_run_prompt(should_get_default)
    save_if_needed()

    local default_cmd
    if should_get_default == false then
        default_cmd = ""
    else
        default_cmd = get_default_command()
    end

    -- 创建输入缓冲区
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { default_cmd })

    -- 创建浮动窗口
    local width = math.min(100, vim.o.columns - 20)
    local height = 5
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    local win_opts = {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = "single",
        title = "Compile & Run Command (Enter: Confirm, Esc: Cancel)",
        title_pos = "center",
    }

    local win = vim.api.nvim_open_win(buf, true, win_opts)

    -- 设置窗口选项
    vim.api.nvim_set_option_value('winhighlight', 'Normal:NormalFloat', { win = win })
    vim.api.nvim_set_option_value('number', true, { win = win })
    vim.api.nvim_set_option_value('wrap', true, { win = win })

    -- 设置缓冲区的文件类型，例如设置为空，或者设置为一个不会干扰的类型
    vim.api.nvim_set_option_value('filetype', '', { buf = buf })

    -- 设置按键映射
    local keymaps = {
        { 'n', '<CR>',  function() M.execute_command(buf) end },
        { 'i', '<CR>',  function() M.execute_command(buf) end },
        { 'i', '<C-s>', function() M.execute_command(buf) end },
        { 'n', '<Esc>', function() vim.api.nvim_win_close(win, true) end },
        { 'n', 'q',     function() vim.api.nvim_win_close(win, true) end },
    }

    for _, km in ipairs(keymaps) do
        vim.keymap.set(km[1], km[2], km[3], { buffer = buf, nowait = true })
    end

    -- 进入插入模式并选中所有文本
    vim.cmd('startinsert!')
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-g>U<End>', true, false, true), 'n', false)
end

-- 执行命令
function M.execute_command(buf)
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    local cmd = table.concat(lines, ' ')

    -- 关闭浮动窗口
    local win = vim.fn.bufwinid(buf)
    if win ~= -1 then
        vim.api.nvim_win_close(win, true)
    end

    if cmd and #cmd > 0 then
        require('toggleterm').exec(cmd)
    end
end

function M.open_run_prompt_with_default()
    M.open_run_prompt(true)
end

function M.open_run_prompt_without_default()
    M.open_run_prompt(false)
end

-- 设置配置
function M.setup(user_config)
    config = vim.tbl_deep_extend('force', config, user_config or {})

    -- 设置自动命令
    vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'cpp', 'c' },
        callback = function()
            vim.keymap.set('n', '<Leader>rt', M.open_run_prompt_with_default, { buffer = true, desc = 'Edit and run' })
            vim.keymap.set({ 'n', 'i' }, '<F8>', M.open_run_prompt_with_default, { buffer = true, desc = 'Edit and run' })
            vim.keymap.set('n', '<Leader>rs', M.open_run_prompt_without_default, { buffer = true, desc = 'Edit and run' })
        end
    })
end

return M
