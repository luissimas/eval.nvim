local utils = require("eval.utils")
local run = require("eval.run")
local config = require("eval.config")

local M = {}

function M.eval(begln, endln)
  utils.clear_virtual_text()

  local code = utils.get_lines(begln, endln)

  run(code, {begln, endln})
end

function M.setup(opts)
  config.setup(opts)
end

function M.reload()
  package.loaded["eval"] = nil
  package.loaded["eval.utils"] = nil
  package.loaded["eval.config"] = nil
  package.loaded["eval.run"] = nil
end

return M
