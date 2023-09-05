local RPC = require("intellij-on-vim.rpc")
local events = require("intellij-on-vim.events")
local api = vim.api
local M = {}

M.setup = function(opt)
  require("intellij-on-vim.events").setup()
end

M.move_cursor = function(offset)
  if events.is_vim_focused then
    -- Don't move cursor when vim is focused to prevent bounce back event from intellij
    return
  end

  local line = vim.fn.byte2line(offset)
  local col = offset - vim.fn.line2byte(line) + 2

  vim.fn.cursor(line, col)
end

return M
