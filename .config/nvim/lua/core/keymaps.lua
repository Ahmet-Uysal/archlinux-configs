vim.keymap.set('n', '<leader>ff', ':Telescope find_files<CR>')
-- Bufferline sekmeleri arasında geçiş
vim.keymap.set("n", "<Tab>", "<cmd>BufferLineCycleNext<CR>", {})
vim.keymap.set("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>", {})
-- Buffer kapatma: mevcut bufferı kapatıp bir sonrakine geç
vim.keymap.set("n", "<leader>q", function()
  local bufnr = vim.api.nvim_get_current_buf()
  vim.cmd("bnext")      -- önce diğer buffera geç
  vim.cmd("bdelete " .. bufnr)  -- sonra o bufferı kapat
end, { desc = "Buffer kapat" })

