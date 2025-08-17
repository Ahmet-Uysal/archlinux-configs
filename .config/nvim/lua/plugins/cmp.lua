return {
  -- Otomatik tamamlama motoru
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",   -- LSP için kaynak
      "hrsh7th/cmp-buffer",     -- Buffer içinden tamamlama
      "hrsh7th/cmp-path",       -- Dosya yolu tamamlama
      "hrsh7th/cmp-cmdline",    -- Komut satırı tamamlama
      "L3MON4D3/LuaSnip",       -- Snippet engine
      "saadparwaiz1/cmp_luasnip", -- Snippet kaynakları
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(), -- Manuel tamamlama aç
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Enter ile seç
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" }, -- LSP (Omnisharp buradan gelir)
          { name = "luasnip" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },
}

