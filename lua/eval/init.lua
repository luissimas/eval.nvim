local M = {}

local results = {}
local lines = {}
local eval_ns = vim.api.nvim_create_namespace("eval_ns")

local function get_visual_selection()
  local _, begln, _, _ = unpack(vim.fn.getpos("'<'"))
  local _, endln, _, _ = unpack(vim.fn.getpos("'>'"))

  -- 1-based index line and column numbers
  return {begln, endln}
end

local function get_lines(begln, endln)
  local lines = vim.api.nvim_buf_get_lines(0, begln - 1, endln, 0)

  return table.concat(lines, "\n")
end

local function onread(error, data)
  if error then
    print("ERROR: ", error)
  end
  if data then
    display_result(data)
  end
end

function display_result(data)
  set_virtual_text(data)
end

local function lua_eval(input)
  -- Creating the stream handles
  local stdout = vim.loop.new_pipe(false)
  local stderr = vim.loop.new_pipe(false)

  -- Spawning lua process and executing the input
  Handle =
    vim.loop.spawn(
    "lua",
    {
      args = {"-e " .. input},
      stdio = {nil, stdout, stderr}
    },
    function()
      stdout:read_stop()
      stderr:read_stop()
      stdout:close()
      stderr:close()
      Handle:close()
    end
  )

  vim.loop.read_start(stderr, vim.schedule_wrap(onread))
  vim.loop.read_start(stdout, vim.schedule_wrap(onread))
end

function set_virtual_text(data)
  vim.api.nvim_buf_set_virtual_text(0, eval_ns, lines[2] - 1, {{"> " .. data:gsub("\n", ""), "TSComment"}}, {})
end

function M.eval(begln, endln)
  lines = {begln, endln}

  vim.api.nvim_buf_clear_namespace(0, eval_ns, 0, -1)

  local code = get_lines(lines[1], lines[2])

  lua_eval(code)
end

function M.reload()
  package.loaded["eval"] = nil
end

return M
