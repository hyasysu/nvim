-- Events:
-- PersistenceLoadPre: before loading a session
-- PersistenceLoadPost: after loading a session
-- PersistenceSavePre: before saving a session
-- PersistenceSavePost: after saving a session
return {
    "folke/persistence.nvim",
    event = "BufReadPre",                              -- this will only start session saving when an actual file was opened
    opts = {
        dir = vim.fn.stdpath("state") .. "/sessions/", -- directory where session files are saved
        -- minimum number of file buffers that need to be open to save
        -- Set to 0 to always save
        need = 1,
        branch = true, -- use git branch to save session
    },
    keys = {
        { "<Leader>ss", function() require("persistence").load() end,                desc = "Load session for current dir" },
        { "<Leader>sS", function() require("persistence").select() end,              desc = "Select session to load" },
        { "<Leader>sl", function() require("persistence").load({ last = true }) end, desc = "Load last session" },
        { "<Leader>sd", function() require("persistence").stop() end,                desc = "Stop persistence (don't save session on exit)" },
        {
            "<Leader>sD",
            function()
                local ok, persistence = pcall(require, "persistence")
                local get_icon = require("util.icons").get_icon
                if not ok then
                    vim.notify("persistence.nvim not found", vim.log.levels.ERROR,
                        { icon = get_icon("ui", "Session"), title = "Session" })
                    return
                end

                -- 获取所有 session 文件
                local sessions = persistence.list()
                if #sessions == 0 then
                    vim.notify("No sessions found", vim.log.levels.INFO,
                        { icon = get_icon("ui", "Session"), title = "Session" })
                    return
                end

                -- 创建格式化显示的项目列表
                local items = {}
                for _, session_path in ipairs(sessions) do
                    -- 提取文件名（去掉目录前缀）
                    local filename = session_path:match("([^/\\]+)%.vim$") or session_path
                    -- 将 % 替换为 /
                    local display_name = filename:gsub("%%", "/")

                    -- 尝试提取分支信息
                    local dir, branch = table.unpack(vim.split(filename, "%%", { plain = true, maxsplit = 1 }))
                    dir = dir:gsub("%%", "/")
                    if jit.os:find("Windows") then
                        dir = dir:gsub("^(%w)/", "%1:/")
                    end

                    local item_text = vim.fn.fnamemodify(dir, ":p:~")
                    if branch then
                        item_text = item_text .. " [" .. branch .. "]"
                    end

                    table.insert(items, {
                        text = item_text,
                        path = session_path,
                        branch = branch,
                        dir = dir
                    })
                end

                -- 使用 vim.ui.select 创建选择浮窗
                vim.ui.select(items, {
                    prompt = "Select session to delete:",
                    format_item = function(item)
                        return item.text
                    end,
                }, function(selected)
                    if not selected then
                        return
                    end

                    -- 确认删除
                    vim.ui.select({
                        "YesStop    --If current session is deleted, persistence will be stopped.",
                        "Yes",
                        "No"
                    }, {
                        prompt = string.format("Delete session '%s'?", selected.text),
                    }, function(choice, idx)
                        if idx == nil then
                            return
                        end
                        if idx == 1 or idx == 2 then
                            -- 删除文件
                            local uv = vim.uv or vim.loop
                            local success, err = uv.fs_unlink(selected.path)

                            if success then
                                vim.notify(string.format("Deleted session: %s", selected.text), vim.log.levels.INFO,
                                    { icon = get_icon("ui", "Session"), title = "Session" })

                                -- 如果当前目录的 session 被删除，停止 persistence
                                local current_session = persistence.current({ branch = false })
                                if idx == 1 and current_session == selected.path then
                                    persistence.stop()
                                end
                            else
                                vim.notify(string.format("Failed to delete session: %s", err), vim.log.levels.ERROR,
                                    { icon = get_icon("ui", "Session"), title = "Session" })
                            end
                        end
                    end)
                end)
            end,
            desc = "Delete session"
        },
    }
}
