local Channels = require("intellij-on-vim.channels")
local M = {}

function M.notify_buffer_enter(buf_id, buf_path)
  local channel = Channels.get_channel()

  if channel ~= nil then
    vim.rpcnotify(channel.id, "notify_buf_enter", {
      id = buf_id,
      path = buf_path,
    })
  end
end

function M.request_sync_cursor(file, offset)
  local channel = Channels.get_channel()

  if channel ~= nil then
    vim.rpcrequest(channel.id, "request_sync_cursor", {
      file = file,
      offset = offset,
    })
  end
end

return M
