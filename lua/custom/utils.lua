return {}

-- local buffer_number = -1
--
-- local function log(_, data)
--   if data then
--     pcall(vim.api.nvim_buf_set_lines, buffer_number, -1, -1, true, data)
--   end
-- end
--
-- local function open_buffer()
--   if buffer_number == -1 then
--     vim.api.nvim_command 'botright vnew'
--     buffer_number = vim.api.nvim_get_current_buf()
--   end
-- end
--
-- open_buffer()
--
-- log(nil, { string.format('%s %s', 'edit', j.path) })
