-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

-- Go specific settings
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("go_settings"),
  pattern = { "go", "gomod", "gowork", "gosum" },
  callback = function()
    vim.opt_local.expandtab = false
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
  end,
})

-- Python specific settings and virtual environment detection
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("python_settings"),
  pattern = "python",
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.textwidth = 88 -- Black's default line length
    
    -- Auto-detect virtual environment
    local cwd = vim.fn.getcwd()
    local venv_paths = {
      cwd .. "/.venv",
      cwd .. "/venv", 
      cwd .. "/env",
      vim.fn.expand("~/.virtualenvs"),
      vim.fn.expand("~/venvs"),
      vim.fn.expand("~/code") .. "/" .. vim.fn.fnamemodify(cwd, ":t") .. "/.venv",
      vim.fn.expand("~/code") .. "/" .. vim.fn.fnamemodify(cwd, ":t") .. "/venv",
    }
    
    for _, path in ipairs(venv_paths) do
      if vim.fn.isdirectory(path) == 1 then
        local python_path = path .. "/bin/python"
        if vim.fn.executable(python_path) == 1 then
          vim.g.python3_host_prog = python_path
          break
        end
      end
    end
  end,
})

-- TypeScript/JavaScript specific settings
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("typescript_settings"),
  pattern = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
})

-- Terraform specific settings
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("terraform_settings"),
  pattern = { "terraform", "hcl", "tf" },
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.commentstring = "# %s"
  end,
})

-- Ansible specific settings
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = augroup("ansible_detection"),
  pattern = { "*/playbooks/*.yml", "*/playbooks/*.yaml", "*/roles/*/tasks/*.yml", "*/roles/*/tasks/*.yaml", "*/ansible/*.yml", "*/ansible/*.yaml" },
  callback = function()
    vim.bo.filetype = "yaml.ansible"
  end,
})

-- Groovy/Jenkinsfile specific settings
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = augroup("groovy_detection"),
  pattern = { "Jenkinsfile", "*.jenkins", "*.groovy", "*.gradle" },
  callback = function()
    vim.bo.filetype = "groovy"
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
  end,
})

-- Nix specific settings
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("nix_settings"),
  pattern = "nix",
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
})

-- QML specific settings
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = augroup("qml_detection"),
  pattern = { "*.qml", "*.qbs" },
  callback = function()
    vim.bo.filetype = "qml"
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
  end,
})

-- Nim specific settings
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("nim_settings"),
  pattern = "nim",
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
})

-- C/C++ (Qt) specific settings
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("cpp_settings"),
  pattern = { "c", "cpp", "h", "hpp", "cc", "cxx" },
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
  end,
})

-- Bash specific settings
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("bash_settings"),
  pattern = { "sh", "bash", "zsh" },
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
})

