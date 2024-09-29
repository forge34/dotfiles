-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
--#regions
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Function for optional description
local function desc(des)
  local nopts = opts
  nopts.desc = des
  return nopts
end

-- Function to get git root
local function get_git_root()
  local dot_git_path = vim.fn.finddir(".git", ".;")
  return vim.fn.fnamemodify(dot_git_path, ":h")
end

-- Lazygit shortcut
map("n", ";g", function()
  LazyVim.lazygit({ cwd = LazyVim.root.git() })
end, { desc = "Lazygit (Root Dir)" })

-- Select all
map("n", "<C-a>", "gg<S-v>G", desc("Select all"))

-- Split windows
map("n", "sh", ":split<CR>", desc("Split window horizontally"))
map("n", "sv", ":vsplit<CR>", desc("Split window veritcally"))

-- Delete window
map("n", "sd", "<C-w>c", desc("Delete window"))

-- move lines
map("n", "<A-UP>", ":m -2<CR>", desc("move line up"))
map("n", "<A-DOWN>", ":m +1<CR>", desc("move line down"))

-- Floatterm
map("n", "<F7>", string.format(":FloatermNew %s <CR>", get_git_root()), desc("Open Floatterm"))
map("t", "<F7>", "<C-\\><C-n>:FloatermNew<CR>", desc("Open Floatterm"))
map("n", "<F7>", ":FloatermPrev<CR>", desc("previous floatterm"))
map("t", "<F8>", "<C-\\><C-n>:FloatermPrev<CR>", desc("previous floatterm"))
map("n", "<F9>", ":FloatermNext<CR>", desc("next floatterm"))
map("n", "<F9>", "<C-\\><C-n>:FloatermNext<CR>", desc("next floatterm"))
map("n", "<F12>", ":FloatermToggle<CR>", desc("toggle floatterm"))
map("t", "<F12>", "<C-\\><C-n>:FloatermToggle<CR>", desc("Toggle floatterm"))
map("n", "<F6>", ":floatermkill<cr>", desc("kill current floatterm"))
map("t", "<F6>", "<C-\\><C-n>:FloatermKill<CR>", desc("Kill current floatterm"))

-- luasnip
local ls = require("luasnip")

vim.keymap.set({ "i" }, "<C-K>", function()
  ls.expand()
end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-L>", function()
  ls.jump(1)
end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-J>", function()
  ls.jump(-1)
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<C-E>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end, { silent = true })
