return {
    "jake-stewart/multicursor.nvim",
    event = "VeryLazy",
    branch = "1.0",
    config = function()
        local mc = require("multicursor-nvim")
        mc.setup()
        local map = vim.keymap.set
        -- 在主光标上方/下方添加或跳过光标。
        map({ "n", "v" }, "<c-up>", function() mc.lineAddCursor(-1) end, { desc = "Add cursor above" })
        map({ "n", "v" }, "<c-down>", function() mc.lineAddCursor(1) end, { desc = "Add cursor below" })
        map({ "n", "v" }, "<leader><up>", function() mc.lineSkipCursor(-1) end, { desc = "Skip cursor above" })
        map({ "n", "v" }, "<leader><down>", function() mc.lineSkipCursor(1) end, { desc = "Skip cursor below" })
        -- 主光标在多光标之间移动。
        map({ "n", "v" }, "<c-left>", mc.nextCursor, { desc = "Move to next cursor" })
        map({ "n", "v" }, "<c-right>", mc.prevCursor, { desc = "Move to previous cursor" })
        -- 通过匹配单词/选择来添加或跳过添加新光标
        map({ "n", "v" }, "<C-d>", function() mc.matchAddCursor(1) end, { desc = "Add cursor by match" })
        map({ "n", "v" }, "<M-d>", function() mc.matchSkipCursor(1) end, { desc = "Skip cursor by match" })

        map({ "n", "v" }, "<c-k>", function() mc.matchAddCursor(-1) end, { desc = "Add cursor by match (reverse)" })
        map({ "n", "v" }, "<M-k>", function() mc.matchSkipCursor(-1) end, { desc = "Skip cursor by match (reverse)" })

        -- 使用 Control + 左键单击添加和删除光标。
        map("n", "<c-leftmouse>", mc.handleMouse, { desc = "Add cursor with mouse" })
        map("n", "<c-leftdrag>", mc.handleMouseDrag, { desc = "Add cursors with mouse drag" })
        map("n", "<c-leftrelease>", mc.handleMouseRelease, { desc = "Finalize mouse drag multicursors" })

        -- 使用主光标添加和删除光标的简单方法。
        map({ "n", "v" }, "<leader>m", mc.toggleCursor, { desc = "Toggle cursor at main cursor" })

        -- 通过正则表达式匹配视觉选择中的新光标。
        map("v", "<leader>m", mc.matchCursors, { desc = "Add cursors by visual match" })

        -- Mappings defined in a keymap layer only apply when there are
        -- multiple cursors. This lets you have overlapping mappings.
        mc.addKeymapLayer(function(layerSet)
            -- Select a different cursor as the main one.
            layerSet({ "n", "x" }, "<left>", mc.prevCursor)
            layerSet({ "n", "x" }, "<right>", mc.nextCursor)

            -- Delete the main cursor.
            layerSet({ "n", "x" }, "<leader>x", mc.deleteCursor)

            -- Enable and clear cursors using escape.
            layerSet("n", "<esc>", function()
                if not mc.cursorsEnabled() then
                    mc.enableCursors()
                else
                    mc.clearCursors()
                end
            end)
        end)

        -- 启用/禁用多光标。
        map("n", "<esc>", function()
            if not mc.cursorsEnabled() then
                mc.enableCursors()
            elseif mc.hasCursors() then
                mc.clearCursors()
            else
                -- Default <esc> handler.
            end
        end, { desc = "Clear multicursors or exit insert mode", noremap = true, silent = true })
    end,
}
