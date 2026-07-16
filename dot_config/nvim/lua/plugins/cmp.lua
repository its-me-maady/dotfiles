return {
    -- Snippet Engine
    {
        "L3MON4D3/LuaSnip",
        version = "2.*",
        build = "make install_jsregexp", -- optional but recommended
        dependencies = {
            "rafamadriz/friendly-snippets",
        },
        config = function()
            require("luasnip").setup({})
            require("luasnip.loaders.from_vscode").lazy_load()
        end,
    },

    -- Autocomplete Engine
    {
        "saghen/blink.cmp",
        version = "1.*",
        build = "cargo build --release",
        dependencies = {
            "L3MON4D3/LuaSnip",
            "saghen/blink.lib",
        },
        opts = {
            keymap = {
                preset = "enter",
                ["<Tab>"] = { "snippet_forward", "fallback" },
                ["<S-Tab>"] = { "snippet_backward", "fallback" },
            },

            appearance = {
                nerd_font_variant = "mono",
            },

            completion = {
                documentation = {
                    auto_show = true,
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
