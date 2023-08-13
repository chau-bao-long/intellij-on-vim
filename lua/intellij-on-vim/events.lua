local Channels = require("intellij-on-vim.channels")
local M = {}
local is_vim_focused = true

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
      if is_vim_focused then
        notify_buffer_enter()
      end
    end,
		group = vim.api.nvim_create_augroup("intellij_on_vim_buf_enter", {clear = true})
	})

  vim.api.nvim_create_autocmd("FocusGained", {
    callback = function(event)
      is_vim_focused =  true
    end,
    group = vim.api.nvim_create_augroup("intellij_on_vim_focus_gained", {clear = true})
  })

  vim.api.nvim_create_autocmd("FocusLost", {
    callback = function(event)
      is_vim_focused =  false
    end,
    group = vim.api.nvim_create_augroup("intellij_on_vim_focus_lost", {clear = true})
  })
end


return M
