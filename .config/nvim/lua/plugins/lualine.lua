return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' }, -- ikonlar için
  config = function()
    require('lualine').setup {
      options = {
        theme = 'catppuccin', -- varsa tema uyumlu olur
        section_separators = { left = '', right = '' },
        component_separators = { left = '', right = '' },
        icons_enabled = true,
      }
    }
  end
}

