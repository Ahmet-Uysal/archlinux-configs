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
        ensure_installed = { "omnisharp" }, -- istediğin dilleri ekleyebilirsin
      }
    end,
  },

  -- Neovim LSP ayarları
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Omnisharp ayarı
      lspconfig.omnisharp.setup {
        cmd = { vim.fn.stdpath("data") .. "/mason/bin/OmniSharp" },
        capabilities = capabilities,
        enable_editorconfig_support = true,
        enable_roslyn_analyzers = true,
        enable_import_completion = true,
        analyze_open_documents_only = false, -- açılışta tüm dosyayı analiz et
       
    
      }
    end,
  },
}

