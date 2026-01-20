-- https://github.com/microsoft/vscode/blob/main/src/vs/base/common/codicons.ts
-- go to the above and then enter <c-v>u<unicode> and the symbold should appear
-- or go here and upload the font file: https://mathew-kurian.github.io/CharacterMap/
-- find more here: https://www.nerdfonts.com/cheat-sheet



local M = {
    icons = {
        kind = {
            Text = "󰦨 ",
            Method = " ",
            Function = " ",
            Constructor = " ",
            Field = " ",
            Variable = " ",
            Class = " ",
            Interface = " ",
            Module = " ",
            Property = " ",
            Unit = " ",
            Value = "󰾡 ",
            Enum = " ",
            Keyword = " ",
            Snippet = " ",
            Color = " ",
            File = " ",
            Reference = " ",
            Folder = " ",
            EnumMember = " ",
            Constant = " ",
            Struct = " ",
            Event = " ",
            Operator = " ",
            TypeParameter = " ",
            Specifier = " ",
            Statement = "",
            Recovery = " ",
            TranslationUnit = " ",
            PackExpansion = " "
        },
        type = {
            Array = " ",
            Number = " ",
            String = " ",
            Boolean = " ",
            Object = " ",
            Template = " "
        },
        documents = {
            File = "",
            Files = "",
            Folder = "",
            OpenFolder = "",
            EmptyFolder = "",
            EmptyOpenFolder = "",
            Unknown = "",
            Symlink = "",
            FolderSymlink = "",
            DefaultFile = "󰈙",
            FileModified = "",
        },
        git = {
            Git = "󰊢",
            Add = " ",
            Mod = " ",
            Remove = " ",
            Staged = "✓",
            Unstaged = "✗",
            Untrack = " ",
            Rename = " ",
            Diff = " ",
            Repo = " ",
            Branch = " ",
            Ignored = "◌",
            Unmerged = " ",
            Conflict = "",
        },
        ui = {
            Lock              = "",
            TinyCircle        = "",
            Circle            = "",
            BigCircle         = "",
            BigUnfilledCircle = "",
            CircleWithGap     = "",
            LogPoint          = "",
            Close             = "",
            NewFile           = "",
            Search            = "",
            Lightbulb         = "",
            Project           = "",
            Dashboard         = "",
            History           = "",
            Comment           = "",
            Bug               = "",
            Code              = "",
            Telescope         = " ",
            Gear              = "",
            Package           = "",
            List              = "",
            SignIn            = "",
            Check             = "",
            Fire              = "",
            Note              = "",
            BookMark          = "",
            Pencil            = "",
            ChevronRight      = "",
            Table             = "",
            Calendar          = "",
            Line              = "▊",
            Evil              = "",
            Debug             = "",
            Run               = "",
            VirtualPrefix     = "",
            Next              = "",
            Previous          = "",
            Clock             = "",
            Terminal          = "",
            NeoTree           = "",
            ActiveLSP         = "",
        },
        diagnostics = {
            General = "󰒡",
            Error = " ",
            Warning = " ",
            Information = " ",
            Question = " ",
            Hint = " ",
        },
        misc = {
            Robot = "󰚩 ",
            Squirrel = "  ",
            Tag = " ",
            Arch = "󰣇 ",
        },
        cmake = {
            CMake = "",
            Build = "",
            Run = "",
            Debug = "",
        },
    }
}

if not require 'core.options'.nerd_fonts then
    for k, v in pairs(M.icons) do
        for k1, v1 in pairs(v) do
            M.icons[k][k1] = k1
        end
    end
end

--- Get an icon from the AstroNvim internal icons if it is available and return it
---@param group string The group of the icon to retrieve
---@param name string The name of the icon in the group to retrieve
---@param padding? integer Padding to add to the end of the icon
---@return string icon
function M.get_icon(group, name, padding)
    return M.icons[group] and M.icons[group][name] and (M.icons[group][name] .. (" "):rep(padding or 0)) or ""
end

return M
