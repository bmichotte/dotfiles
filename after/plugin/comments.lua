local comment = require("Comment")
comment.setup()

vim.g.skip_ts_context_commentstring_module = true
local ts_context_commentstring = require('ts_context_commentstring')
ts_context_commentstring.setup()
