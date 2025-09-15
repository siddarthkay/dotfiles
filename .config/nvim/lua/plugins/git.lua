return {
  -- LazyGit integration
  {
    "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
      { "<leader>gf", "<cmd>LazyGitCurrentFile<cr>", desc = "LazyGit Current File" },
      { "<leader>gc", "<cmd>LazyGitFilter<cr>", desc = "LazyGit Commits" },
    },
  },

  -- Enhanced Git signs with more features
  {
    "lewis6991/gitsigns.nvim",
    event = "LazyFile",
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      signs_staged = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        -- Navigation
        map("n", "]h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gs.nav_hunk("next")
          end
        end, "Next Hunk")
        map("n", "[h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gs.nav_hunk("prev")
          end
        end, "Prev Hunk")
        map("n", "]H", function() gs.nav_hunk("last") end, "Last Hunk")
        map("n", "[H", function() gs.nav_hunk("first") end, "First Hunk")

        -- Actions
        map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
        map("n", "<leader>ghB", function() gs.blame() end, "Blame Buffer")
        map("n", "<leader>ghd", gs.diffthis, "Diff This")
        map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")

        -- Text object
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
      end,
    },
  },

  -- Git blame annotations
  {
    "f-person/git-blame.nvim",
    event = "LazyFile",
    opts = {
      enabled = false, -- disable by default, toggle with command
      message_template = " <summary> • <date> • <author> • <<sha>>",
      date_format = "%m-%d-%Y %H:%M:%S",
      virtual_text_column = 1,
    },
    keys = {
      { "<leader>gbt", "<cmd>GitBlameToggle<cr>", desc = "Toggle Git Blame" },
      { "<leader>gbe", "<cmd>GitBlameEnable<cr>", desc = "Enable Git Blame" },
      { "<leader>gbd", "<cmd>GitBlameDisable<cr>", desc = "Disable Git Blame" },
      { "<leader>gbo", "<cmd>GitBlameOpenCommitURL<cr>", desc = "Open Commit URL" },
      { "<leader>gbc", "<cmd>GitBlameCopyCommitURL<cr>", desc = "Copy Commit URL" },
    },
  },

  -- Advanced Git operations
  {
    "tpope/vim-fugitive",
    cmd = {
      "G",
      "Git",
      "Gdiffsplit",
      "Gread",
      "Gwrite",
      "Ggrep",
      "GMove",
      "GDelete",
      "GBrowse",
      "GRemove",
      "GRename",
      "Glgrep",
      "Gedit"
    },
    ft = {"fugitive"},
    keys = {
      { "<leader>gs", "<cmd>Git<cr>", desc = "Git Status" },
      { "<leader>gd", "<cmd>Gdiffsplit<cr>", desc = "Git Diff Split" },
      { "<leader>gl", "<cmd>Git log --oneline<cr>", desc = "Git Log" },
      { "<leader>gp", "<cmd>Git push<cr>", desc = "Git Push" },
      { "<leader>gP", "<cmd>Git pull<cr>", desc = "Git Pull" },
      { "<leader>gb", "<cmd>Git branch<cr>", desc = "Git Branch" },
      { "<leader>gco", "<cmd>Git checkout<cr>", desc = "Git Checkout" },
      { "<leader>gm", "<cmd>Git merge<cr>", desc = "Git Merge" },
      { "<leader>gr", "<cmd>Git rebase<cr>", desc = "Git Rebase" },
    },
  },

  -- GitHub integration
  {
    "tpope/vim-rhubarb",
    dependencies = "tpope/vim-fugitive",
    event = "LazyFile",
  },

  -- Git conflict resolution
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    config = function()
      require("git-conflict").setup({
        default_mappings = {
          ours = 'co',
          theirs = 'ct',
          none = 'c0',
          both = 'cb',
          next = 'cn',
          prev = 'cp',
        },
        default_commands = true,
        disable_diagnostics = false,
        list_opener = 'copen',
        highlights = {
          incoming = 'DiffAdd',
          current = 'DiffText',
        }
      })
    end,
    keys = {
      { "<leader>gcq", "<cmd>GitConflictChooseOurs<cr>", desc = "Choose Ours" },
      { "<leader>gce", "<cmd>GitConflictChooseTheirs<cr>", desc = "Choose Theirs" },
      { "<leader>gcb", "<cmd>GitConflictChooseBoth<cr>", desc = "Choose Both" },
      { "<leader>gc0", "<cmd>GitConflictChooseNone<cr>", desc = "Choose None" },
      { "<leader>gcn", "<cmd>GitConflictNextConflict<cr>", desc = "Next Conflict" },
      { "<leader>gcp", "<cmd>GitConflictPrevConflict<cr>", desc = "Prev Conflict" },
      { "<leader>gcl", "<cmd>GitConflictListQf<cr>", desc = "List Conflicts" },
    },
  },

  -- Git worktree management
  {
    "ThePrimeagen/git-worktree.nvim",
    dependencies = "nvim-telescope/telescope.nvim",
    config = function()
      require("git-worktree").setup()
      require("telescope").load_extension("git_worktree")
    end,
    keys = {
      { "<leader>gww", "<cmd>lua require('telescope').extensions.git_worktree.git_worktrees()<cr>", desc = "Git Worktrees" },
      { "<leader>gwc", "<cmd>lua require('telescope').extensions.git_worktree.create_git_worktree()<cr>", desc = "Create Git Worktree" },
    },
  },

  -- Diffview for better diff visualization
  {
    "sindrets/diffview.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
      "DiffviewRefresh",
      "DiffviewFileHistory"
    },
    config = function()
      require("diffview").setup({
        diff_binaries = false,
        enhanced_diff_hl = false,
        git_cmd = { "git" },
        use_icons = true,
        show_help_hints = true,
        watch_index = true,
        icons = {
          folder_closed = "",
          folder_open = "",
        },
        signs = {
          fold_closed = "",
          fold_open = "",
          done = "✓",
        },
        view = {
          default = {
            layout = "diff2_horizontal",
            winbar_info = false,
          },
          merge_tool = {
            layout = "diff3_horizontal",
            disable_diagnostics = true,
            winbar_info = true,
          },
          file_history = {
            layout = "diff2_horizontal",
            winbar_info = false,
          },
        },
        file_panel = {
          listing_style = "tree",
          tree_options = {
            flatten_dirs = true,
            folder_statuses = "only_folded",
          },
          win_config = {
            position = "left",
            width = 35,
            win_opts = {}
          },
        },
        file_history_panel = {
          log_options = {
            git = {
              single_file = {
                diff_merges = "combined",
              },
              multi_file = {
                diff_merges = "first-parent",
              },
            },
          },
          win_config = {
            position = "bottom",
            height = 16,
            win_opts = {}
          },
        },
        commit_log_panel = {
          win_config = {
            win_opts = {},
          }
        },
        default_args = {
          DiffviewOpen = {},
          DiffviewFileHistory = {},
        },
        hooks = {},
        keymaps = {
          disable_defaults = false,
          view = {
            { "n", "<tab>", require("diffview.actions").select_next_entry, { desc = "Open the diff for the next file" } },
            { "n", "<s-tab>", require("diffview.actions").select_prev_entry, { desc = "Open the diff for the previous file" } },
            { "n", "gf", require("diffview.actions").goto_file_edit, { desc = "Open the file in the previous tabpage" } },
            { "n", "<C-w><C-f>", require("diffview.actions").goto_file_split, { desc = "Open the file in a new split" } },
            { "n", "<C-w>gf", require("diffview.actions").goto_file_tab, { desc = "Open the file in a new tabpage" } },
            { "n", "<leader>e", require("diffview.actions").focus_files, { desc = "Bring focus to the file panel" } },
            { "n", "<leader>b", require("diffview.actions").toggle_files, { desc = "Toggle the file panel." } },
            { "n", "g<C-x>", require("diffview.actions").cycle_layout, { desc = "Cycle through available layouts." } },
            { "n", "[x", require("diffview.actions").prev_conflict, { desc = "In the merge-tool: jump to the previous conflict" } },
            { "n", "]x", require("diffview.actions").next_conflict, { desc = "In the merge-tool: jump to the next conflict" } },
            { "n", "<leader>co", require("diffview.actions").conflict_choose("ours"), { desc = "Choose the OURS version of a conflict" } },
            { "n", "<leader>ct", require("diffview.actions").conflict_choose("theirs"), { desc = "Choose the THEIRS version of a conflict" } },
            { "n", "<leader>cb", require("diffview.actions").conflict_choose("base"), { desc = "Choose the BASE version of a conflict" } },
            { "n", "<leader>ca", require("diffview.actions").conflict_choose("all"), { desc = "Choose all the versions of a conflict" } },
            { "n", "dx", require("diffview.actions").conflict_choose("none"), { desc = "Delete the conflict region" } },
            { "n", "<leader>cO", require("diffview.actions").conflict_choose_all("ours"), { desc = "Choose the OURS version of a conflict for the whole file" } },
            { "n", "<leader>cT", require("diffview.actions").conflict_choose_all("theirs"), { desc = "Choose the THEIRS version of a conflict for the whole file" } },
            { "n", "<leader>cB", require("diffview.actions").conflict_choose_all("base"), { desc = "Choose the BASE version of a conflict for the whole file" } },
            { "n", "<leader>cA", require("diffview.actions").conflict_choose_all("all"), { desc = "Choose all the versions of a conflict for the whole file" } },
            { "n", "dX", require("diffview.actions").conflict_choose_all("none"), { desc = "Delete the conflict region for the whole file" } },
          },
          diff1 = {
            { "n", "g?", require("diffview.actions").help({ "view", "diff1" }), { desc = "Open the help panel" } },
          },
          diff2 = {
            { "n", "g?", require("diffview.actions").help({ "view", "diff2" }), { desc = "Open the help panel" } },
          },
          diff3 = {
            { "n", "g?", require("diffview.actions").help({ "view", "diff3" }), { desc = "Open the help panel" } },
          },
          diff4 = {
            { "n", "g?", require("diffview.actions").help({ "view", "diff4" }), { desc = "Open the help panel" } },
          },
          file_panel = {
            { "n", "j", require("diffview.actions").next_entry, { desc = "Bring the cursor to the next file entry" } },
            { "n", "<down>", require("diffview.actions").next_entry, { desc = "Bring the cursor to the next file entry" } },
            { "n", "k", require("diffview.actions").prev_entry, { desc = "Bring the cursor to the previous file entry" } },
            { "n", "<up>", require("diffview.actions").prev_entry, { desc = "Bring the cursor to the previous file entry" } },
            { "n", "<cr>", require("diffview.actions").select_entry, { desc = "Open the diff for the selected entry" } },
            { "n", "o", require("diffview.actions").select_entry, { desc = "Open the diff for the selected entry" } },
            { "n", "l", require("diffview.actions").select_entry, { desc = "Open the diff for the selected entry" } },
            { "n", "<2-LeftMouse>", require("diffview.actions").select_entry, { desc = "Open the diff for the selected entry" } },
            { "n", "-", require("diffview.actions").toggle_stage_entry, { desc = "Stage / unstage the selected entry" } },
            { "n", "S", require("diffview.actions").stage_all, { desc = "Stage all entries" } },
            { "n", "U", require("diffview.actions").unstage_all, { desc = "Unstage all entries" } },
            { "n", "X", require("diffview.actions").restore_entry, { desc = "Restore entry to the state on the left side" } },
            { "n", "L", require("diffview.actions").open_commit_log, { desc = "Open the commit log panel" } },
            { "n", "zo", require("diffview.actions").open_fold, { desc = "Expand fold" } },
            { "n", "h", require("diffview.actions").close_fold, { desc = "Collapse fold" } },
            { "n", "zc", require("diffview.actions").close_fold, { desc = "Collapse fold" } },
            { "n", "za", require("diffview.actions").toggle_fold, { desc = "Toggle fold" } },
            { "n", "zR", require("diffview.actions").open_all_folds, { desc = "Expand all folds" } },
            { "n", "zM", require("diffview.actions").close_all_folds, { desc = "Collapse all folds" } },
            { "n", "<c-b>", require("diffview.actions").scroll_view(-0.25), { desc = "Scroll the view up" } },
            { "n", "<c-f>", require("diffview.actions").scroll_view(0.25), { desc = "Scroll the view down" } },
            { "n", "<tab>", require("diffview.actions").select_next_entry, { desc = "Open the diff for the next file" } },
            { "n", "<s-tab>", require("diffview.actions").select_prev_entry, { desc = "Open the diff for the previous file" } },
            { "n", "gf", require("diffview.actions").goto_file_edit, { desc = "Open the file in the previous tabpage" } },
            { "n", "<C-w><C-f>", require("diffview.actions").goto_file_split, { desc = "Open the file in a new split" } },
            { "n", "<C-w>gf", require("diffview.actions").goto_file_tab, { desc = "Open the file in a new tabpage" } },
            { "n", "i", require("diffview.actions").listing_style, { desc = "Toggle between 'list' and 'tree' views" } },
            { "n", "f", require("diffview.actions").toggle_flatten_dirs, { desc = "Flatten empty subdirectories in tree listing style" } },
            { "n", "R", require("diffview.actions").refresh_files, { desc = "Update stats and entries in the file list" } },
            { "n", "<leader>e", require("diffview.actions").focus_files, { desc = "Bring focus to the file panel" } },
            { "n", "<leader>b", require("diffview.actions").toggle_files, { desc = "Toggle the file panel" } },
            { "n", "g<C-x>", require("diffview.actions").cycle_layout, { desc = "Cycle through available layouts" } },
            { "n", "[x", require("diffview.actions").prev_conflict, { desc = "Go to the previous conflict" } },
            { "n", "]x", require("diffview.actions").next_conflict, { desc = "Go to the next conflict" } },
            { "n", "g?", require("diffview.actions").help("file_panel"), { desc = "Open the help panel" } },
            { "n", "<leader>cO", require("diffview.actions").conflict_choose_all("ours"), { desc = "Choose the OURS version of a conflict for the whole file" } },
            { "n", "<leader>cT", require("diffview.actions").conflict_choose_all("theirs"), { desc = "Choose the THEIRS version of a conflict for the whole file" } },
            { "n", "<leader>cB", require("diffview.actions").conflict_choose_all("base"), { desc = "Choose the BASE version of a conflict for the whole file" } },
            { "n", "<leader>cA", require("diffview.actions").conflict_choose_all("all"), { desc = "Choose all the versions of a conflict for the whole file" } },
            { "n", "dX", require("diffview.actions").conflict_choose_all("none"), { desc = "Delete the conflict region for the whole file" } },
          },
          file_history_panel = {
            { "n", "g!", require("diffview.actions").options, { desc = "Open the option panel" } },
            { "n", "<C-A-d>", require("diffview.actions").open_in_diffview, { desc = "Open the entry under the cursor in a diffview" } },
            { "n", "y", require("diffview.actions").copy_hash, { desc = "Copy the commit hash of the entry under the cursor" } },
            { "n", "L", require("diffview.actions").open_commit_log, { desc = "Show commit details" } },
            { "n", "zR", require("diffview.actions").open_all_folds, { desc = "Expand all folds" } },
            { "n", "zM", require("diffview.actions").close_all_folds, { desc = "Collapse all folds" } },
            { "n", "j", require("diffview.actions").next_entry, { desc = "Bring the cursor to the next file entry" } },
            { "n", "<down>", require("diffview.actions").next_entry, { desc = "Bring the cursor to the next file entry" } },
            { "n", "k", require("diffview.actions").prev_entry, { desc = "Bring the cursor to the previous file entry" } },
            { "n", "<up>", require("diffview.actions").prev_entry, { desc = "Bring the cursor to the previous file entry" } },
            { "n", "<cr>", require("diffview.actions").select_entry, { desc = "Open the diff for the selected entry" } },
            { "n", "o", require("diffview.actions").select_entry, { desc = "Open the diff for the selected entry" } },
            { "n", "<2-LeftMouse>", require("diffview.actions").select_entry, { desc = "Open the diff for the selected entry" } },
            { "n", "<c-b>", require("diffview.actions").scroll_view(-0.25), { desc = "Scroll the view up" } },
            { "n", "<c-f>", require("diffview.actions").scroll_view(0.25), { desc = "Scroll the view down" } },
            { "n", "<tab>", require("diffview.actions").select_next_entry, { desc = "Open the diff for the next file" } },
            { "n", "<s-tab>", require("diffview.actions").select_prev_entry, { desc = "Open the diff for the previous file" } },
            { "n", "gf", require("diffview.actions").goto_file_edit, { desc = "Open the file in the previous tabpage" } },
            { "n", "<C-w><C-f>", require("diffview.actions").goto_file_split, { desc = "Open the file in a new split" } },
            { "n", "<C-w>gf", require("diffview.actions").goto_file_tab, { desc = "Open the file in a new tabpage" } },
            { "n", "<leader>e", require("diffview.actions").focus_files, { desc = "Bring focus to the file panel" } },
            { "n", "<leader>b", require("diffview.actions").toggle_files, { desc = "Toggle the file panel" } },
            { "n", "g<C-x>", require("diffview.actions").cycle_layout, { desc = "Cycle through available layouts" } },
            { "n", "g?", require("diffview.actions").help("file_history_panel"), { desc = "Open the help panel" } },
          },
          option_panel = {
            { "n", "<tab>", require("diffview.actions").select_entry, { desc = "Change the current option" } },
            { "n", "q", require("diffview.actions").close, { desc = "Close the diffview" } },
            { "n", "<esc>", require("diffview.actions").close, { desc = "Close the diffview" } },
            { "n", "g?", require("diffview.actions").help("option_panel"), { desc = "Open the help panel" } },
          },
          help_panel = {
            { "n", "q", require("diffview.actions").close, { desc = "Close help menu" } },
            { "n", "<esc>", require("diffview.actions").close, { desc = "Close help menu" } },
          },
        },
      })
    end,
    keys = {
      { "<leader>gdo", "<cmd>DiffviewOpen<cr>", desc = "DiffView Open" },
      { "<leader>gdc", "<cmd>DiffviewClose<cr>", desc = "DiffView Close" },
      { "<leader>gdh", "<cmd>DiffviewFileHistory<cr>", desc = "DiffView File History" },
      { "<leader>gdH", "<cmd>DiffviewFileHistory %<cr>", desc = "DiffView Current File History" },
      { "<leader>gdt", "<cmd>DiffviewToggleFiles<cr>", desc = "DiffView Toggle Files" },
      { "<leader>gdf", "<cmd>DiffviewFocusFiles<cr>", desc = "DiffView Focus Files" },
      { "<leader>gdr", "<cmd>DiffviewRefresh<cr>", desc = "DiffView Refresh" },
    },
  },

  -- Neogit - Magit-like Git interface
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("neogit").setup({
        disable_hint = false,
        disable_context_highlighting = false,
        disable_signs = false,
        graph_style = "ascii",
        git_services = {
          ["github.com"] = "https://github.com/${owner}/${repository}/compare/${branch_name}?expand=1",
          ["bitbucket.org"] = "https://bitbucket.org/${owner}/${repository}/pull-requests/new?source=${branch_name}&t=1",
          ["gitlab.com"] = "https://gitlab.com/${owner}/${repository}/merge_requests/new?merge_request[source_branch]=${branch_name}",
        },
        telescope_sorter = function()
          return require("telescope").extensions.fzf.native_fzf_sorter()
        end,
        use_default_keymaps = true,
        auto_refresh = true,
        sort_branches = "-committerdate",
        kind = "tab",
        disable_builtin_notifications = false,
        use_magit_keybindings = false,
        commit_editor = {
          kind = "tab",
        },
        commit_select_view = {
          kind = "tab",
        },
        commit_view = {
          kind = "vsplit",
          verify_commit = vim.fn.executable("gpg") == 1,
        },
        log_view = {
          kind = "tab",
        },
        rebase_editor = {
          kind = "tab",
        },
        reflog_view = {
          kind = "tab",
        },
        merge_editor = {
          kind = "tab",
        },
        tag_editor = {
          kind = "tab",
        },
        preview_buffer = {
          kind = "split",
        },
        popup = {
          kind = "split",
        },
        signs = {
          hunk = { "", "" },
          item = { ">", "v" },
          section = { ">", "v" },
        },
        integrations = {
          telescope = true,
          diffview = true,
        },
        sections = {
          sequencer = {
            folded = false,
            hidden = false,
          },
          untracked = {
            folded = false,
            hidden = false,
          },
          unstaged = {
            folded = false,
            hidden = false,
          },
          staged = {
            folded = false,
            hidden = false,
          },
          stashes = {
            folded = true,
            hidden = false,
          },
          unpulled_upstream = {
            folded = true,
            hidden = false,
          },
          unmerged_upstream = {
            folded = false,
            hidden = false,
          },
          unpulled_pushRemote = {
            folded = true,
            hidden = false,
          },
          unmerged_pushRemote = {
            folded = false,
            hidden = false,
          },
          recent = {
            folded = true,
            hidden = false,
          },
          rebase = {
            folded = true,
            hidden = false,
          },
        },
      })
    end,
    keys = {
      { "<leader>gn", "<cmd>Neogit<cr>", desc = "Neogit" },
      { "<leader>gnc", "<cmd>Neogit commit<cr>", desc = "Neogit Commit" },
      { "<leader>gnd", "<cmd>Neogit diff<cr>", desc = "Neogit Diff" },
      { "<leader>gnl", "<cmd>Neogit log<cr>", desc = "Neogit Log" },
      { "<leader>gnp", "<cmd>Neogit push<cr>", desc = "Neogit Push" },
      { "<leader>gnP", "<cmd>Neogit pull<cr>", desc = "Neogit Pull" },
    },
  },
}