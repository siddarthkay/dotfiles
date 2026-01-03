-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- Go specific keymaps (using <leader>Go prefix to avoid conflicts with Git)
map("n", "<leader>Got", "<cmd>GoTest<cr>", { desc = "Go Test" })
map("n", "<leader>GoT", "<cmd>GoTestFunc<cr>", { desc = "Go Test Function" })
map("n", "<leader>Goc", "<cmd>GoCoverage<cr>", { desc = "Go Coverage" })
map("n", "<leader>Goi", "<cmd>GoImplements<cr>", { desc = "Go Implements" })
map("n", "<leader>Gor", "<cmd>GoReferrers<cr>", { desc = "Go Referrers" })
map("n", "<leader>Gom", "<cmd>GoMod tidy<cr>", { desc = "Go Mod Tidy" })
map("n", "<leader>Gov", "<cmd>GoVet<cr>", { desc = "Go Vet" })
map("n", "<leader>Gob", "<cmd>GoBuild<cr>", { desc = "Go Build" })
map("n", "<leader>GoR", "<cmd>GoRun<cr>", { desc = "Go Run" })
map("n", "<leader>God", "<cmd>GoDoc<cr>", { desc = "Go Doc" })
map("n", "<leader>Goe", "<cmd>GoIfErr<cr>", { desc = "Go Add If Err" })
map("n", "<leader>Gof", "<cmd>GoFillStruct<cr>", { desc = "Go Fill Struct" })
map("n", "<leader>Goy", "<cmd>GoFillSwitch<cr>", { desc = "Go Fill Switch" })

-- Python specific keymaps (VenvSelect keymap is defined in the plugin, so removed duplicate here)
map("n", "<leader>pc", function()
  -- Create new virtual environment
  local venv_name = vim.fn.input("Virtual environment name (default: .venv): ")
  if venv_name == "" then
    venv_name = ".venv"
  end

  local cwd = vim.fn.getcwd()
  local venv_path = cwd .. "/" .. venv_name

  if vim.fn.isdirectory(venv_path) == 1 then
    print("Virtual environment already exists: " .. venv_path)
    return
  end

  local python_cmd = vim.fn.input("Python executable (default: python3): ")
  if python_cmd == "" then
    python_cmd = "python3"
  end

  print("Creating virtual environment...")
  local result = vim.fn.system(python_cmd .. " -m venv " .. venv_path)

  if vim.v.shell_error == 0 then
    print("Virtual environment created: " .. venv_path)
    -- Set as current python
    vim.g.python3_host_prog = venv_path .. "/bin/python"
    vim.cmd("LspRestart")

    -- Ask if user wants to install requirements
    local install_reqs = vim.fn.confirm("Install requirements.txt?", "&Yes\n&No", 2)
    if install_reqs == 1 and vim.fn.filereadable("requirements.txt") == 1 then
      local pip_result = vim.fn.system(venv_path .. "/bin/pip install -r requirements.txt")
      if vim.v.shell_error == 0 then
        print("Requirements installed successfully")
      else
        print("Failed to install requirements: " .. pip_result)
      end
    end
  else
    print("Failed to create virtual environment: " .. result)
  end
end, { desc = "Create Python Venv" })
map("n", "<leader>pe", function()
  -- Manual venv activation fallback
  local venv = vim.fn.input("Virtual env path: ", "", "file")
  if venv ~= "" then
    vim.g.python3_host_prog = venv .. "/bin/python"
    print("Set Python to: " .. vim.g.python3_host_prog)
    -- Restart LSP to use new python
    vim.cmd("LspRestart")
  end
end, { desc = "Set Python Env Manually" })
map("n", "<leader>pp", function()
  print("Current Python: " .. (vim.g.python3_host_prog or "system default"))
end, { desc = "Show Current Python" })
map("n", "<leader>pi", function()
  -- Install package in current venv
  local current_python = vim.g.python3_host_prog
  if not current_python then
    print("No virtual environment active. Use <leader>pv to select one.")
    return
  end

  local pip_path = vim.fn.fnamemodify(current_python, ":h") .. "/pip"
  if vim.fn.executable(pip_path) == 0 then
    print("pip not found in current environment")
    return
  end

  local package = vim.fn.input("Package to install: ")
  if package ~= "" then
    print("Installing " .. package .. "...")
    local result = vim.fn.system(pip_path .. " install " .. package)
    if vim.v.shell_error == 0 then
      print("Package installed successfully")
    else
      print("Failed to install package: " .. result)
    end
  end
end, { desc = "Install Python Package" })

-- TypeScript/JavaScript specific keymaps
map("n", "<leader>ci", "<cmd>TypescriptAddMissingImports<cr>", { desc = "Add Missing Imports" })
map("n", "<leader>co", "<cmd>TypescriptOrganizeImports<cr>", { desc = "Organize Imports" })
map("n", "<leader>cu", "<cmd>TypescriptRemoveUnused<cr>", { desc = "Remove Unused" })
map("n", "<leader>cF", "<cmd>TypescriptFixAll<cr>", { desc = "Fix All" })
map("n", "<leader>cD", "<cmd>TypescriptGoToSourceDefinition<cr>", { desc = "Go to Source Definition" })
map("n", "<leader>cR", "<cmd>TypescriptRenameFile<cr>", { desc = "Rename File" })

-- Terraform specific keymaps
map("n", "<leader>Tf", "<cmd>!terraform fmt %<cr>", { desc = "Format Terraform" })
map("n", "<leader>Tv", "<cmd>!terraform validate<cr>", { desc = "Validate Terraform" })
map("n", "<leader>Tp", "<cmd>!terraform plan<cr>", { desc = "Terraform Plan" })
map("n", "<leader>Ti", "<cmd>!terraform init<cr>", { desc = "Terraform Init" })

-- DAP (Debugging) keymaps
map("n", "<F5>", "<cmd>lua require('dap').continue()<cr>", { desc = "Debug Continue" })
map("n", "<F10>", "<cmd>lua require('dap').step_over()<cr>", { desc = "Debug Step Over" })
map("n", "<F11>", "<cmd>lua require('dap').step_into()<cr>", { desc = "Debug Step Into" })
map("n", "<F12>", "<cmd>lua require('dap').step_out()<cr>", { desc = "Debug Step Out" })
map("n", "<leader>db", "<cmd>lua require('dap').toggle_breakpoint()<cr>", { desc = "Toggle Breakpoint" })
map("n", "<leader>dB", "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>", { desc = "Conditional Breakpoint" })
map("n", "<leader>dr", "<cmd>lua require('dap').repl.open()<cr>", { desc = "Open Debug REPL" })
map("n", "<leader>dl", "<cmd>lua require('dap').run_last()<cr>", { desc = "Run Last Debug" })
map("n", "<leader>du", "<cmd>lua require('dapui').toggle()<cr>", { desc = "Toggle Debug UI" })
map("n", "<leader>de", "<cmd>lua require('dapui').eval()<cr>", { desc = "Debug Eval" })

-- Test runner keymaps (generic - works for all languages via neotest)
map("n", "<leader>tt", "<cmd>lua require('neotest').run.run()<cr>", { desc = "Run Nearest Test" })
map("n", "<leader>tT", "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>", { desc = "Run Test File" })
map("n", "<leader>ta", "<cmd>lua require('neotest').run.run(vim.fn.getcwd())<cr>", { desc = "Run All Tests" })
map("n", "<leader>ts", "<cmd>lua require('neotest').summary.toggle()<cr>", { desc = "Test Summary" })
map("n", "<leader>to", "<cmd>lua require('neotest').output.open({ enter = true })<cr>", { desc = "Test Output" })
map("n", "<leader>tO", "<cmd>lua require('neotest').output_panel.toggle()<cr>", { desc = "Test Output Panel" })
map("n", "<leader>tS", "<cmd>lua require('neotest').run.stop()<cr>", { desc = "Stop Test" })
map("n", "<leader>td", "<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>", { desc = "Debug Test" })

-- CMake keymaps (for Qt projects)
map("n", "<leader>mg", "<cmd>CMakeGenerate<cr>", { desc = "CMake Generate" })
map("n", "<leader>mb", "<cmd>CMakeBuild<cr>", { desc = "CMake Build" })
map("n", "<leader>mr", "<cmd>CMakeRun<cr>", { desc = "CMake Run" })
map("n", "<leader>md", "<cmd>CMakeDebug<cr>", { desc = "CMake Debug" })
map("n", "<leader>mt", "<cmd>CMakeSelectBuildTarget<cr>", { desc = "Select Build Target" })
map("n", "<leader>ml", "<cmd>CMakeSelectLaunchTarget<cr>", { desc = "Select Launch Target" })
map("n", "<leader>mo", "<cmd>CMakeOpen<cr>", { desc = "Open CMake Console" })
map("n", "<leader>mc", "<cmd>CMakeClose<cr>", { desc = "Close CMake Console" })
