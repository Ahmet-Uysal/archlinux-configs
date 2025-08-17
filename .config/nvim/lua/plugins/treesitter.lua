return {
  "nvim-treesitter/nvim-treesitter",
  run = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup {
      ensure_installed = { "lua", "python", "javascript" ,"c_sharp"},
      highlight = { enable = true },
      indent = { enable = true },
    }
  end,
}
