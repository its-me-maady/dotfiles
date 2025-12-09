return {
    'mason-org/mason.nvim',
    tag = 'v1.11.0',
    pin = true,
    dependencies = {
        'mason-org/mason-lspconfig.nvim',
        'neovim/nvim-lspconfig',
        'L3MON4D3/LuaSnip',
        'hrsh7th/nvim-cmp',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'saadparwaiz1/cmp_luasnip',
        'rafamadriz/friendly-snippets',
    },

    config = function()
        -- Setup Mason first
        require('mason').setup({
            ui = {
                border = 'rounded',
                icons = {
                    package_installed = '✓',
                    package_pending = '➜',
                    package_uninstalled = '✗',
                },
            },
        })

        -- Setup Mason LSP config
        require('mason-lspconfig').setup({
            automatic_installation = true,
        })

        -- Configure LSP capabilities with nvim-cmp
        local capabilities = require('cmp_nvim_lsp').default_capabilities()
        local lspconfig = require('lspconfig')

        -- Common LSP settings that apply to all servers
        local common_lsp_settings = {
            capabilities = capabilities,
            on_attach = function(client, bufnr)
                -- Set keymaps only for the current buffer
                local map = function(mode, lhs, rhs, desc)
                    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
                end

                -- Navigation
                map('n', 'K', vim.lsp.buf.hover, 'Hover documentation')
                map('n', 'gd', vim.lsp.buf.definition, 'Go to definition')
                map('n', 'gD', vim.lsp.buf.declaration, 'Go to declaration')
                map('n', 'gi', vim.lsp.buf.implementation, 'Go to implementation')
                map('n', 'go', vim.lsp.buf.type_definition, 'Go to type definition')
                map('n', 'gr', vim.lsp.buf.references, 'Find references')

                -- Code actions
                map('n', '<F2>', vim.lsp.buf.rename, 'Rename symbol')
                map('n', '<F4>', vim.lsp.buf.code_action, 'Code actions')
                map('n', 'gs', vim.lsp.buf.signature_help, 'Signature help')

                -- Formatting
                map({ 'n', 'x' }, '<F3>', function()
                    vim.lsp.buf.format({ async = true })
                end, 'Format code')
            end,
        }

        -- Setup LSP servers with common configuration
        require('mason-lspconfig').setup_handlers({
            function(server_name)
                lspconfig[server_name].setup(common_lsp_settings)
            end,
        })

        -- Server-specific configurations
        lspconfig.lua_ls.setup(vim.tbl_deep_extend('force', common_lsp_settings, {
            settings = {
                Lua = {
                    runtime = { version = 'LuaJIT' },
                    diagnostics = { globals = { 'vim' } },
                    workspace = { checkThirdParty = false },
                    telemetry = { enable = false },
                },
            },
        }))

        -- Auto-format on save
        vim.api.nvim_create_autocmd('BufWritePre', {
            callback = function()
                vim.lsp.buf.format({ async = false })
            end,
        })

        -- Setup nvim-cmp
        local cmp = require('cmp')
        local luasnip = require('luasnip')

        -- Load friendly-snippets
        require('luasnip.loaders.from_vscode').lazy_load()

        cmp.setup({
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<CR>'] = cmp.mapping.confirm({ select = true }),
                ['<Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    else
                        fallback()
                    end
                end, { 'i', 's' }),
                ['<S-Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { 'i', 's' }),
                ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                ['<C-d>'] = cmp.mapping.scroll_docs(4),
                ['<C-e>'] = cmp.mapping.abort(),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
                { name = 'path' },
            }, {
                { name = 'buffer', keyword_length = 3 },
            }),
        })

        -- Set up cmp for command line
        cmp.setup.cmdline(':', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = 'path' },
            }, {
                { name = 'cmdline' },
            }),
        })
    end,
}
