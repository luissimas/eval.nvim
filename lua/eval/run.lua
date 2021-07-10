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
  local stdout = vim.loop.new_pipe(false)
  local stderr = vim.loop.new_pipe(false)

  if not config.filetype[filetype] then
    print("No setup for filetype " .. filetype .. ".")
    return
  end

  local fullcmd = vim.split(config.filetype[filetype].cmd, " ")
  local cmd = fullcmd[1]
  local arg = fullcmd[2]

  -- Spawning lua process and executing the input
  Handle =
    vim.loop.spawn(
    cmd,
    {
      args = {arg .. " " .. input},
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

return run
