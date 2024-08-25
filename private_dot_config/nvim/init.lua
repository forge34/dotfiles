-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
vim.opt.statuscolumn = "%l %r%s"
vim.g.sass_variables_file = "_variables.scss"
require("bluloco").setup({
  transparent = true,
  italics = true,
})
vim.cmd("colorscheme bluloco")

-- nvim-cmp config
local cmp = require("cmp")
local config = cmp.get_config()
config.window = {
  completion = cmp.config.window.bordered(),
  documentation = cmp.config.window.bordered(),
}

table.insert(config.sources, { name = "scss" })
table.insert(config.sources, { name = "lazydev" })

cmp.setup(config)

require("lspconfig").somesass_ls.setup({})
-- luasnip config
require("luasnip.loaders.from_snipmate").load()
require("luasnip.loaders.from_vscode").lazy_load()

require("lspconfig").prismals.setup({})
-- List snippets
local list_snips = function()
  local ft_list = require("luasnip").available()[vim.o.filetype]
  local ft_snips = {}
  for _, item in pairs(ft_list) do
    ft_snips[item.trigger] = item.name
  end
  print(vim.inspect(ft_snips))
end

vim.api.nvim_create_user_command("SnipList", list_snips, {})

-- incline nvim
local helpers = require("incline.helpers")
local devicons = require("nvim-web-devicons")
require("incline").setup({
  window = {
    padding = 0,
    margin = { horizontal = 0 },
  },
  render = function(props)
    local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
    if filename == "" then
      filename = "[No Name]"
    end
    local ft_icon, ft_color = devicons.get_icon_color(filename)
    local modified = vim.bo[props.buf].modified
    return {
      ft_icon and { " ", ft_icon, " ", guibg = ft_color, guifg = helpers.contrast_color(ft_color) } or "",
      " ",
      { filename, gui = modified and "bold,italic" or "bold" },
      " ",
      guibg = "#44406e",
    }
  end,
})
