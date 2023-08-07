local Channels = require("intellij-on-vim.channels")
local M = {}

local function notify_buffer_enter()
  local buf_id = vim.api.nvim_get_current_buf()
  local buf_path = vim.api.nvim_buf_get_name(0)
  local channel = Channels.get_channel()

  if channel ~= nil then
    vim.rpcnotify(channel.id, "notify_buf_enter", {
      id = buf_id,
      path = buf_path,
    })
  end
end

M.setup = function()
  vim.api.nvim_create_autocmd("BufEnter", {
		callback = function(event)
      notify_buffer_enter()
    end,
		group = vim.api.nvim_create_augroup("lsp_document_format", {clear = true})
	})
end


return M
