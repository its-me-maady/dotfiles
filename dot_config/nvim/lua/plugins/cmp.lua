return {
    -- Snippet Engine
    {
        "L3MON4D3/LuaSnip",
        version = "2.*",
        build = "make install_jsregexp", -- optional but recommended
        config = function()
            require("luasnip").setup({})
        end,
    },

    -- Optional: friendly snippets
    {
        "rafamadriz/friendly-snippets",
        lazy = true,
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
        end,
    },

    -- Autocomplete Engine
    {
        "saghen/blink.cmp",
        version = "1.*",
        dependencies = {
            "L3MON4D3/LuaSnip",
            "saghen/blink.lib",
        },
        opts = {
            keymap = {
                preset = "enter",
            },

            appearance = {
                nerd_font_variant = "mono",
            },

            completion = {
                documentation = {
                    auto_show = false,
                    auto_show_delay_ms = 500,
                },
            },

            sources = {
                default = { "lsp", "path", "snippets" },
            },

            snippets = {
                preset = "luasnip",
            },

            fuzzy = {
                implementation = "lua",
            },

            signature = {
                enabled = true,
            },
        },
    },
}
