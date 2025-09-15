-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- Go specific keymaps
map("n", "<leader>gt", "<cmd>GoTest<cr>", { desc = "Go Test" })
map("n", "<leader>gT", "<cmd>GoTestFunc<cr>", { desc = "Go Test Function" })
map("n", "<leader>gc", "<cmd>GoCoverage<cr>", { desc = "Go Coverage" })
map("n", "<leader>gi", "<cmd>GoImplements<cr>", { desc = "Go Implements" })
map("n", "<leader>gr", "<cmd>GoReferrers<cr>", { desc = "Go Referrers" })
map("n", "<leader>gm", "<cmd>GoMod tidy<cr>", { desc = "Go Mod Tidy" })
map("n", "<leader>gv", "<cmd>GoVet<cr>", { desc = "Go Vet" })
map("n", "<leader>gb", "<cmd>GoBuild<cr>", { desc = "Go Build" })
map("n", "<leader>gR", "<cmd>GoRun<cr>", { desc = "Go Run" })
map("n", "<leader>gd", "<cmd>GoDoc<cr>", { desc = "Go Doc" })
map("n", "<leader>ge", "<cmd>GoIfErr<cr>", { desc = "Go Add If Err" })
map("n", "<leader>gf", "<cmd>GoFillStruct<cr>", { desc = "Go Fill Struct" })
map("n", "<leader>gy", "<cmd>GoFillSwitch<cr>", { desc = "Go Fill Switch" })

-- Python specific keymaps
map("n", "<leader>pv", "<cmd>VenvSelect<cr>", { desc = "Select Python Venv" })
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
map("n", "<leader>pt", "<cmd>lua require('neotest').run.run()<cr>", { desc = "Run Nearest Test" })
map("n", "<leader>pT", "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>", { desc = "Run Test File" })
map("n", "<leader>pd", "<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>", { desc = "Debug Test" })
map("n", "<leader>ps", "<cmd>lua require('neotest').summary.toggle()<cr>", { desc = "Test Summary" })
map("n", "<leader>po", "<cmd>lua require('neotest').output.open({ enter = true })<cr>", { desc = "Test Output" })

-- TypeScript/JavaScript specific keymaps
map("n", "<leader>ti", "<cmd>TypescriptAddMissingImports<cr>", { desc = "Add Missing Imports" })
map("n", "<leader>to", "<cmd>TypescriptOrganizeImports<cr>", { desc = "Organize Imports" })
map("n", "<leader>tu", "<cmd>TypescriptRemoveUnused<cr>", { desc = "Remove Unused" })
map("n", "<leader>tf", "<cmd>TypescriptFixAll<cr>", { desc = "Fix All" })
map("n", "<leader>tg", "<cmd>TypescriptGoToSourceDefinition<cr>", { desc = "Go to Source Definition" })
map("n", "<leader>tr", "<cmd>TypescriptRenameFile<cr>", { desc = "Rename File" })

-- Terraform specific keymaps
map("n", "<leader>hf", "<cmd>!terraform fmt %<cr>", { desc = "Format Terraform" })
map("n", "<leader>hv", "<cmd>!terraform validate<cr>", { desc = "Validate Terraform" })
map("n", "<leader>hp", "<cmd>!terraform plan<cr>", { desc = "Terraform Plan" })
map("n", "<leader>hi", "<cmd>!terraform init<cr>", { desc = "Terraform Init" })

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

-- Test runner keymaps
map("n", "<leader>tt", "<cmd>lua require('neotest').run.run()<cr>", { desc = "Run Nearest Test" })
map("n", "<leader>tT", "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>", { desc = "Run Test File" })
map("n", "<leader>ta", "<cmd>lua require('neotest').run.run(vim.fn.getcwd())<cr>", { desc = "Run All Tests" })
map("n", "<leader>ts", "<cmd>lua require('neotest').summary.toggle()<cr>", { desc = "Test Summary" })
map("n", "<leader>to", "<cmd>lua require('neotest').output.open({ enter = true })<cr>", { desc = "Test Output" })
map("n", "<leader>tO", "<cmd>lua require('neotest').output_panel.toggle()<cr>", { desc = "Test Output Panel" })
map("n", "<leader>tS", "<cmd>lua require('neotest').run.stop()<cr>", { desc = "Stop Test" })

-- CMake keymaps (for Qt projects)
map("n", "<leader>cg", "<cmd>CMakeGenerate<cr>", { desc = "CMake Generate" })
map("n", "<leader>cb", "<cmd>CMakeBuild<cr>", { desc = "CMake Build" })
map("n", "<leader>cr", "<cmd>CMakeRun<cr>", { desc = "CMake Run" })
map("n", "<leader>cd", "<cmd>CMakeDebug<cr>", { desc = "CMake Debug" })
map("n", "<leader>ct", "<cmd>CMakeSelectBuildTarget<cr>", { desc = "Select Build Target" })
map("n", "<leader>cl", "<cmd>CMakeSelectLaunchTarget<cr>", { desc = "Select Launch Target" })
map("n", "<leader>co", "<cmd>CMakeOpen<cr>", { desc = "Open CMake Console" })
map("n", "<leader>cc", "<cmd>CMakeClose<cr>", { desc = "Close CMake Console" })

-- Git workflow keymaps (comprehensive Git operations)
-- Quick Git operations
map("n", "<leader>gg", "<cmd>LazyGit<cr>", { desc = "LazyGit (Full Git UI)" })
map("n", "<leader>gn", "<cmd>Neogit<cr>", { desc = "Neogit (Magit-style)" })
map("n", "<leader>gs", "<cmd>Git<cr>", { desc = "Fugitive Git Status" })

-- Git status and navigation
map("n", "<leader>gS", function()
  vim.cmd("Git status")
end, { desc = "Git Status (detailed)" })

-- Staging and committing
map("n", "<leader>ga", "<cmd>Git add .<cr>", { desc = "Git Add All" })
map("n", "<leader>gA", "<cmd>Git add %<cr>", { desc = "Git Add Current File" })
map("n", "<leader>gci", function()
  local msg = vim.fn.input("Commit message: ")
  if msg ~= "" then
    vim.cmd("Git commit -m '" .. msg .. "'")
  end
end, { desc = "Git Commit with Message" })
map("n", "<leader>gca", function()
  local msg = vim.fn.input("Commit message: ")
  if msg ~= "" then
    vim.cmd("Git commit -am '" .. msg .. "'")
  end
end, { desc = "Git Commit All with Message" })

-- Pushing and pulling
map("n", "<leader>gp", "<cmd>Git push<cr>", { desc = "Git Push" })
map("n", "<leader>gP", "<cmd>Git pull<cr>", { desc = "Git Pull" })
map("n", "<leader>gpo", function()
  local branch = vim.fn.input("Push to remote branch: ", vim.fn.system("git branch --show-current"):gsub("\n", ""))
  if branch ~= "" then
    vim.cmd("Git push origin " .. branch)
  end
end, { desc = "Git Push Origin" })
map("n", "<leader>gpu", "<cmd>Git push -u origin HEAD<cr>", { desc = "Git Push Set Upstream" })

-- Branching
map("n", "<leader>gb", "<cmd>Git branch<cr>", { desc = "Git Branch List" })
map("n", "<leader>gbc", function()
  local branch = vim.fn.input("Create branch: ")
  if branch ~= "" then
    vim.cmd("Git checkout -b " .. branch)
  end
end, { desc = "Git Create Branch" })
map("n", "<leader>gbd", function()
  local branch = vim.fn.input("Delete branch: ")
  if branch ~= "" then
    vim.cmd("Git branch -d " .. branch)
  end
end, { desc = "Git Delete Branch" })
map("n", "<leader>gco", function()
  local branch = vim.fn.input("Checkout branch: ")
  if branch ~= "" then
    vim.cmd("Git checkout " .. branch)
  end
end, { desc = "Git Checkout Branch" })

-- Stashing
map("n", "<leader>gst", function()
  local msg = vim.fn.input("Stash message (optional): ")
  if msg ~= "" then
    vim.cmd("Git stash push -m '" .. msg .. "'")
  else
    vim.cmd("Git stash")
  end
end, { desc = "Git Stash" })
map("n", "<leader>gsp", "<cmd>Git stash pop<cr>", { desc = "Git Stash Pop" })
map("n", "<leader>gsl", "<cmd>Git stash list<cr>", { desc = "Git Stash List" })

-- Merging and rebasing
map("n", "<leader>gm", function()
  local branch = vim.fn.input("Merge branch: ")
  if branch ~= "" then
    vim.cmd("Git merge " .. branch)
  end
end, { desc = "Git Merge" })
map("n", "<leader>gr", function()
  local branch = vim.fn.input("Rebase onto: ")
  if branch ~= "" then
    vim.cmd("Git rebase " .. branch)
  end
end, { desc = "Git Rebase" })
map("n", "<leader>grc", "<cmd>Git rebase --continue<cr>", { desc = "Git Rebase Continue" })
map("n", "<leader>gra", "<cmd>Git rebase --abort<cr>", { desc = "Git Rebase Abort" })

-- Viewing and diffing
map("n", "<leader>gl", "<cmd>Git log --oneline -10<cr>", { desc = "Git Log (10 entries)" })
map("n", "<leader>gL", "<cmd>Git log --graph --oneline --all -20<cr>", { desc = "Git Log Graph" })
map("n", "<leader>gd", "<cmd>Gdiffsplit<cr>", { desc = "Git Diff Split" })
map("n", "<leader>gD", "<cmd>Git diff<cr>", { desc = "Git Diff" })

-- Remote operations
map("n", "<leader>gf", "<cmd>Git fetch<cr>", { desc = "Git Fetch" })
map("n", "<leader>gF", "<cmd>Git fetch --all<cr>", { desc = "Git Fetch All" })

-- Quick actions
map("n", "<leader>gu", "<cmd>Git restore --staged %<cr>", { desc = "Git Unstage Current File" })
map("n", "<leader>gU", "<cmd>Git restore --staged .<cr>", { desc = "Git Unstage All" })
map("n", "<leader>gR", "<cmd>Git restore %<cr>", { desc = "Git Restore Current File" })

-- LazyGit specific shortcuts
map("n", "<leader>gff", "<cmd>LazyGitCurrentFile<cr>", { desc = "LazyGit Current File" })
map("n", "<leader>gcc", "<cmd>LazyGitFilter<cr>", { desc = "LazyGit Commits" })

-- Quick commit and push workflow
map("n", "<leader>gq", function()
  local msg = vim.fn.input("Quick commit & push message: ")
  if msg ~= "" then
    vim.cmd("Git add .")
    vim.cmd("Git commit -m '" .. msg .. "'")
    vim.cmd("Git push")
    print("Committed and pushed: " .. msg)
  end
end, { desc = "Quick Commit & Push" })

-- Show current branch
map("n", "<leader>g?", function()
  local branch = vim.fn.system("git branch --show-current"):gsub("\n", "")
  local status = vim.fn.system("git status --porcelain")
  local clean = status == "" and "clean" or "dirty"
  print("Branch: " .. branch .. " (" .. clean .. ")")
end, { desc = "Show Git Status" })
