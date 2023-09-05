local M = {}
local Channels = require("intellij-on-vim.channels")
local Actions = require('intellij-on-vim.actions')
local buf_enter_timer = nil
local cursor_move_timer = nil

M.is_vim_focused = true

M.setup = function()
  vim.api.nvim_create_autocmd("BufEnter", {
		callback = function(event)
      if M.is_vim_focused then
        if buf_enter_timer ~= nil then
          vim.fn.timer_stop(buf_enter_timer)
        end
        buf_enter_timer = vim.fn.timer_start(200, function ()
          Actions.sync_buffer()

          buf_enter_timer = nil
        end)
      end
    end,
		group = vim.api.nvim_create_augroup("intellij_on_vim_buf_enter", {clear = true})
	})

  vim.api.nvim_create_autocmd("CursorMoved", {
    callback = function()
      if M.is_vim_focused then
        if cursor_move_timer ~= nil then
          vim.fn.timer_stop(cursor_move_timer)
        end
        cursor_move_timer = vim.fn.timer_start(200, function ()
          Actions.sync_cursor()

          cursor_move_timer = nil
        end)
      end
    end
  })

  vim.api.nvim_create_autocmd("FocusGained", {
    callback = function(event)
      M.is_vim_focused =  true
    end,
    group = vim.api.nvim_create_augroup("intellij_on_vim_focus_gained", {clear = true})
  })

  vim.api.nvim_create_autocmd("FocusLost", {
    callback = function(event)
      M.is_vim_focused =  false
    end,
    group = vim.api.nvim_create_augroup("intellij_on_vim_focus_lost", {clear = true})
  })

  vim.api.nvim_create_autocmd("FocusLost", {
    callback = function(event)
      vim.cmd("w")
      vim.fn.timer_start(300, function ()
        Actions.sync_cursor()
      end)
    end,
    group = vim.api.nvim_create_augroup("intellij_on_vim_focus_lost_kotlin_file", {clear = true}),
    pattern = {"*.kt","*.kts"}
  })
end


return M
