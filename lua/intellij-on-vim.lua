local api = vim.api
local M = {}

M.setup = function(opt)
  require("intellij-on-vim.events").setup()
end

return M
