-- ~/.config/nvim/lua/plugins/langpacks.lua
return {
  -- ---------- Core tooling ----------
  -- Make sure Mason pulls all the servers/tools we need
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        -- LSP servers
        "gopls",
        "bash-language-server",
        "pyright",
        "basedpyright",
        "ruff",
        "clangd", -- C/C++ (Qt)
        "nil", -- Nix (or "nixd")
        "nimlangserver", -- Nim (fallback; or use nimlsp via nimble)
        "ansible-language-server",
        "tailwindcss-language-server",
        "eslint-lsp",
        "typescript-language-server",

        -- Formatters
        "shfmt",
        "shellcheck",
        "black",
        "isort",
        "prettierd",
        "eslint_d",
        "clang-format",
        "alejandra", -- or "nixfmt"
      })
    end,
  },

  -- Conform: format-on-save per filetype
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        sh = { "shfmt" },
        bash = { "shfmt" },
        javascript = { "prettierd", "eslint_d" },
        typescript = { "prettierd", "eslint_d" },
        javascriptreact = { "prettierd", "eslint_d" },
        typescriptreact = { "prettierd", "eslint_d" },
        go = { "gofumpt", "goimports-reviser", "golines" },
        hcl = { "terraform_fmt" },
        cpp = { "clang-format" },
        c = { "clang-format" },
        nix = { "alejandra" }, -- or "nixfmt"
        nim = {}, -- nimpretty exists but is not great; usually rely on LSP
        qml = {}, -- formatting is spotty; clang-format can help if configured
      },
    },
  },

  -- Treesitter languages
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "regex",
        "vim",
        "lua",
        "json",
        "yaml",
        "toml",
        "javascript",
        "typescript",
        "tsx",
        "go",
        "gomod",
        "gowork",
        "gosum",
        "python",
        "hcl",
        "terraform",
        "nix",
        "c",
        "cpp",
        "cmake",
        "make",
        "nim",
        "qmljs", -- QML/Qt (via qmljs parser in TS; falls back to js highlighting if absent)
      },
    },
  },

  -- ---------- Language-specific niceties ----------

  -- Go: tooling + DAP helpers
  { -- full Go workflow: build/test/coverage/code actions/etc
    "ray-x/go.nvim",
    ft = { "go", "gomod", "gowork" },
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-lua/plenary.nvim" },
    config = function()
      require("go").setup({
        lsp_cfg = true,
        lsp_keymaps = true,
        trouble = true,
        lsp_inlay_hints = { enable = true },
        icons = { breakpoint = "●", currentpos = "▶" },
      })
    end,
  }, -- go.nvim covers a lot; docs: https://github.com/ray-x/go.nvim :contentReference[oaicite:0]{index=0}

  -- TypeScript / React & React Native
  {
    "pmizio/typescript-tools.nvim",
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {}, -- sane defaults; faster & richer than tsserver wrapper
  }, -- :contentReference[oaicite:2]{index=2}

  -- Terraform
  {
    "hashivim/vim-terraform",
    ft = { "terraform", "tf", "tfvars", "hcl" },
    init = function()
      vim.g.terraform_fmt_on_save = 1
    end,
  }, -- pairs nicely with terraform-ls; plugin docs :contentReference[oaicite:5]{index=5}

  -- Ansible (syntax + LSP)
  {
    "pearofducks/ansible-vim",
    ft = { "yaml", "yml", "jinja2" },
  }, -- syntax/ft detection; LSP is ansible-language-server :contentReference[oaicite:6]{index=6}

  -- Nix (syntax + LSP)
  {
    "LnL7/vim-nix",
    ft = { "nix" },
  }, -- syntax; pair with nil or nixd LSPs :contentReference[oaicite:7]{index=7}

  -- CMake tooling for Qt/C++ projects
  {
    "Civitasv/cmake-tools.nvim",
    ft = { "c", "cpp", "cmake" },
    opts = {},
  }, -- generates/targets/builds nicely from inside nvim :contentReference[oaicite:8]{index=8}
}
