-- You can also add or configure plugins by creating files in this `plugins/` folder
-- Here are some examples:

---@type LazySpec
return {

  -- == Examples of Adding Plugins ==

  "andweeb/presence.nvim",
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function() require("lsp_signature").setup() end,
  },

  -- == Examples of Overriding Plugins ==

  -- customize alpha options
  {
    "goolord/alpha-nvim", -- this 
    opts = function(_, opts)
      -- customize the dashboard header
      opts.section.header.val = {
        " █████  ███████ ████████ ██████   ██████",
        "██   ██ ██         ██    ██   ██ ██    ██",
        "███████ ███████    ██    ██████  ██    ██",
        "██   ██      ██    ██    ██   ██ ██    ██",
        "██   ██ ███████    ██    ██   ██  ██████",
        " ",
        "    ███    ██ ██    ██ ██ ███    ███",
        "    ████   ██ ██    ██ ██ ████  ████",
        "    ██ ██  ██ ██    ██ ██ ██ ████ ██",
        "    ██  ██ ██  ██  ██  ██ ██  ██  ██",
        "    ██   ████   ████   ██ ██      ██",
      }
      return opts
    end,
  },
  -- You can disable default plugins as follows:
  { "max397574/better-escape.nvim", enabled = false },

  -- You can also easily customize additional setup of plugins that is outside of the plugin's setup call
  {
    "L3MON4D3/LuaSnip",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.luasnip"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom luasnip configuration such as filetype extend or custom snippets
      local luasnip = require "luasnip"
      luasnip.filetype_extend("javascript", { "javascriptreact" })
    end,
  },

  {
    "windwp/nvim-autopairs",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.nvim-autopairs"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom autopairs configuration such as custom rules
      local npairs = require "nvim-autopairs"
      local Rule = require "nvim-autopairs.rule"
      local cond = require "nvim-autopairs.conds"
      npairs.add_rules(
        {
          Rule("$", "$", { "tex", "latex" })
            -- don't add a pair if the next character is %
            :with_pair(cond.not_after_regex "%%")
            -- don't add a pair if  the previous character is xxx
            :with_pair(
              cond.not_before_regex("xxx", 3)
            )
            -- don't move right when repeat character
            :with_move(cond.none())
            -- don't delete if the next character is xx
            :with_del(cond.not_after_regex "xx")
            -- disable adding a newline when you press <cr>
            :with_cr(cond.none()),
        },
        -- disable for .vim files, but it work for another filetypes
        Rule("a", "a", "-vim")
      )
    end,
  },
  {
    "github/copilot.vim",
    enabled = true,
    cmd = "Copilot",
    event = "BufRead",
    config = function()
      vim.b.copilot_enabled = true
      vim.g.copilot_no_tab_map = true

      local keymap = vim.keymap.set
      -- https://github.com/orgs/community/discussions/29817#discussioncomment-4217615
      keymap(
        "i",
        "<C-a>",
        'copilot#Accept("<CR>")',
        { silent = true, expr = true, script = true, replace_keycodes = false }
      )
      keymap("i", "<M-]>", "<Plug>(copilot-next)")
      keymap("i", "<M-[>", "<Plug>(copilot-previous)")
      keymap("i", "<M-d>", "<Plug>(copilot-dismiss)")
      keymap("i", "<M-/>", "<Plug>(copilot-suggest)")
      
      -- Disable Copilot for large files
      vim.cmd([[
        autocmd BufReadPre * 
        lua if vim.fn.getfsize(vim.fn.expand("<afile>")) > 100000 or vim.fn.getfsize(vim.fn.expand("<afile>")) == -2 then vim.b.copilot_enabled = false end
      ]])
    end,
  },
  {
    "neoclide/coc.nvim",
    branch = "release",
    event = "VeryLazy",
    config = function()
      local coc_config = {
        -- 基本設定
        suggest = {
          noselect = false,
          enablePreselect = false,
          triggerAfterInsertEnter = true,
          timeout = 5000,
          enablePreview = true,
          floatEnable = true,
          detailField = "preview",
          snippetIndicator = "🧩",
        },
        -- 診断設定
        diagnostic = {
          displayByAle = false,
          errorSign = "❌",
          warningSign = "⚠️",
          infoSign = "ℹ️",
          hintSign = "💡",
          virtualText = true,
          virtualTextPrefix = "❯❯",
        },
        -- コードアクション設定
        codeAction = {
          showDocumentation = {
            enable = true,
          },
        },
        -- 補完設定
        completion = {
          triggerAfterInsertEnter = true,
          minTriggerInputLength = 2,
          maxItemCount = 50,
        },
        -- シグネチャヘルプ設定
        signature = {
          enable = true,
          target = "float",
        },
        -- 言語サーバー設定
        languageserver = {
          -- 例: TypeScript
          typescript = {
            enable = true,
            filetypes = {"typescript", "typescriptreact", "typescript.tsx"},
          },
          -- 必要に応じて他の言語サーバーを追加
        },
        -- Biome設定
        biome = {
          enabled = true,
          lspBin = "biome",
          requireConfiguration = false,
          enableFormat = true,
          enableLint = true,
        },
        -- ソース設定
        sources = {
          {name = "coc-snippets"},
          {name = "buffer"},
          {name = "file"},
          {name = "path"},
        },
        -- ステータスライン設定
        status = {
          enable = true,
          separator = " ",
        },
        -- 拡張機能設定
        extensions = {
          "coc-json",
          "coc-tsserver",
          "coc-eslint",
          "coc-prettier",
          "coc-biome",
          -- 必要に応じて他の拡張機能を追加
        },
        -- フォーマット設定
        format = {
          javascriptSortImports = true,
          typescriptSortImports = true,
        },
        -- 補完アイコン設定
        list = {
          indicator = ">",
          nextKeymap = "<C-j>",
          previousKeymap = "<C-k>",
        },
      }

      -- coc.nvimの設定を適用
      vim.g.coc_user_config = coc_config

    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim"
  }
}

