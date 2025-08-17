return {
  -- Mason (LSP, DAP, Formatter, Linter installer)
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },

  -- Mason + LSPConfig entegrasyonu
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup {
        ensure_installed = { "omnisharp" }, -- buraya istediğin dilleri ekleyebilirsin
      }
    end,
  },

  -- Neovim LSP ayarları
  --{
  --  "neovim/nvim-lspconfig",
  --  config = function()
  --    local lspconfig = require("lspconfig")

  --    -- Omnisharp ayarı
  --    lspconfig.omnisharp.setup {
  --      cmd = { "omnisharp" }, -- mason ile kurulunca PATH'e ekleniyor
  --      enable_editorconfig_support = true,
  --      enable_roslyn_analyzers = true,
  --      enable_import_completion = true,
  --    }
  --  end,
  --},
    -- Neovim LSP ayarları
{
  "neovim/nvim-lspconfig",
  config = function()
    local lspconfig = require("lspconfig")
    local capabilities = require("cmp_nvim_lsp").default_capabilities() -- 🔥 cmp bağlantısı buradan

    -- Omnisharp ayarı
    lspconfig.omnisharp.setup {
      cmd = { vim.fn.stdpath("data") .. "/mason/bin/omnisharp" }, -- mason'dan gelen binary
      capabilities = capabilities, -- 🔥 cmp ile bağlantı
      enable_editorconfig_support = true,
      enable_roslyn_analyzers = true,
      enable_import_completion = true,

    }
  end,
},

}

