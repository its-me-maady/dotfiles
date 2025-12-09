return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = {
        'nvim-lua/plenary.nvim',
        {
            'nvim-telescope/telescope-fzf-native.nvim',
            build = 'make',
            cond = function()
                return vim.fn.executable('make') == 1
            end,
        },
        { 'nvim-telescope/telescope-ui-select.nvim' },
        {
            'nvim-tree/nvim-web-devicons',
            enabled = vim.g.have_nerd_font,
        },
    },

    config = function()
        local telescope = require('telescope')
        local builtin = require('telescope.builtin')

        -- Configure pickers with ivy theme
        local pickers = {
            'find_files',
            'live_grep',
            'buffers',
            'help_tags',
            'grep_string',
            'oldfiles',
            'lsp_references',
            'lsp_definitions',
            'diagnostics',
        }

        local picker_configs = {}
        for _, picker in ipairs(pickers) do
            picker_configs[picker] = { theme = 'ivy' }
        end

        telescope.setup({
            pickers = picker_configs,
            extensions = {
                ['ui-select'] = {
                    require('telescope.themes').get_dropdown(),
                },
            },
        })

        -- Load extensions
        telescope.load_extension('fzf')
        telescope.load_extension('ui-select')

        -- Helper functions
        local function search_dotfiles()
            builtin.find_files({
                prompt_title = '< Dotfiles >',
                cwd = vim.fn.expand('/'),
                hidden = true,
            })
        end

        local function find_in_open_files()
            builtin.live_grep({
                grep_open_files = true,
                prompt_title = 'Live Grep in Open Files',
            })
        end

        local function find_neovim_files()
            builtin.find_files({ cwd = vim.fn.stdpath('config') })
        end

        local function find_files_from_current_dir()
            vim.cmd('lcd %:p:h')
            builtin.find_files()
        end

        -- Key mappings
        local keymaps = {
            { 'n', '<leader>fk', builtin.keymaps,                   { desc = '[F]ind [K]eymaps' } },
            { 'n', '<leader>fd', builtin.diagnostics,               { desc = '[F]ind [D]iagnostics' } },
            { 'n', '<leader>fw', builtin.grep_string,               { desc = '[F]ind current [W]ord' } },
            { 'n', '<leader>fs', builtin.builtin,                   { desc = '[F]ind [S]elect Telescope' } },
            { 'n', '<C-v>',      builtin.registers,                 { desc = 'Find Registers' } },
            { 'n', '<leader>/',  builtin.current_buffer_fuzzy_find, { desc = '[/] Fuzzily find in current buffer' } },
            { 'n', '<leader>ff', builtin.find_files,                { desc = '[F]ind [F]iles' } },
            { 'n', '<leader>fc', find_files_from_current_dir,       { desc = '[F]ind files from [C]urrent directory' } },
            { 'n', '<leader>fg', builtin.live_grep,                 { desc = '[F]ind by [G]rep' } },
            { 'n', '<leader>fb', builtin.buffers,                   { desc = '[F]ind [B]uffers' } },
            { 'n', '<leader>fh', builtin.help_tags,                 { desc = '[F]ind [H]elp' } },
            { 'n', '<leader>fr', builtin.oldfiles,                  { desc = '[F]ind [R]ecent files' } },
            { 'n', '<leader>f/', find_in_open_files,                { desc = '[F]ind [/] in Open Files' } },
            { 'n', '<leader>fn', find_neovim_files,                 { desc = '[F]ind [N]eovim files' } },
            { 'n', '<leader>f.', search_dotfiles,                   { desc = '[F]ind Dotfiles' } },
        }

        for _, map in ipairs(keymaps) do
            vim.keymap.set(map[1], map[2], map[3], map[4])
        end
    end,
}
