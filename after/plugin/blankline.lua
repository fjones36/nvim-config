vim.opt.termguicolors = true

require("ibl").setup()

-- require("bufferline").setup{
--     options = {
--         color_icons = false,
--         show_buffer_icons = false,
--         show_buffer_close_icons = false,
--         show_close_icon = false,
--     }
--
-- }

require('lualine').setup {
    options = {
        icons_enabled = false,
        theme = 'dracula',
    }
}

