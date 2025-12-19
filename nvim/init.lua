-- ============================
--  BASIC OPTIONS
-- ============================
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.cursorline = false
vim.opt.wrap = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.mouse = "a"
vim.opt.termguicolors = true
vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- ============================
--  KEYMAPS
-- ============================
local map = vim.keymap.set

-- Netrw explorer on F2
map("n", "<F2>", ":Ex<CR>")

-- VS Code–like Ctrl+F search
vim.keymap.set("n", "<C-f>", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { noremap = true })
vim.keymap.set("n", "<C-p>", "<cmd>Telescope commands<CR>")


-- Compile & run C
map("n", "<F5>", ":w<CR>:!gcc % -o %:r.exe && %:r.exe<CR>")

-- Compile & run C++
map("n", "<F6>", ":w<CR>:!g++ % -o %:r.exe && %:r.exe<CR>")

map("n", "<F7>", ":w<CR>:!rustc % -o %:r.exe && %:r.exe<CR>")

-- ============================
--  LOAD PLUGINS
-- ============================
require("plugins")

-- ============================
--  COLORSCHEME
-- ============================
pcall(vim.cmd.colorscheme, "catppuccin")

-- ============================
--  LUALINE
-- ============================
require("lualine").setup()

-- ============================
--  NVIM-TREE
-- ============================
require("nvim-tree").setup()
map("n", "<C-b>", ":NvimTreeToggle<CR>")

-- ============================
--  TREESITTER
-- ============================
require("nvim-treesitter.configs").setup({
    highlight = { enable = true },
    indent = { enable = true }
})

-- ============================
--  LSP (clangd)
--  New Neovim 0.11 API
-- ============================
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "c", "cpp", "objc", "objcpp" },
    callback = function(args)
        vim.lsp.start({
            name = "clangd",
            cmd = { "clangd" },
            root_dir = vim.fs.root(args.buf, { ".git", "compile_commands.json", "compile_flags.txt" })
                or vim.fn.getcwd(),
        })
    end,
})

-- rust 
vim.api.nvim_create_autocmd("FileType", {
    pattern = "rust",
    callback = function(args)
        vim.lsp.start({
            name = "rust-analyzer",
            cmd = { "rust-analyzer" },
            root_dir = vim.fs.root(args.buf, { "Cargo.toml", ".git" })
                or vim.fn.getcwd(),
        })
    end,
})




-- ============================
--  AUTOCOMPLETION
-- ============================
local cmp = require("cmp")
cmp.setup({
    mapping = cmp.mapping.preset.insert({
        ["<CR>"] = cmp.mapping.confirm({ select = true })
    }),
    sources = {
        { name = "nvim_lsp" },
        { name = "buffer" },
        { name = "path" }
    }
})
