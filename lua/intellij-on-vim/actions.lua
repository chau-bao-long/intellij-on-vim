local M = {}
local RPC = require('intellij-on-vim.rpc')

M.sync_cursor = function()
  local file = vim.fn.expand("%:p")
  local offset = vim.fn.line2byte(vim.fn.line('.')) + vim.fn.col('.') - 2

  RPC.request_sync_cursor(file, offset)
end

M.sync_buffer = function()
  local buf_id = vim.api.nvim_get_current_buf()
  local buf_path = vim.api.nvim_buf_get_name(0)

  RPC.notify_buffer_enter(buf_id, buf_path)
end

M.refresh_buffer = function()
  local buf_id = vim.api.nvim_get_current_buf()
  local buf_path = vim.api.nvim_buf_get_name(0)
  local empty_file = "/tmp/empty"

  os.execute("touch " .. empty_file)

  RPC.notify_buffer_enter(buf_id, empty_file)
  RPC.notify_buffer_enter(buf_id, buf_path)

  vim.fn.timer_start(300, function ()
    M.sync_cursor()
  end)
end

return M
