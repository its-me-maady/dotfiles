return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",  -- Automatically install parsers on first run
    lazy = false,         -- Load immediately (treesitter is essential)
    opts = {
        -- Auto-install missing parsers when opening a file
        auto_install = true,
        -- Install parsers synchronously (for better error handling)
        sync_install = false,  -- `false` avoids freezing Neovim on install
        -- Enable highlighting
        highlight = {
            enable = true,
            -- Optional: Disable for large files (performance optimization)
            disable = function(lang, buf)
                local max_filesize = 100 * 1024 -- 100 KB
                local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                if ok and stats and stats.size > max_filesize then
                    return true
                end
            end,
            -- Additional optimizations (optional)
            additional_vim_regex_highlighting = false,  -- Faster parsing
        },
        -- Enable indentation (better than default vim indent)
        indent = {
            enable = true,
        },
        -- Enable incremental selection (press `v` repeatedly to expand selection)
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "gnn",
                node_incremental = "grn",
                scope_incremental = "grc",
                node_decremental = "grm",
            },
        },
        -- Enable folds (alternative to your foldexpr setup)
        fold = {
            enable = true,
            disable = { "markdown" },  -- Disable for problematic filetypes
        },
        -- Ensure these parsers are always installed
        ensure_installed = {
            "lua", "python", "bash", "markdown", "json", "yaml", "html", "css",
        },
    },
    config = function(_, opts)
        require("nvim-treesitter.configs").setup(opts)

        -- Optional: Custom folding settings (alternative to foldexpr)
        vim.opt.foldmethod = "expr"
        vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
        vim.opt.foldlevelstart = 99  -- Start with all folds open
        vim.opt.foldenable = false   -- Disable folding at startup
    end
}
