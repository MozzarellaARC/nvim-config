return {
    "github/copilot.vim",
    config = function()
        -- Basic Copilot configuration
        vim.g.copilot_no_tab_map = true
        
        -- Key mappings for Copilot
        -- Accept suggestion with Ctrl+J instead of Tab
        vim.keymap.set('i', '<C-J>', 'copilot#Accept("\\<CR>")', {
            expr = true,
            replace_keycodes = false,
            silent = true
        })
        
        -- Panel and navigation mappings
        vim.keymap.set('i', '<C-L>', '<Plug>(copilot-accept-word)', { silent = true })
        vim.keymap.set('i', '<C-H>', '<Plug>(copilot-accept-line)', { silent = true })
        vim.keymap.set('i', '<C-]>', '<Plug>(copilot-dismiss)', { silent = true })
        vim.keymap.set('i', '<M-]>', '<Plug>(copilot-next)', { silent = true })
        vim.keymap.set('i', '<M-[>', '<Plug>(copilot-previous)', { silent = true })
        vim.keymap.set('i', '<M-\\>', '<Plug>(copilot-suggest)', { silent = true })
        
        -- Panel system key mappings (modified for manual prompt input)
        vim.keymap.set('n', '<leader>cp', function()
            -- Create a custom prompt-based panel
            vim.cmd('vnew')
            vim.cmd('setlocal buftype=nofile')
            vim.cmd('setlocal bufhidden=wipe')
            vim.cmd('setlocal noswapfile')
            vim.cmd('file copilot-prompt')
            
            -- Add instructions and prompt area
            vim.api.nvim_buf_set_lines(0, 0, -1, false, {
                "=== Copilot Prompt Panel ===",
                "",
                "Instructions:",
                "1. Type your request/prompt below the '---' line",
                "2. Press <leader>cg to generate completions",
                "3. Press q to close this panel",
                "",
                "---",
                ""
            })
            
            -- Move cursor to the prompt area
            vim.api.nvim_win_set_cursor(0, {9, 0})
            vim.cmd('startinsert')
            vim.cmd('wincmd L')
        end, { 
            silent = true, 
            desc = "Open Copilot prompt panel" 
        })
        
        -- Generate completions based on custom prompt
        vim.keymap.set('n', '<leader>cg', function()
            local current_buf = vim.api.nvim_get_current_buf()
            local buf_name = vim.api.nvim_buf_get_name(current_buf)
            
            if buf_name:match("copilot%-prompt") then
                -- Get the prompt from current buffer
                local lines = vim.api.nvim_buf_get_lines(current_buf, 8, -1, false)
                local prompt = table.concat(lines, "\n"):gsub("^%s*", ""):gsub("%s*$", "")
                
                if prompt ~= "" then
                    -- Go to the original file window
                    vim.cmd('wincmd h')
                    
                    -- Insert the prompt as a comment to give Copilot context
                    local original_line = vim.api.nvim_win_get_cursor(0)[1]
                    vim.api.nvim_buf_set_lines(0, original_line, original_line, false, {"// " .. prompt})
                    vim.api.nvim_win_set_cursor(0, {original_line + 1, 0})
                    
                    -- Now open Copilot panel with this context
                    vim.cmd('Copilot panel')
                    vim.cmd('wincmd L')
                    
                    -- Clean up the prompt comment after a short delay
                    vim.defer_fn(function()
                        vim.cmd('wincmd h')
                        vim.api.nvim_buf_set_lines(0, original_line, original_line + 1, false, {})
                        vim.cmd('wincmd l')
                    end, 2000)
                else
                    vim.notify("Please enter a prompt first", vim.log.levels.WARN)
                end
            else
                -- If not in prompt panel, just open regular panel
                vim.cmd('Copilot panel')
                vim.cmd('wincmd L')
            end
        end, { 
            silent = true, 
            desc = "Generate Copilot completions from prompt" 
        })
        vim.keymap.set('n', '<leader>cs', ':Copilot status<CR>', { 
            silent = true, 
            desc = "Check Copilot status" 
        })
        vim.keymap.set('n', '<leader>ce', ':Copilot enable<CR>', { 
            silent = true, 
            desc = "Enable Copilot" 
        })
        vim.keymap.set('n', '<leader>cd', ':Copilot disable<CR>', { 
            silent = true, 
            desc = "Disable Copilot" 
        })
        
        -- File type configuration (optional - customize as needed)
        vim.g.copilot_filetypes = {
            ["*"] = true,
            xml = false,
            markdown = true,
        }
        
        -- Syntax highlighting for Copilot suggestions
        vim.api.nvim_create_autocmd('ColorScheme', {
            pattern = '*',
            callback = function()
                vim.api.nvim_set_hl(0, 'CopilotSuggestion', {
                    fg = '#555555',
                    ctermfg = 8,
                    italic = true,
                    force = true
                })
            end
        })
        
        -- Auto commands for better panel experience
        vim.api.nvim_create_autocmd('BufEnter', {
            pattern = 'copilot://*',
            callback = function()
                -- Set up panel-specific key mappings
                vim.keymap.set('n', '<CR>', '<CR>', { buffer = true, silent = true })
                vim.keymap.set('n', '[[', '[[', { buffer = true, silent = true })
                vim.keymap.set('n', ']]', ']]', { buffer = true, silent = true })
                vim.keymap.set('n', 'q', ':q<CR>', { buffer = true, silent = true })
            end
        })
        
        -- Function to toggle Copilot panel (modified for vertical split)
        local function toggle_copilot_panel()
            local copilot_buffers = vim.fn.filter(vim.fn.range(1, vim.fn.bufnr('$')), 
                'bufexists(v:val) && bufname(v:val) =~ "^copilot://"')
            
            if #copilot_buffers > 0 then
                -- Close existing copilot panels
                for _, buf in ipairs(copilot_buffers) do
                    local windows = vim.fn.win_findbuf(buf)
                    for _, win in ipairs(windows) do
                        vim.api.nvim_win_close(win, false)
                    end
                end
            else
                -- Open copilot panel and move to vertical split
                vim.cmd('Copilot panel')
                vim.cmd('wincmd L')
            end
        end
        
        -- Add toggle mapping
        vim.keymap.set('n', '<leader>ct', toggle_copilot_panel, { 
            silent = true, 
            desc = "Toggle Copilot panel" 
        })
        
        -- Create user commands for easier access (modified for vertical split)
        vim.api.nvim_create_user_command('CopilotPanel', function()
            vim.cmd('Copilot panel')
            vim.cmd('wincmd L')
        end, {})
        vim.api.nvim_create_user_command('CopilotToggle', toggle_copilot_panel, {})
        
        -- Setup notification for first time users
        vim.api.nvim_create_autocmd('VimEnter', {
            once = true,
            callback = function()
                -- Check if Copilot is set up
                vim.defer_fn(function()
                    local status = vim.fn.system('copilot status')
                    if status:match('not authenticated') or status:match('disabled') then
                        vim.notify('Run :Copilot setup to authenticate GitHub Copilot', vim.log.levels.INFO)
                    end
                end, 1000)
            end
        })
    end,
}