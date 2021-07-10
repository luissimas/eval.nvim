local M = {}

local defaults = {
  prefix_char = "> ",
  filetype = {
    lua = {
      cmd = "lua -e"
    },
    elixir = {
      cmd = "elixir -e"
    },
    javascript = {
      cmd = "node -e"
    }
  }
}

M.options = {}

function M.setup(options)
  M.options = vim.tbl_deep_extend("force", defaults, options or {})
end

M.setup()

return M
