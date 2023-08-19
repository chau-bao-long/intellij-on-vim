local RPC = require("intellij-on-vim.rpc")
local api = vim.api
local M = {}

M.setup = function(opt)
  require("intellij-on-vim.events").setup()
end

M.move_cursor = function(offset)
  local mode = vim.api.nvim_get_mode().mode

  if mode == "i" then
    -- Caret position change event keep triggering when typing.
    -- Don't move cursor in insert mode to avoid this annoying issue.
    return
  end

  local line = vim.fn.byte2line(offset)
  local col = offset - vim.fn.line2byte(line) + 2

  vim.fn.cursor(line, col)
end

-- Sync cursor position from buffer nvim to intelliJ
M.sync_cursor = function()
  local file = vim.fn.expand("%:p")
  local offset = vim.fn.line2byte(vim.fn.line('.')) + vim.fn.col('.') - 2

  RPC.request_sync_cursor(file, offset)
end

return M
