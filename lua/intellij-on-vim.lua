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

return M
