return {
  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Go
        gopls = {
          settings = {
            gopls = {
              gofumpt = true,
              codelenses = {
                gc_details = false,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              analyses = {
                fieldalignment = true,
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
              },
              usePlaceholders = true,
              completeUnimported = true,
              staticcheck = true,
              directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
              semanticTokens = true,
            },
          },
        },
        
        -- TypeScript/JavaScript/React Native
        tsserver = {
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
          },
        },
        
        -- Python
        pyright = {
          settings = {
            python = {
              analysis = {
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                useLibraryCodeForTypes = true,
                typeCheckingMode = "standard",
              },
            },
          },
        },
        ruff_lsp = {},
        
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
        
        -- Terraform
        terraformls = {
          settings = {
            terraform = {
              codelens = {
                references = true,
              },
            },
          },
        },
        
        -- Bash
        bashls = {
          settings = {
            bash = {
              highlightAllParsingErrors = true,
            },
          },
        },
        
        -- Nix
        nil_ls = {
          settings = {
            ["nil"] = {
              formatting = {
                command = { "alejandra" },
              },
            },
          },
        },
        
        -- C/C++ for Qt
        clangd = {
          keys = {
            { "<leader>cR", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
          },
          root_dir = function(fname)
            return require("lspconfig.util").root_pattern(
              "Makefile",
              "configure.ac",
              "configure.in",
              "config.h.in",
              "meson.build",
              "meson_options.txt",
              "build.ninja"
            )(fname) or require("lspconfig.util").root_pattern("compile_commands.json", "compile_flags.txt")(
              fname
            ) or require("lspconfig.util").find_git_ancestor(fname)
          end,
          capabilities = {
            offsetEncoding = { "utf-16" },
          },
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--fallback-style=llvm",
          },
          init_options = {
            usePlaceholders = true,
            completeUnimported = true,
            clangdFileStatus = true,
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

  -- Mason - Automatic LSP/DAP/Linter/Formatter installation
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        -- LSP servers
        "gopls",
        "typescript-language-server",
        "eslint-lsp",
        "pyright",
        "ruff-lsp",
        "ansible-language-server",
        "terraform-ls",
        "tflint",
        "bash-language-server",
        "nil",
        "clangd",
        
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
        
        -- Formatters
        "gofumpt",
        "goimports",
        "golines",
        "prettier",
        "black",
        "isort",
        "shfmt",
        "alejandra",
        "clang-format",
        "stylua",
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

  -- Go enhanced development
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
        lsp_cfg = true,
        lsp_gofumpt = true,
        lsp_on_attach = true,
        lsp_keymaps = true,
        lsp_codelens = true,
        lsp_diag_hdlr = true,
        lsp_inlay_hints = {
          enable = true,
          only_current_line = false,
          only_current_line_autocmd = "CursorHold",
          show_variable_name = true,
          parameter_hints_prefix = " ",
          show_parameter_hints = true,
          other_hints_prefix = "=> ",
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

  -- TypeScript enhanced development
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

  -- Terraform
  {
    "hashivim/vim-terraform",
    ft = { "terraform", "hcl", "tf" },
    config = function()
      vim.g.terraform_fmt_on_save = 1
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