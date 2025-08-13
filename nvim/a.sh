mkdir -p ~/.config/nvim/lua/{plugins,core}

cat > ~/.config/nvim/init.lua <<EOF
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("core.options")
require("core.keymaps")
require("core.autocmds")

require("lazy").setup(require("plugins"))
EOF

cat > ~/.config/nvim/lua/core/options.lua <<EOF
vim.o.number = true
vim.o.relativenumber = true
vim.o.termguicolors = true
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
EOF

cat > ~/.config/nvim/lua/core/keymaps.lua <<EOF
vim.keymap.set('n', '<leader>ff', ':Telescope find_files<CR>')
EOF

cat > ~/.config/nvim/lua/core/autocmds.lua <<EOF
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.lua",
  command = "source <afile>"
})
EOF

cat > ~/.config/nvim/lua/plugins/init.lua <<EOF
return {
  require("plugins.treesitter"),
}
EOF

cat > ~/.config/nvim/lua/plugins/treesitter.lua <<EOF
return {
  "nvim-treesitter/nvim-treesitter",
  run = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup {
      ensure_installed = { "lua", "python", "javascript" },
      highlight = { enable = true },
      indent = { enable = true },
    }
  end,
}
EOF
