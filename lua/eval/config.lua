local M = {}

local defaults = {
  prefix_char = "> ",
  filetype = {
    lua = {
      cmd = "lua"
    },
    elixir = {
      cmd = "elixir -e"
    },
    javascript = {
      cmd = "node"
    }
  }
}

M.options = {}

function M.setup(options)
  M.options = vim.tbl_deep_extend("force", defaults, options or {})
end

M.setup()

return M
