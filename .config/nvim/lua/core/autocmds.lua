vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.lua",
  command = "source <afile>"
})
-- Kitty terminalde Neovim açıldığında padding'i kaldır
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- sadece Kitty terminalde çalışsın
    if os.getenv("TERM") == "xterm-kitty" then
      vim.fn.jobstart({ "kitty", "@", "set-spacing", "padding=0" }, { detach = true })
    end
  end,
})
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- Eğer sadece bir buffer açıldıysa (örneğin: nvim a.cs)
    if vim.fn.argc() == 1 then
      -- nvim-tree modülünü çağır
      require("nvim-tree.api").tree.open()
    end
  end,
})
vim.o.autoread = true

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
  callback = function()
    if vim.fn.getbufvar(vim.fn.bufnr(), "&modifiable") == 1 then
      vim.cmd("checktime")
    end
  end,
})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.cs",
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})
