local M = {}
local eval_ns = vim.api.nvim_create_namespace("eval_ns")

function M.get_visual_selection()
  local _, begln, _, _ = unpack(vim.fn.getpos("'<'"))
  local _, endln, _, _ = unpack(vim.fn.getpos("'>'"))

  -- 1-based index line and column numbers
  return {begln, endln}
end

function M.set_virtual_text(data, pos)
  vim.api.nvim_buf_set_virtual_text(0, eval_ns, pos, {{"> " .. data:gsub("\n", ""), "TSComment"}}, {})
end

function M.clear_virtual_text()
  vim.api.nvim_buf_clear_namespace(0, eval_ns, 0, -1)
end

function M.get_lines(begln, endln)
  local lines = vim.api.nvim_buf_get_lines(0, begln - 1, endln, 0)

  return table.concat(lines, "\n")
end

return M
