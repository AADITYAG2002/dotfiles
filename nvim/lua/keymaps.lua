local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.keymap.set

--Remap space as leader key
-- keymap("", "<Space>", "<Nop>", opts)

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
------------

-- Better window navigation
keymap('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
keymap('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
keymap('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
keymap('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- map <C-n> to nvim tree toggle
vim.keymap.set('n', '<C-n>', '<cmd>NvimTreeToggle<CR>', { desc = 'Toggle Nvim Tree' })

-- map <C-t> to toggle term
vim.keymap.set('n', '<C-t>', '<cmd>ToggleTerm<CR>', { desc = 'Toggle Terminal' })

-- Resize with arrows
keymap("n", "<C-Up>", ":resize +2<CR>", opts)
keymap("n", "<C-Down>", ":resize -2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Comment
keymap("n", "<leader>/", function()
    require("Comment.api").toggle.linewise.current()
end, { desc = "Comment Toggle" })
keymap(
  "v",
  "<leader>/",
  "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
  { desc = "Comment Toggle" }
)

-- bufferline
keymap("n","<leader>bp", "<Cmd>BufferLineTogglePin<CR>", {desc = "Toggle Pin"})
keymap("n","<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", {desc = "Delete Non-Pinned Buffers" })
keymap("n","<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", {desc = "Delete Other Buffers" })
keymap("n","<leader>br", "<Cmd>BufferLineCloseRight<CR>", {desc = "Delete Buffers to the Right" })
keymap("n","<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", {desc = "Delete Buffers to the Left" })
keymap("n","<S-h>", "<cmd>BufferLineCyclePrev<cr>", {desc = "Prev Buffer" })
keymap("n","<S-l>", "<cmd>BufferLineCycleNext<cr>", {desc = "Next Buffer"})


-- Insert --
------------

-- Visual --
------------


-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)
keymap("v", "p", '"_dP', opts)


-- Terminal --
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
