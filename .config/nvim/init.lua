-- Clean up stale ShaDa temp files.
local function clean_stale_shada_temps()
  local pattern = vim.fn.stdpath("state") .. "/shada/main.shada.tmp.*"
  local cutoff = os.time() - 3600
  for _, path in ipairs(vim.fn.glob(pattern, true, true)) do
    if vim.fn.getftime(path) < cutoff then
      pcall(vim.fn.delete, path)
    end
  end
end

clean_stale_shada_temps()

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.keymap.set('x', 'p', 'pgvy')
