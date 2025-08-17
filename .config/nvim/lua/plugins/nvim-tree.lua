return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local function on_attach(bufnr)
      local api = require('nvim-tree.api')

      local function opts(desc)
        return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap=true, silent=true, nowait=true }
      end

      -- Enter veya o: Dosya veya klasörü açar
      vim.keymap.set('n', '<CR>', api.node.open.edit, opts('Open'))
      vim.keymap.set('n', 'o', api.node.open.edit, opts('Open'))

      -- h: Bir üst klasöre geçer (parent directory)
      vim.keymap.set('n', 'h', api.tree.change_root_to_parent, opts('Up'))

      -- l: Dosya veya klasörü açar (open)
      vim.keymap.set('n', 'l', api.node.open.edit, opts('Open'))

      -- v: Dosyayı dikey bölmede açar (vertical split)
      vim.keymap.set('n', 'v', api.node.open.vertical, opts('Open: Vertical Split'))

      -- s: Dosyayı yatay bölmede açar (horizontal split)
      vim.keymap.set('n', 's', api.node.open.horizontal, opts('Open: Horizontal Split'))

      -- a: Yeni dosya veya klasör oluşturur
      vim.keymap.set('n', 'a', api.fs.create, opts('Create'))

      -- d: Dosya veya klasörü siler
      vim.keymap.set('n', 'd', api.fs.remove, opts('Delete'))

      -- r: Dosya veya klasörü yeniden adlandırır
      vim.keymap.set('n', 'r', api.fs.rename, opts('Rename'))

      -- x: Dosya veya klasörü keser (cut)
      vim.keymap.set('n', 'x', api.fs.cut, opts('Cut'))

      -- c: Dosya veya klasörü kopyalar
      vim.keymap.set('n', 'c', api.fs.copy.node, opts('Copy'))

      -- p: Kesilen veya kopyalanan dosya/klasörü yapıştırır
      vim.keymap.set('n', 'p', api.fs.paste, opts('Paste'))

      -- R: Dosya ağacını yeniler (refresh)
      vim.keymap.set('n', 'R', api.tree.reload, opts('Refresh'))

      -- ?: Yardım menüsünü açar
      vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))

      -- q: Nvim-tree penceresini kapatır
      vim.keymap.set('n', 'q', ":NvimTreeClose<CR>", opts('Close'))
    end

    require("nvim-tree").setup({
      on_attach = on_attach,
      view = {
        width = 30,
        side = "left",
      },
      renderer = {
        icons = {
          show = {
            git = true,
            file = true,
            folder = true,
            folder_arrow = true,
          },
        },
      },
      filters = {
        dotfiles = false,
      },
    })

    -- Global keymap (örnek): <leader>e ile nvim-tree aç/kapa
    vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { noremap=true, silent=true, desc = "Toggle NvimTree" })

    local function toggle_nvim_tree_focus()
  local api = require('nvim-tree.api')
  local view = require('nvim-tree.view')

  if not view.is_visible() then
    api.tree.open()
    return
  end

  local tree_win = nil

  -- Açık pencereleri dolaş, nvim-tree buffer'ını bul
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local buf_name = vim.api.nvim_buf_get_name(buf)
    if buf_name:match("NvimTree_") then
      tree_win = win
      break
    end
  end

  local curr_win = vim.api.nvim_get_current_win()

  if tree_win == nil then
    -- Ağacın penceresi yoksa aç
    api.tree.open()
  elseif curr_win == tree_win then
    -- Ağacın içindeysek editöre geç
    vim.cmd('wincmd p')
  else
    -- Editördeysek ağaca geç
    api.tree.focus()
  end
end

vim.keymap.set('n', '<leader>t', toggle_nvim_tree_focus, { noremap = true, silent = true, desc = "Toggle NvimTree Focus" })

end,
}
