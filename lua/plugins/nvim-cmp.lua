return {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
        -- Snippet engine
        {
            "L3MON4D3/LuaSnip",
            -- follow latest release.
            version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
            -- Note: jsregexp build disabled due to Windows file locking issues
            -- The library will work fine without jsregexp for most use cases
            config = function()
                -- Load friendly-snippets
                require("luasnip.loaders.from_vscode").lazy_load()
            end,
        },
        "saadparwaiz1/cmp_luasnip",

        -- LSP source
        "hrsh7th/cmp-nvim-lsp",

        -- Buffer source
        "hrsh7th/cmp-buffer",

        -- Path source
        "hrsh7th/cmp-path",

        -- Command line source
        "hrsh7th/cmp-cmdline",

        -- Snippet collection
        "rafamadriz/friendly-snippets",

        -- Copilot integration
        "zbirenbaum/copilot-cmp",
    },
    config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")

        -- Custom highlight for CMP windows
        vim.api.nvim_set_hl(0, "CmpPmenu", { bg = "#5A5A75", fg = "#cdd6f4" })
        vim.api.nvim_set_hl(0, "CmpSel", { bg = "#45475a", fg = "#f5c2e7" })
        vim.api.nvim_set_hl(0, "CmpDoc", { bg = "#1e1e2e", fg = "#cdd6f4" })
        vim.api.nvim_set_hl(0, "CmpGhostText", { fg = "#6c7086", italic = true })

        cmp.setup({
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },

            preselect = cmp.PreselectMode.None,
            completion = {
                completeopt = "menu,menuone,noinsert,noselect",
            },

            mapping = cmp.mapping.preset.insert({
                ["<C-k>"] = cmp.mapping.select_prev_item(),
                ["<C-j>"] = cmp.mapping.select_next_item(),
                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<C-e>"] = cmp.mapping.abort(),
                ["<CR>"] = cmp.mapping.confirm({ select = false }),

                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.confirm({ select = true })
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    else
                        fallback()
                    end
                end, { "i", "s" }),

                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            }),

            sources = cmp.config.sources({
                { name = "copilot",  group_index = 2, max_item_count = 5 },
                { name = "nvim_lsp", group_index = 2, max_item_count = 5 },
                { name = "luasnip",  group_index = 2, max_item_count = 5 },
                { name = "buffer",   group_index = 2, max_item_count = 5 },
                { name = "path",     group_index = 2, max_item_count = 5 },
            }),

            formatting = {
                format = function(entry, vim_item)
                    vim_item.menu = ({
                        copilot = "[Copilot]",
                        nvim_lsp = "[LSP]",
                        luasnip = "[Snippet]",
                        buffer = "[Buffer]",
                        path = "[Path]",
                    })[entry.source.name]
                    return vim_item
                end,
            },

            window = {
                completion = {
                    border = "none",
                    winhighlight = "Normal:CmpPmenu,CursorLine:CmpSel,Search:None",
                    scrollbar = false,
                    col_offset = -3,
                    side_padding = 0,
                    max_height = 5,
                    entries = "custom", -- Helps limit height but not strictly required here
                },
                documentation = {
                    border = "none",
                    winhighlight = "Normal:CmpDoc",
                    max_width = 80,
                    max_height = 20,
                },
            },

            experimental = {
                ghost_text = {
                    hl_group = "CmpGhostText",
                },
            },
        })

        -- Cmdline setup for `:` (commands and paths)
        cmp.setup.cmdline(":", {
            mapping = {
                ["<C-Up>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    else
                        fallback()
                    end
                end, { "c" }),

                ["<C-Down>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    else
                        fallback()
                    end
                end, { "c" }),

                ["<Tab>"] = cmp.mapping.confirm({ select = true }),
            },
            sources = cmp.config.sources({
                { name = "path", max_item_count = 20 },
            }, {
                { name = "cmdline", max_item_count = 20 },
            }),
            window = {
                completion = {
                    winhighlight = "Normal:CmpPmenu,CursorLine:CmpSel",
                    max_height = 5,
                    entries = "custom",
                },
            },
        })

        -- Cmdline setup for `/` and `?` (buffer search)
        cmp.setup.cmdline({ "/", "?" }, {
            mapping = {
                ["<Up>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    else
                        fallback()
                    end
                end, { "c" }),

                ["<Down>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    else
                        fallback()
                    end
                end, { "c" }),

                ["<Tab>"] = cmp.mapping.confirm({ select = true }),
            },
            sources = {
                { name = "buffer", max_item_count = 20 },
            },
            window = {
                completion = {
                    winhighlight = "Normal:CmpPmenu,CursorLine:CmpSel",
                    max_height = 5,
                    entries = "custom",
                },
            },
        })
    end,
}
