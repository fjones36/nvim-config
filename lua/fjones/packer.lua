-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd.packadd('packer.nvim')


function check_llama_cpp()
  local output = vim.fn.system("docker ps -a")
  local lines = vim.split(output, "\n")
  for _, line in ipairs(lines) do
    if line:find("llama_cpp") then
      return "llama_cpp"
    end
  end
  vim.fn.system("docker run -d --name llama_cpp -p 8000:8000 --rm --gpus all -v /home/fjones/repos/models:/app/models local/llama.cpp:full-cuda-openai python3 -m llama_cpp.server --model /app/models/codellama-7b-instruct.Q4_K_M.gguf --host 0.0.0.0")
  return "llama_cpp"
end


return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use {
	  'nvim-telescope/telescope.nvim', -- tag = '0.1.0',
	  -- or                            , branch = '0.1.x',
	  requires = { {'nvim-lua/plenary.nvim'} }
  }

  use({
	  'rose-pine/neovim',
	  as = 'rose-pine',
	  config = function()
            require("rose-pine").setup({
                variant = "auto", -- auto, main, moon, or dawn
                dark_variant = "main", -- main, moon, or dawn
                dim_inactive_windows = false,
                extend_background_behind_borders = true,

                enable = {
                    terminal = true,
                    legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
                    migrations = true, -- Handle deprecated options automatically
                },

                styles = {
                    bold = true,
                    italic = true,
                    transparency = false,
                },

                groups = {
                    border = "muted",
                    link = "iris",
                    panel = "surface",

                    error = "love",
                    hint = "iris",
                    info = "foam",
                    note = "pine",
                    todo = "rose",
                    warn = "gold",

                    git_add = "foam",
                    git_change = "rose",
                    git_delete = "love",
                    git_dirty = "rose",
                    git_ignore = "muted",
                    git_merge = "iris",
                    git_rename = "pine",
                    git_stage = "iris",
                    git_text = "rose",
                    git_untracked = "subtle",

                    h1 = "iris",
                    h2 = "foam",
                    h3 = "rose",
                    h4 = "gold",
                    h5 = "pine",
                    h6 = "foam",
                },

                highlight_groups = {
                    -- Comment = { fg = "foam" },
                    -- VertSplit = { fg = "muted", bg = "muted" },
                },

                before_highlight = function(group, highlight, palette)
                    -- Disable all undercurls
                    -- if highlight.undercurl then
                    --     highlight.undercurl = false
                    -- end
                    --
                    -- Change palette colour
                    -- if highlight.fg == palette.pine then
                    --     highlight.fg = palette.foam
                    -- end
                end,
            })

		  vim.cmd('colorscheme rose-pine-moon')
	  end
  })

  -- use({
  --     "folke/trouble.nvim",
  --     config = function()
  --         require("trouble").setup {
  --             icons = false,
  --             -- your configuration comes here
  --             -- or leave it empty to use the default settings
  --             -- refer to the configuration section below
  --         }
  --     end
  -- })

  use {
    'nvim-treesitter/nvim-treesitter',
    	run = function()
    	local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
    	ts_update()
    end,
  }
  use("theprimeagen/harpoon")
  use("mbbill/undotree")
  use("tpope/vim-fugitive")
  -- use("nvim-treesitter/nvim-treesitter-context");
  use {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
  }
  use({"hrsh7th/nvim-cmp",
  -- config = function() require('config.cmp') end,
  })
  use("hrsh7th/cmp-buffer")
  use("hrsh7th/cmp-path")
  use("hrsh7th/cmp-cmdline")
  use("hrsh7th/cmp-nvim-lsp")
  use("hrsh7th/cmp-nvim-lua")
  use("hrsh7th/cmp-vsnip")
  use("hrsh7th/vim-vsnip")
  use("saadparwaiz1/cmp_luasnip")

  use("christoomey/vim-tmux-navigator")

  use("lukas-reineke/indent-blankline.nvim")

  use({
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        tag = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!:).
        run = "make install_jsregexp",
        after = 'nvim-cmp',
        -- config = function() require('config.snippets') end,
    })

  -- use({
  --   "jose-elias-alvarez/null-ls.nvim",
  --   dependencies = { "nvim-lua/plenary.nvim" },
  --   config = function()
  --     local null_ls = require("null-ls")

  --     null_ls.setup({
  --       sources = {
  --         null_ls.builtins.diagnostics.ruff,
  --         null_ls.builtins.formatting.black,
  --       }
  --     })
  --   end
  -- })

-- use {'akinsho/bufferline.nvim', tag = "*", requires = 'nvim-tree/nvim-web-devicons'}

use {
  'nvim-lualine/lualine.nvim',
  requires = { 'nvim-tree/nvim-web-devicons', opt = true }
}



    -- CodeLLAMA Support
    use ({
        "gierdo/neoai.nvim",
        branch = 'local-llama',
        requires = { "MunifTanjim/nui.nvim" },
        cmd = {
            "NeoAI",
            "NeoAIOpen",
            "NeoAIClose",
            "NeoAIToggle",
            "NeoAIContext",
            "NeoAIContextOpen",
            "NeoAIContextClose",
            "NeoAIInject",
            "NeoAIInjectCode",
            "NeoAIInjectContext",
            "NeoAIInjectContextCode",
        },
        config = function()
            check_llama_cpp()
            require("neoai").setup({
                -- Options go here
                ui = {
                    output_popup_text = "NeoAI",
                    input_popup_text = "--Prompt",
                    width = 30, -- As percentage eg. 30%
                    output_popup_height = 80, -- As percentage eg. 80%
                    submit = "<Enter>", -- Key binding to submit the prompt
                },
                models = {
                    {
                        name = "openai",
                        model = "codellama",
                        params = nil,
                    },
                },
                register_output = {
                    ["g"] = function(output)
                        return output
                    end,
                    ["c"] = require("neoai.utils").extract_code_snippets,
                },
                inject = {
                    cutoff_width = 75,
                },
                prompts = {
                    default_prompt = function()
                        return "Please only follow instructions or answer to questions. Be concise."
                    end,
                    context_prompt = function(context)
                        return "Please only follow instructions or answer to questions. Be concise. "
                            .. "I'd like to provide some context for future "
                            .. "messages. Here is the code/text that I want to refer "
                            .. "to in our upcoming conversations:\n\n"
                            .. context
                    end,
                },
                mappings = {
                    ["select_up"] = "<C-k>",
                    ["select_down"] = "<C-j>",
                },
                open_ai = {
                    url = "http://localhost:8000/v1/chat/completions",
                    display_name = "llama.cpp",
                    api_key = {
                        env = "OPENAI_API_KEY",
                        value = "12345",
                        -- `get` is is a function that retrieves an API key, can be used to override the default method.
                        -- get = function() ... end

                        -- Here is some code for a function that retrieves an API key. You can use it with
                        -- the Linux 'pass' application.
                        -- get = function()
                        --     local key = vim.fn.system("pass show openai/mytestkey")
                        --     key = string.gsub(key, "\n", "")
                        --     return key
                        -- end,
                    },
                },
                shortcuts = {
                    -- {
                    --     name = "textify",
                    --     key = "<leader>as",
                    --     desc = "fix text with AI",
                    --     use_context = true,
                    --     prompt = [[
                    --         Please rewrite the text to make it more readable, clear,
                    --         concise, and fix any grammatical, punctuation, or spelling
                    --         errors
                    --     ]],
                    --     modes = { "v" },
                    --     strip_function = nil,
                    -- },
                    -- {
                    --     name = "gitcommit",
                    --     key = "<leader>ag",
                    --     desc = "generate git commit message",
                    --     use_context = false,
                    --     prompt = function()
                    --         return [[
                    --             Using the following git diff generate a consise and
                    --             clear git commit message, with a short title summary
                    --             that is 75 characters or less:
                    --         ]] .. vim.fn.system("git diff --cached")
                    --     end,
                    --     modes = { "n" },
                    --     strip_function = nil,
                    -- },
                },

            })
        end,
    })


  -- use {
  --         'VonHeikemen/lsp-zero.nvim',
  --         branch = 'v1.x',
  --         requires = {
  --       	  -- LSP Support
  --       	  {'neovim/nvim-lspconfig'},
  --       	  {'williamboman/mason.nvim'},
  --       	  {'williamboman/mason-lspconfig.nvim'},

  --       	  -- Autocompletion
  --       	  {'hrsh7th/nvim-cmp'},
  --       	  {'hrsh7th/cmp-buffer'},
  --       	  {'hrsh7th/cmp-path'},
  --       	  {'saadparwaiz1/cmp_luasnip'},
  --       	  {'hrsh7th/cmp-nvim-lsp'},
  --       	  {'hrsh7th/cmp-nvim-lua'},

  --       	  -- Snippets
  --       	  {'L3MON4D3/LuaSnip'},
  --       	  {'rafamadriz/friendly-snippets'},
  --         }
  -- }

  -- use("folke/zen-mode.nvim")
  -- use("github/copilot.vim")
  -- use("eandrju/cellular-automaton.nvim")
  -- use("laytan/cloak.nvim")

end)

