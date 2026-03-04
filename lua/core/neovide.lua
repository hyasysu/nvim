if vim.g.neovide then
    vim.o.guifont = "DMMono Nerd Font,Maple Mono Normal NF,FiraCode Nerd Font:h13"

    vim.g.neovide_title_background_color = string.format(
        "%x",
        vim.api.nvim_get_hl(0, { id = vim.api.nvim_get_hl_id_by_name("Normal") }).bg
    )

    vim.g.neovide_title_text_color = "pink"

    -- Neovide UI Options
    vim.g.neovide_cursor_animation_length = 0.12
    vim.g.neovide_cursor_trail_length = 0.9
    vim.g.neovide_cursor_antialiasing = true
    vim.g.neovide_cursor_vfx_mode = "railgun"
    vim.g.neovide_refresh_rate = 60
    vim.g.neovide_hide_mouse_when_typing = true

    -- 平滑滚动
    vim.g.neovide_scroll_animation_length = 0.25

    -- 开启 FPS 显示
    vim.g.neovide_floating_blur_amount_x = 2.0
    vim.g.neovide_floating_blur_amount_y = 2.0
    vim.g.neovide_opacity = 0.9
    vim.g.neovide_normal_opacity = 0.9

    -- 启用透明背景（如果你的配色支持）
    vim.cmd([[hi Normal guibg=none ctermbg=none]])
end
