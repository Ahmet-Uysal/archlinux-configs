return {
  'akinsho/bufferline.nvim',
  version = "*",
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function()
    require("bufferline").setup {
      options = {
        mode = "buffers",
        diagnostics = "nvim_lsp",
        separator_style = "slant",
        show_buffer_close_icons = true,
        show_close_icon = true,
        always_show_bufferline = true,
        offsets = {
          {
            filetype = "NvimTree",
            text = "File Explorer", -- İstersen buraya boş string koyabilirsin: ""
            text_align = "center",
            separator = true, -- çizgiyle ayırmak için
            padding = 0,
          }
        },
      }
    }
  end
}

