return {
  "nvimdev/lspsaga.nvim",
  event = "LspAttach",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("lspsaga").setup({
      ui = {
        border = "rounded",
        code_action = "",
      },
    lightbulb = {
    enable = true,
    enable_in_insert = false,
    sign = true,
    sign_priority = 20,
    virtual_text = true,
  },
   diagnostic = {
        show_code_action = true,
        show_source = true,
      },
            code_action = {
    num_shortcut = true,
    show_server_name = true,
    extend_gitsigns = true,
    keys = {
      quit = {"q", "<Esc>"},       -- ESC veya q ile popup kapanır
      exec = "<CR>",               -- Enter ile seçilen action uygulanır
    },
  },
    })

    -- Keymapler
    local keymap = vim.keymap.set
   -- 📚 Dokümantasyon & Hover
    -- K → imleçteki sembolün dokümantasyonunu popup’ta açar
    keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>", { desc = "Hover Documentation" })

    -- 🐞 Diagnostikler
    -- gl → satırdaki tüm diagnostikleri popup olarak gösterir
    keymap("n", "gl", "<cmd>Lspsaga show_line_diagnostics<CR>", { desc = "Line Diagnostics" }) 
    -- ]d → sonraki hataya git
    keymap("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", { desc = "Next Diagnostic" }) 
    -- [d → önceki hataya git
    keymap("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { desc = "Prev Diagnostic" }) 
    -- <leader>cd → imlecin olduğu yerdeki hatayı popup olarak göster
    keymap("n", "<leader>cd", "<cmd>Lspsaga show_cursor_diagnostics<CR>", { desc = "Cursor Diagnostics" })

    -- 🔍 Kod Gezinme
    -- gd → imleçteki sembolün tanımına git
    keymap("n", "gd", "<cmd>Lspsaga goto_definition<CR>", { desc = "Go to Definition" }) 
    -- gD → tanımı küçük bir popup pencerede göster
    keymap("n", "gD", "<cmd>Lspsaga peek_definition<CR>", { desc = "Peek Definition" }) 
    -- gr → sembolün referanslarını, tanımlarını, implementasyonlarını listeler
    keymap("n", "gr", "<cmd>Lspsaga finder<CR>", { desc = "Find References/Definitions" }) 

    -- ✍️ Refactor & Actions
    -- <leader>rn → sembolün adını değiştir (rename)
    keymap("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", { desc = "Rename Symbol" }) 
    -- <leader>ca → code action (örneğin using ekleme, fix önerisi)
    --keymap("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", { desc = "Code Action" }) 
        -- Normal modda code action
--keymap("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", { desc = "Code Action" })

-- Visual modda seçili alan için code action
-- Normal + Visual mod için tek keymap
vim.keymap.set({ "n", "v" }, "<leader>ca", "<cmd>Lspsaga code_action<CR>", { desc = "Code Action" })


    -- 📑 Outline
    -- <leader>o → sol panelde bulunduğun dosyanın outline’ını (class, method listesi) açar
    keymap("n", "<leader>o", "<cmd>Lspsaga outline<CR>", { desc = "Symbols Outline" })

    -- 🧭 Call Hierarchy
    -- <leader>ci → fonksiyonu kimler çağırıyor (incoming calls)
    keymap("n", "<leader>ci", "<cmd>Lspsaga incoming_calls<CR>", { desc = "Incoming Calls" })
    -- <leader>co → bu fonksiyon hangi fonksiyonları çağırıyor (outgoing calls)
    keymap("n", "<leader>co", "<cmd>Lspsaga outgoing_calls<CR>", { desc = "Outgoing Calls" })
  end,}

