return {
  "L3MON4D3/LuaSnip",
  version = "2.*", -- güncel sürüm
  build = "make install_jsregexp",
  dependencies = {
    "rafamadriz/friendly-snippets", -- 🔥 buraya da ekle
  },
  config = function()
    local ls = require("luasnip")
    local s = ls.snippet
    local t = ls.text_node
    local i = ls.insert_node

    -- Hazır snippetleri yükle
    require("luasnip.loaders.from_vscode").lazy_load()

    -- Senin özel snippetlerin
--    ls.add_snippets("csharp", {
--      s("prop", {
--        t("public "), i(1, "string"), t(" "), i(2, "MyProperty"), t(" { get; set; }")
--      }),
--
--      s("ctor", {
--        t("public "), i(1, "ClassName"), t("() { "), i(0), t(" }")
--      })
--    })
  end,
}

