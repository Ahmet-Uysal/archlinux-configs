return {
  'akinsho/toggleterm.nvim',
  version = "*",
  config = function()
    require("toggleterm").setup{
     size = 15,
      open_mapping = [[<leader>"]],
      direction = 'horizontal', -- altta panel
      shade_terminals = true,
      start_in_insert = true,
      persist_size = true,} 
    end
}

