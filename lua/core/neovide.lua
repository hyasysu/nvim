if vim.g.neovide then
    vim.o.guifont = "DMMono Nerd Font,Maple Mono Normal NF,FiraCode Nerd Font:h13"

    vim.g.neovide_title_background_color = string.format(
        "%x",
        vim.api.nvim_get_hl(0, { id = vim.api.nvim_get_hl_id_by_name("Normal") }).bg
    )

    vim.g.neovide_title_text_color = "pink"
end
