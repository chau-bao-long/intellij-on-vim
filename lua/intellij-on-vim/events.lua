local Channels = require("intellij-on-vim.channels")
local RPC = require('intellij-on-vim.rpc')
local M = {}
local is_vim_focused = true

M.setup = function()
  vim.api.nvim_create_autocmd("BufEnter", {
		callback = function(event)
      if is_vim_focused then
        local buf_id = vim.api.nvim_get_current_buf()
        local buf_path = vim.api.nvim_buf_get_name(0)

        RPC.notify_buffer_enter(buf_id, buf_path)
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
