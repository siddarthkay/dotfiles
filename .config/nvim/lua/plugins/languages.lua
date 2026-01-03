return {
  -- LSP Configuration (only for servers not handled by LazyVim extras)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Ansible
        ansiblels = {
          settings = {
            ansible = {
              ansible = {
                path = "ansible",
              },
              executionEnvironment = {
                enabled = false,
              },
              python = {
                interpreterPath = "python",
              },
              validation = {
                enabled = true,
                lint = {
                  enabled = true,
                  path = "ansible-lint",
                },
              },
            },
          },
        },

        -- Groovy
        groovyls = {
          cmd = { "groovy-language-server" },
        },

        -- Bash
        bashls = {
          settings = {
            bash = {
              highlightAllParsingErrors = true,
            },
          },
        },

        -- YAML - completely disable yamlls
        yamlls = false,

        -- Nix
        nil_ls = {
          settings = {
            ["nil"] = {
              formatting = {
                command = { "" }, -- Disabled formatting
              },
            },
          },
        },

        -- QML
        qmlls = {
          cmd = { "qmlls" },
        },

        -- Nim
        nimls = {},
      },
    },
  },

  -- Mason - Automatic LSP/DAP/Linter installation (removed unused formatters)
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        -- LSP servers (not handled by LazyVim extras)
        "ansible-language-server",
        "bash-language-server",

        -- DAP
        "delve", -- Go debugger
        "debugpy", -- Python debugger
        "js-debug-adapter", -- JavaScript/TypeScript debugger
        "codelldb", -- C/C++ debugger

        -- Linters
        "golangci-lint",
        "eslint_d",
        "ruff",
        "ansible-lint",
        "shellcheck",
        "tflint",
        "cpplint",
      })
    end,
  },

  -- Treesitter - Syntax highlighting and code understanding
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "go",
        "gomod",
        "gowork",
        "gosum",
        "typescript",
        "tsx",
        "javascript",
        "jsdoc",
        "python",
        "yaml",
        "groovy",
        "hcl",
        "terraform",
        "bash",
        "nix",
        "c",
        "cpp",
        "cmake",
        "qmljs",
        "nim",
        "nim_format_string",
        "regex",
        "json",
        "json5",
        "jsonc",
        "toml",
        "markdown",
        "markdown_inline",
        "dockerfile",
        "gitignore",
        "git_config",
        "git_rebase",
        "gitcommit",
        "gitattributes",
      })
    end,
  },

  -- Formatting (disabled)
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {},
      format_on_save = false,
      format_after_save = false,
    },
  },

  -- Linting (disabled)
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {},
    },
  },

  -- Go enhanced development (LSP handled by LazyVim extra)
  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup({
        goimports = "gopls",
        gofmt = "gopls",
        tag_transform = false,
        test_dir = "",
        comment_placeholder = "",
        lsp_cfg = false, -- Let LazyVim extra handle gopls
        lsp_gofumpt = false,
        lsp_on_attach = false,
        lsp_keymaps = false,
        lsp_codelens = true,
        lsp_diag_hdlr = false,
        lsp_inlay_hints = {
          enable = false, -- LazyVim handles this
        },
        dap_debug = true,
        dap_debug_keymap = true,
        dap_debug_gui = true,
        dap_debug_vt = true,
        build_tags = "tag1,tag2",
        test_runner = "go",
        run_in_floaterm = false,
        trouble = true,
        luasnip = true,
      })
    end,
    event = { "CmdlineEnter" },
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()',
  },

  -- TypeScript enhanced development (replaces tsserver)
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    opts = {
      settings = {
        separate_diagnostic_server = true,
        composite_mode = "separate_diagnostic",
        publish_diagnostic_on = "insert_leave",
        expose_as_code_action = "all",
        tsserver_path = nil,
        tsserver_plugins = {},
        tsserver_max_memory = "auto",
        tsserver_format_options = {},
        tsserver_file_preferences = {
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
        tsserver_locale = "en",
        complete_function_calls = true,
        include_completions_with_insert_text = true,
        code_lens = "all",
        disable_member_code_lens = false,
        jsx_close_tag = {
          enable = true,
          filetypes = { "javascriptreact", "typescriptreact" },
        },
      },
    },
  },

  -- Python virtual environment selector
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "mfussenegger/nvim-dap-python",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("venv-selector").setup({
        settings = {
          options = {
            notify_user_on_venv_activation = true,
            enable_default_searches = true,
            enable_cached_venvs = true,
          },
          search = {
            anaconda_envs = {
              command = "fd python$ ~/anaconda3/envs --full-path --color never",
              type = "anaconda",
            },
            anaconda_base = {
              command = "fd python$ ~/anaconda3/bin --full-path --color never",
              type = "anaconda",
            },
            miniconda_envs = {
              command = "fd python$ ~/miniconda3/envs --full-path --color never",
              type = "miniconda",
            },
            miniconda_base = {
              command = "fd python$ ~/miniconda3/bin --full-path --color never",
              type = "miniconda",
            },
            pyenv = {
              command = "fd python$ ~/.pyenv/versions --full-path --color never",
              type = "pyenv",
            },
            venv = {
              command = "fd python$ ~/.virtualenvs --full-path --color never",
              type = "venv",
            },
            workspace_venvs = {
              command = "fd -HI -a -t f -E __pycache__ python$ ~/code --full-path --color never",
              type = "venv",
            },
            status_im_venvs = {
              command = "fd -HI -a -t f -E __pycache__ python$ ~/code/status-im --full-path --color never",
              type = "venv",
            },
            local_venvs = {
              command = "fd -HI -a -t f -E __pycache__ python$ . --max-depth 4 --full-path --color never",
              type = "venv",
            },
          },
        },
      })
    end,
    ft = "python",
    keys = {
      { "<leader>cv", "<cmd>:VenvSelect<cr>", desc = "Select VirtualEnv", ft = "python" },
      { "<leader>pv", "<cmd>:VenvSelect<cr>", desc = "Select VirtualEnv", ft = "python" },
    },
  },

  -- Ansible
  {
    "pearofducks/ansible-vim",
    ft = { "yaml.ansible", "ansible", "ansible_hosts" },
  },

  -- Terraform (format on save disabled)
  {
    "hashivim/vim-terraform",
    ft = { "terraform", "hcl", "tf" },
    config = function()
      vim.g.terraform_fmt_on_save = 0
      vim.g.terraform_align = 1
    end,
  },

  -- Nix
  {
    "LnL7/vim-nix",
    ft = "nix",
  },

  -- QML/Qt
  {
    "peterhoeg/vim-qml",
    ft = { "qml", "qbs" },
  },

  -- Groovy
  {
    "martinda/Jenkinsfile-vim-syntax",
    ft = { "Jenkinsfile", "groovy" },
  },

  -- DAP (Debug Adapter Protocol) configuration
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-telescope/telescope-dap.nvim",
    },
  },

  -- Go debugging
  {
    "leoluz/nvim-dap-go",
    ft = "go",
    dependencies = "mfussenegger/nvim-dap",
    config = function()
      require("dap-go").setup()
    end,
  },

  -- Python debugging
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = "mfussenegger/nvim-dap",
    config = function()
      require("dap-python").setup()
    end,
  },

  -- JavaScript/TypeScript debugging
  {
    "mxsdev/nvim-dap-vscode-js",
    ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    dependencies = {
      "mfussenegger/nvim-dap",
      {
        "microsoft/vscode-js-debug",
        opt = true,
        build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
      },
    },
    config = function()
      require("dap-vscode-js").setup({
        debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
        adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
      })
    end,
  },

  -- Test runners
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "fredrikaverpil/neotest-golang",
      "nvim-neotest/neotest-python",
      "nvim-neotest/neotest-jest",
      "rouge8/neotest-rust",
      "rcasia/neotest-bash",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-golang"),
          require("neotest-python"),
          require("neotest-jest"),
          require("neotest-bash"),
        },
      })
    end,
  },

  -- Nim support
  {
    "alaviss/nim.nvim",
    ft = "nim",
  },

  -- CMake for Qt projects
  {
    "Civitasv/cmake-tools.nvim",
    ft = { "cmake", "c", "cpp" },
    opts = {},
  },
}
