vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.lua",
  command = "source <afile>"
})
