return {
  "neovim/nvim-lspconfig",
  dependencies = {
    {
      "stevearc/conform.nvim",
      branch = "nvim-0.9",
    },
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/nvim-cmp",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "j-hui/fidget.nvim",
  },

  config = function()
    require("conform").setup({
      format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
      formatters_by_ft = {
        lua = { "stylua" },
        -- Conform will run multiple formatters sequentially
        python = { "isort", "black" },
        -- You can customize some of the format options for the filetype (:help conform.format)
        rust = { "rustfmt", lsp_format = "fallback" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        vue = { "prettierd", "prettier", stop_after_first = true },
        ts = { "prettierd", "prettier", stop_after_first = true },
        typescriptvue = { "prettierd", "prettier", stop_after_first = true, lsp_format = "fallback" },
      },
      formatters = {
        prettier = {
          require_cwd = true,

          cwd = require("conform.util").root_file({
            ".prettierrc",
            ".prettierrc.json",
            ".prettierrc.yml",
            ".prettierrc.yaml",
            ".prettierrc.json5",
            ".prettierrc.js",
            ".prettierrc.cjs",
            ".prettierrc.mjs",
            ".prettierrc.toml",
            "prettier.config.js",
            "prettier.config.cjs",
            "prettier.config.mjs",
          }),
        },
      },
      vim.keymap.set({ "n", "v" }, "<leader>fm", function()
        require("conform").format({ lsp_format = true, async = false, timeout_ms = 500 })
      end, { desc = "Format file or range in (in visual mode)" }),
    })
    local cmp = require("cmp")
    local cmp_lsp = require("cmp_nvim_lsp")
    local capabilities = vim.tbl_deep_extend(
      "force",
      {},
      vim.lsp.protocol.make_client_capabilities(),
      cmp_lsp.default_capabilities()
    )

    require("fidget").setup({})
    require("mason").setup({
      ensure_installed = {
        "prettierd",
        "prettier",
      },
    })
    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls",
        "rust_analyzer",
        "marksman",
        "vuels",
        "volar",
        "ts_ls",
      },
      handlers = {
        function(server_name) -- default handler (optional)
          require("lspconfig")[server_name].setup({
            capabilities = capabilities,
          })
        end,

        zls = function()
          local lspconfig = require("lspconfig")
          lspconfig.zls.setup({
            root_dir = lspconfig.util.root_pattern(".git", "build.zig", "zls.json"),
            settings = {
              zls = {
                enable_inlay_hints = true,
                enable_snippets = true,
                warn_style = true,
              },
            },
          })
          vim.g.zig_fmt_parse_errors = 0
          vim.g.zig_fmt_autosave = 0
        end,
        ["ts_ls"] = function()
          local lspconfig = require("lspconfig")
          lspconfig.ts_ls.setup({
            init_options = {
              plugins = {
                {
                  name = "@vue/typescript-plugin",
                  location = vim.fn.stdpath("data")
                      .. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
                  languages = { "vue" },
                },
              },
            },
            settings = {
              typescript = {
                tsserver = {
                  useSyntaxServer = false,
                },
                inlayHints = {
                  includeInlayParameterNameHints = "all",
                  includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                  includeInlayFunctionParameterTypeHints = true,
                  includeInlayVariableTypeHints = true,
                  includeInlayVariableTypeHintsWhenTypeMatchesName = true,
                  includeInlayPropertyDeclarationTypeHints = true,
                  includeInlayFunctionLikeReturnTypeHints = true,
                  includeInlayEnumMemberValueHints = true,
                },
              },
            },
          })
        end,
        volar = function()
          local lspconfig = require("lspconfig")
          lspconfig.volar.setup({
            init_options = {
              vue = {
                hybridMode = false,
              },
            },
            settings = {
              typescript = {
                inlayHints = {
                  enumMemberValues = {
                    enabled = true,
                  },
                  functionLikeReturnTypes = {
                    enabled = true,
                  },
                  propertyDeclarationTypes = {
                    enabled = true,
                  },
                  parameterTypes = {
                    enabled = true,
                    suppressWhenArgumentMatchesName = true,
                  },
                  variableTypes = {
                    enabled = true,
                  },
                },
              },
            },
          })
        end,
        ["lua_ls"] = function()
          local lspconfig = require("lspconfig")
          lspconfig.lua_ls.setup({
            capabilities = capabilities,
            settings = {
              Lua = {
                runtime = { version = "Lua 5.1" },
                diagnostics = {
                  globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                },
              },
            },
          })
        end,
      },
    })

    local cmp_select = { behavior = cmp.SelectBehavior.Select }

    cmp.setup({
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
        ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
        ["<C-y>"] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" }, -- For luasnip users.
      }, {
        { name = "buffer" },
      }),
    })

    vim.diagnostic.config({
      -- update_in_insert = true,
      float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
      },
    })
  end,
}
