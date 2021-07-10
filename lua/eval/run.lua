local utils = require("eval.utils")
local config = require("eval.config").options

local lines = {}

local function display_result(data)
  utils.set_virtual_text(data, lines[2] - 1)
end

local function onread(error, data)
  if error then
    print("ERROR: ", error)
  end
  if data then
    display_result(data)
  end
end

local function run(input, lines_)
  local filetype = vim.bo.filetype

  lines = lines_
  -- Creating the stream handles
  local stdin = vim.loop.new_pipe(false)
  local stdout = vim.loop.new_pipe(false)
  local stderr = vim.loop.new_pipe(false)

  if not config.filetype[filetype] then
    print("No setup for filetype " .. filetype .. ".")
    return
  end

  local cmd = config.filetype[filetype].cmd

  handle, pid =
    vim.loop.spawn(
    cmd,
    {
      stdio = {stdin, stdout, stderr}
    },
    function(code, signal)
      -- closing streams on exit
      stderr:read_stop()
      stdout:read_stop()
      stderr:close()
      stdout:close()
      stdin:close()
      handle:close()
    end
  )

  -- reading output from streams
  vim.loop.read_start(stderr, vim.schedule_wrap(onread))
  vim.loop.read_start(stdout, vim.schedule_wrap(onread))

  -- writing the input
  vim.loop.write(stdin, input)

  stdin:shutdown()
end

return run
