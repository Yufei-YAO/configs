vim.cmd( [[
nnoremap <space>rl :so ~/.config/nvim/init.lua<CR>
nnoremap <space>rc :e ~/.config/nvim/init.lua<CR>
set path=$PWD/**
set number
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set ignorecase
set smartcase
set notimeout
set mouse=a
set hidden
set termguicolors
set signcolumn=number

let mapleader = "\<SPACE>" " defualt ,

if empty(glob('~/.config/nvim/autoload/plug.vim'))
:exe '!curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
au VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" =======================
" ===  plugins  begin ===
" =======================
call plug#begin('~/.config/nvim/plugged')
Plug 'Wansmer/symbol-usage.nvim'
Plug 'kylechui/nvim-surround'
Plug 'dstein64/vim-startuptime'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'mfussenegger/nvim-lint'
Plug 'mhartington/formatter.nvim'
Plug 'glepnir/lspsaga.nvim'
" enhance editor
Plug 'tomtom/tcomment_vim'
" terminal
Plug 'skywind3000/vim-terminal-help'
" file explorer
Plug 'nvim-tree/nvim-tree.lua'

" file finder
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.8' }
Plug 'nvim-telescope/telescope-project.nvim'
" highlight
Plug 'sainnhe/everforest'
" lsp
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'onsails/lspkind.nvim'


Plug 'hedyhli/outline.nvim'
" For vsnip users.
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'

" debug

" treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
"context
Plug 'nvim-treesitter/nvim-treesitter-context'

"auto-pair
Plug 'windwp/nvim-autopairs'


"commentary
Plug 'numToStr/Comment.nvim'

"terminal
Plug 'akinsho/toggleterm.nvim', {'tag' : '*'}

"git
Plug 'lewis6991/gitsigns.nvim'
Plug 'sindrets/diffview.nvim'

"scrollbar
Plug 'petertriho/nvim-scrollbar'

"tabline
Plug 'nvim-tree/nvim-web-devicons'
Plug 'akinsho/bufferline.nvim', { 'tag': '*' }

"buffer
Plug 'bsdelf/bufferhint'
"dashboard
Plug 'nvimdev/dashboard-nvim'
"line
Plug 'nvim-lualine/lualine.nvim'

"easymotion
Plug 'easymotion/vim-easymotion'

Plug 'mfussenegger/nvim-dap'

Plug 'theHamsta/nvim-dap-virtual-text'
Plug 'rcarriga/nvim-dap-ui'
Plug 'nvim-neotest/nvim-nio'
Plug 'ray-x/lsp_signature.nvim'
call plug#end()
]])

vim.cmd([[

nnoremap <LEADER>e :NvimTreeToggle<CR>
nnoremap <LEADER>c :clo<CR>


" ==== nvim-telescope/telescope.nvim ====

nnoremap <leader>f <cmd>Telescope find_files<cr>
nnoremap <leader>F <cmd>Telescope live_grep<cr>
nnoremap <leader>B <cmd>Telescope buffers<cr>
nnoremap <leader>tH <cmd>Telescope help_tags<cr>
nnoremap <leader>p <cmd>Telescope project<cr><esc>

" ==== Yggdroot/LeaderF ====

" ==== everforest ====
colorscheme everforest
set background=dark
let g:everforest_background = 'Medium'
let g:everforest_enable_italic = 1
nnoremap - :call bufferhint#Popup() <CR>
nnoremap \ :call bufferhint#LoadPrevious() <CR>

let g:EasyMotion_do_mapping = 0 " Disable default mappings
nmap <C-s> <Plug>(easymotion-overwin-f)
let g:EasyMotion_smartcase = 1
" Gif config
map <Leader>l <Plug>(easymotion-lineforward)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
map <Leader>h <Plug>(easymotion-linebackward)

let g:EasyMotion_startofline = 0 " keep cursor column when JK motion

nnoremap <S-Up> :resize -1<CR>
nnoremap <S-Down> :resize +1<CR>
nnoremap <S-Left> :vertical resize -1<CR>
nnoremap <S-Right> :vertical resize +1<CR>

function! s:generate_compile_commands()
if empty(glob('CMakeLists.txt'))
echo "Can't find CMakeLists.txt"
return
endif
if empty(glob('build'))
execute 'silent !mkdir build'
endif
execute '!cmake -DCMAKE_BUILD_TYPE=debug
\ -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -S . -B build'
execute '!cp  build/compile_commands.json .'
execute '!sed -i s/-Werror//g compile_commands.json'
endfunction
command! -nargs=0 Gcmake :call s:generate_compile_commands()
nnoremap <LEADER>s :Outline<CR>
nnoremap Z zz<CR>
]])

local mason_opts = { ensure_installed = { "lua_ls", "clangd"}}
local util = require'lspconfig.util'
local clangd_opts = {
    single_file_support = true,
    root_dir = function(fname)
        return util.root_pattern('.vscode','build')(fname) or util.find_git_ancestor(fname) or vim.fn.getcwd()
    end,
    init_options = {
        compilationDatabaseDirectory = 'build',
        cache = {
            directory = "/tmp/clangd"
        },
        index = {
            threads = 4,
        },
        clang = {
            excludeArgs = { } ,
        },
        usePlaceholders = true,
    },
}
local lsp_signature_cfg = {}  -- add your config here


vim.keymap.set({ 'i' }, '<C-k>', function()       require('lsp_signature').toggle_float_win()
end, { silent = true, noremap = true, desc = 'toggle signature' })

local function nvim_tree_my_on_attach(bufnr)
    local api = require "nvim-tree.api"
    local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end
    api.config.mappings.default_on_attach(bufnr)
    vim.keymap.set('n', '<C-t>', api.tree.change_root_to_parent,        opts('Up'))
    vim.keymap.set('n', '?',     api.tree.toggle_help,                  opts('Help'))
    vim.keymap.set('n', '<ESC>',     api.tree.close,                  opts('Close'))
end
local nvim_tree_opt = {
    on_attach = nvim_tree_my_on_attach,
    sync_root_with_cwd = true,
    hijack_cursor = true,
    prefer_startup_root = true,
    update_cwd = true, -- 打开时自动更新当前工作目录
}
local nvim_treesitter_configs = {
    ensure_installed = { "c", "lua",   "vim", "vimdoc", "query", "cpp", "python" },
    sync_install = false,
    auto_install = true,
    ignore_install = {  },
    highlight = {
        enable = true,
        disable = {},
        additional_vim_regex_highlighting = false,
    },
    folding = {
        enable = true,
        use_signs = true,     -- 使用标记
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "<CR>",
            node_incremental = "<CR>",
            node_decremental = "<BS>",
            scope_incremental = "<TAB>",
        },
        is_supported = function ()
            local mode = vim.api.nvim_get_mode().mode
            if mode == "c" then
                return false
            end
            return true
        end
    },
    indent = {
        enable = false
    },
    textobjects = {
        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
                ["]m"] = "@function.outer",
                ["]]"] = { query = "@class.outer", desc = "Next class start" },
                ["]o"] = "@loop.*",
                ["]s"] = { query = "@local.scope", query_group = "locals", desc = "Next scope" },
                ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
            },
            goto_next_end = {
                ["]M"] = "@function.outer",
                ["]["] = "@class.outer",
            },
            goto_previous_start = {
                ["[m"] = "@function.outer",
                ["[["] = "@class.outer",
            },
            goto_previous_end = {
                ["[M"] = "@function.outer",
                ["[]"] = "@class.outer",
            },
            goto_next = {
                ["]d"] = "@conditional.outer",
            },
            goto_previous = {
                ["[d"] = "@conditional.outer",
            }
        },
        select = {
            enable = true,
            lookahead = true,
            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                -- You can optionally set descriptions to the mappings (used in the desc parameter of
                -- nvim_buf_set_keymap) which plugins like which-key display
                ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
                -- You can also use captures from other query groups like `locals.scm`
                ["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
            },
            selection_modes = {
                ['@parameter.outer'] = 'v', -- charwise
                ['@function.outer'] = 'V', -- linewise
                ['@class.outer'] = '<c-v>', -- blockwise
            },
            include_surrounding_whitespace = true,
        },
    },

}

local gitsign_opt = {
    signs = {
        add          = { text = '┃' },
        change       = { text = '┃' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
    },
    signs_staged = {
        add          = { text = '┃' },
        change       = { text = '┃' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
    },
    signs_staged_enable = true,
    signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
    numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
    linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
    word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
    watch_gitdir = {
        follow_files = true
    },
    auto_attach = true,
    attach_to_untracked = false,
    current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = false,
        virt_text_priority = 100,
        use_focus = true,
    },
    current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil, -- Use default
    max_file_length = 40000, -- Disable if file is longer than this (in lines)
    preview_config = {
        -- Options passed to nvim_open_win
        border = 'single',
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1
    },
    on_attach = function(bufnr)
        local function map(mode, lhs, rhs, opts)
            opts = vim.tbl_extend('force', {noremap = true, silent = true}, opts or {})
            vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
        end

        -- Navigation
        map('n', ']c', "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", {expr=true})
        map('n', '[c', "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", {expr=true})

        -- Actions
        map('n', '<leader>tfb', '<cmd>lua require"gitsigns".blame_line{full=true}<CR>')
        map('n', '<leader>tb', '<cmd>Gitsigns toggle_current_line_blame<CR>')
        map('n', '<leader>td', '<cmd>Gitsigns toggle_deleted<CR>')

        -- Text object
        map('o', 'ih', ':<C-U>Gitsigns select_hunk<CR>')
        map('x', 'ih', ':<C-U>Gitsigns select_hunk<CR>')
    end
}

local telescope_opt = {
    defaults = {
        mappings = {
            n = {
                ["<?>"] = "which_key",
                ["<C-x>"] = "select_vertical",
            }
        },
    },

    fzf = {
        fuzzy = true, -- false will only do exact matching
        override_generic_sorter = true, -- override the generic sorter
        override_file_sorter = true, -- override the file sorter
        case_mode = "smart_case" -- or "ignore_case" or "respect_case"
        -- the default case_mode is "smart_case"
    },
    extensions = {
        project = {
            mappings = {
                n = {
                    ['d'] = require("telescope._extensions.project.actions").delete_project,
                    ['r'] = require("telescope._extensions.project.actions").rename_project,
                    ['c'] = require("telescope._extensions.project.actions").add_project,
                    ['C'] = require("telescope._extensions.project.actions").add_project_cwd,
                    ['f'] = require("telescope._extensions.project.actions").find_project_files,
                    ['<CR>'] = require("telescope._extensions.project.actions").change_working_directory,
                },
            }

        }
    }
}


local treesitter_context_cfg = {
    enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
    multiwindow = false, -- Enable multiwindow support.
    max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
    min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
    line_numbers = true,
    multiline_threshold = 20, -- Maximum number of lines to show for a single context
    trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
    mode = 'cursor',  -- Line used to calculate context. Choices: 'cursor', 'topline'
    -- Separator between context and content. Should be a single character string, like '-'.
    -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
    separator = nil,
    zindex = 20, -- The Z-index of the context window
    on_attach = nil, -- (fun(buf: integer): bool) return false to disable attaching
}

local dashboard_opt = {
theme = 'hyper', -- Choose a theme (e.g., 'hyper', 'doom', 'custom')
config = {
    week_header = {
        enable = true, -- Enable week header
    },
    shortcut = {
        { desc = '  Find File', group = 'Label', action = 'Telescope find_files', key = 'f' },
        { desc = '  New File', group = 'Label', action = 'ene!', key = 'n' },
        { desc = '  Search Text', group = 'Label', action = 'Telescope live_grep', key = 's' },
        { desc = '  Configuration', group = 'Label', action = 'e ~/.config/nvim/init.lua', key = 'c' },
    },
    -- //packages = { enable = true }, -- Show installed plugins
    footer = {}, -- Custom footer
    project = {
        enable = false, -- Enable recent projects
        limit = 8, -- Number of recent projects to display
        icon = ' ', -- Icon for projects
        label = 'Recent Projects', -- Label for projects section
        action = 'Telescope projects', -- Action to open a project
    },
    mru = {
        limit = 8, -- Number of recently opened files to display
        icon = ' ', -- Icon for recent files
        label = 'Recent Files', -- Label for recent files section
    },
},
}
local get_args = function()
    -- 获取输入命令行参数
    --local cmd_args = vim.fn.input('CommandLine Args:')
    local cmd_args = ""
    local params = {}
    -- 定义分隔符(%s在lua内表示任何空白符号)
    local sep = "%s"
    for param in string.gmatch(cmd_args, "[^%s]+") do
        table.insert(params, param)
    end
    return params
end;
local function get_executable_from_cmake(path)
    -- 使用awk获取CMakeLists.txt文件内要生成的可执行文件的名字
    -- 有需求可以自己改成别的
    local get_executable = 'awk "BEGIN {IGNORECASE=1} /add_executable\\s*\\([^)]+\\)/ {match(\\$0, /\\(([^\\)]+)\\)/,m);match(m[1], /([A-Za-z_]+)/, n);printf(\\"%s\\", n[1]);}" '
    .. path .. "CMakeLists.txt"
    return vim.fn.system(get_executable)
end
-- 设置调试相关的字符和颜色

-- 输入unicode的方法：ctrl + v + u 再输入unicode码
-- 可在https://www.nerdfonts.com/cheat-sheet查询想要的字符
-- end dap
local dap_breakpoint = {
    breakpoint = {
        text = "󰃤",
        texthl = "LspDiagnosticsSignError",
        linehl = "",
        numhl = "",
    },
    rejected = {
        text = "",
        texthl = "LspDiagnosticsSignHint",
        linehl = "",
        numhl = "",
    },
    stopped = {
        text = "",
        texthl = "LspDiagnosticsSignInformation",
        linehl = "DiagnosticUnderlineInfo",
        numhl = "LspDiagnosticsSignInformation",
    },
}
local dap_lldb_cfg = {
    type = "executable",
    command = "/home/yfyao/workplace/debug/llvm-project/build/bin/lldb-dap",
    -- 这里的name对应下面configurations中的type
    name = "lldb",
}
local dap_config_cpp ={
    {
        name = "Launch file",
        type = "lldb",
        request = "launch",
        console = "integratedTerminal",
        program = function()
            local current_path = vim.fn.getcwd() .. "/"
            --local cmd_args = vim.fn.input('Exe path:')
            return current_path .. "build/bin/dolphindb"
        end,
        cwd = "${workspaceFolder}/build",
        stopOnEntry = false,
        args = get_args,
    },
}
local dap_v_text_cfg = {
    enabled = true,
    enable_commands = true,
    highlight_changed_variables = true,
    highlight_new_as_changed = false,
    show_stop_reason = true,
    commented = false,
    only_first_definition = true,
    all_references = false,
    filter_references_pattern = '<module',
    virt_text_pos = 'eol',
    all_frames = false,
    virt_lines = false,
    virt_text_win_col = nil
}
-- 设置快捷键
-- 检测当前窗口是否是 quickfix 窗口
function is_quickfix_open()
    for _, win in ipairs(vim.fn.getwininfo()) do
        if win.quickfix == 1 then
            return true
        end
    end
    return false
end

function smart_cnext()
    -- 获取 quickfix 列表的信息
    local qf_info = vim.fn.getqflist({ idx = 0 })
    local cur_idx = qf_info.idx
    local total = #vim.fn.getqflist()
    if cur_idx == total then
        -- 已经在最后一个位置，跳转到第一个位置
        vim.cmd("cfirst")
    else
        -- 否则正常跳转到下一个位置
        vim.cmd("cnext")
    end
end

-- 自定义函数包装 cprev
function smart_cprev()
    -- 获取 quickfix 列表的信息
    local qf_info = vim.fn.getqflist({ idx = 0 })
    local cur_idx = qf_info.idx
    if cur_idx == 1 then
        -- 已经在第一个位置，跳转到最后一个位置
        vim.cmd("clast")
    else
        -- 否则正常跳转到上一个位置
        vim.cmd("cprev")
    end
end
-- 修改 C-j/C-k 的行为
function navigate_and_preview(step)
    if is_quickfix_open() then
        -- 如果在 quickfix 窗口中，正常导航
        if step > 0 then
            smart_cnext()
        else
            smart_cprev()
        end
    else

    end
end
local saga_setup = {
    code_action_lightbulb = {
        enable = false, -- 关闭光标悬停时的动作提示
    },
    symbol_in_winbar = {
        enable = false, -- 保持界面简洁，关闭顶部符号显示
    },
}
local outline_opts = {
    keymaps = { -- These keymaps can be a string or a table for multiple keys
        close = {"<Esc>", "q"},
        goto_location = "<Cr>",
        focus_location = "o",
        hover_symbol = "<C-space>",
        rename_symbol = "r",
        code_actions = "a",
        fold = "f",
        unfold = "u",
        fold_all = "F",
        unfold_all = "U",
    },
}
local toggleterm_opt = {
    open_mapping = [[<c-t>]],
    start_in_insert = true,
    direction = 'horizontal'
}
local sc_opt = {
    handlers = {
        gitsigns = true,
    },
}
local util = require "formatter.util"

local formatter_opt = {
  logging = true,
  log_level = vim.log.levels.WARN,
  filetype = {
    c = {
      function()
        return {
          exe = "clang-format",
          args = {"--style=Google", "--assume-filename=".. vim.fn.expand('%:t')},
          stdin = true
        }
      end
    },
    cpp = {
      -- 使用 clang-format 对 C++ 语言文件进行格式化
      function()
        return {
          exe = "clang-format",
          args = { "--assume-filename=".. vim.fn.expand('%:t')},
          stdin = true
        }
      end
    },
    lua = {
      require("formatter.filetypes.lua").stylua,
      function()
        if util.get_current_buffer_file_name() == "special.lua" then
          return nil
        end
        return {
          exe = "stylua",
          args = {
            "--search-parent-directories",
            "--stdin-filepath",
            util.escape_path(util.get_current_buffer_file_path()),
            "--",
            "-",
          },
          stdin = true,
        }
      end
    },
    ["*"] = {
      require("formatter.filetypes.any").remove_trailing_whitespace,
    }
  }
}
require("mason").setup()
require("mason-lspconfig").setup(mason_opts)
require'lspconfig'.lua_ls.setup{}
require'lspconfig'.clangd.setup (clangd_opts)
require "lsp_signature".setup(lsp_signature_cfg)
require("nvim-tree").setup(nvim_tree_opt)

require'nvim-treesitter.configs'.setup(nvim_treesitter_configs)
require('nvim-surround').setup()
require('Comment').setup()
require("toggleterm").setup(toggleterm_opt)
require('gitsigns').setup(gitsign_opt)
require('scrollbar').setup(sc_opt)
require("telescope").setup(telescope_opt)
require("telescope").load_extension('project')
require('treesitter-context').setup(treesitter_context_cfg)
require('dashboard').setup(dashboard_opt)
require('lualine').setup()
require('nvim-autopairs').setup()
require('symbol-usage').setup()
require('symbol-usage').toggle_globally()
require('lspsaga').setup(saga_setup)
require("formatter").setup(formatter_opt) 


local dap = require('dap')
dap.runInTerminal = true
dap.adapters.lldb = dap_lldb_cfg
dap.configurations.cpp = dap_config_cpp
dap.configurations.c = dap.configurations.cpp
require("dapui").setup()
require("outline").setup(outline_opts)
require("nvim-dap-virtual-text").setup(dap_v_text_cfg)


vim.keymap.set("n", "<F4>", function() require("dapui").toggle() end)
vim.keymap.set("n", "<F5>", function() require("dap").continue() end)
vim.keymap.set("n", "<F6>", function() require("dap").restart() end)
vim.keymap.set("n", "<F7>", function() require("dap").terminate() end)
vim.keymap.set("n", "<F9>", function() require("dap").toggle_breakpoint() end)
vim.keymap.set("n", "<F10>", function() require("dap").step_over() end)
vim.keymap.set("n", "<F11>", function() require("dap").step_into() end)
vim.keymap.set("n", "<F12>", function() require("dap").step_out() end)


vim.fn.sign_define("DapBreakpoint", dap_breakpoint.breakpoint)
vim.fn.sign_define("DapStopped", dap_breakpoint.stopped)
vim.fn.sign_define("DapBreakpointRejected", dap_breakpoint.rejected)

local dap, dapui = require("dap"), require("dapui")
dap.listeners.before.attach.dapui_config = function()
    dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
    dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
    dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
    dapui.close()
end



local cmp = require'cmp'
cmp.setup({
    snippet = {
        -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
        -- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
      end,
    },
    window = {
        completion = cmp.config.window.bordered({
            -- 设置最大高度和宽度
            max_height = 10, -- 设置最大高度为10行
            max_width = 30,  -- 设置最大宽度为60列
        }),
        -- 文档窗口的配置
        documentation = cmp.config.window.bordered({
            -- 类似地可以设置文档窗口的最大高度和宽度
            max_height = 10,
            max_width = 30
        })
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        ['<TAB>'] = cmp.mapping.select_next_item(),
        ['<S-TAB>'] = cmp.mapping.select_prev_item(),

    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
          { name = 'vsnip' }, -- For vsnip users.
        -- { name = 'ultisnips' }, -- For ultisnips users.
        -- { name = 'snippy' }, -- For snippy users.
    }, {
            { name = 'buffer' },
        }),
})


cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
            { name = 'cmdline' }
        }),
    matching = { disallow_symbol_nonprefix_matching = false }
})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
require('lspconfig')['clangd'].setup {
    capabilities = capabilities
}


local lspkind = require('lspkind')
cmp.setup {
    formatting = {
        format = lspkind.cmp_format({
            mode = 'symbol', -- show only symbol annotations
            maxwidth = {
                -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
                -- can also be a function to dynamically calculate max width such as
                -- menu = function() return math.floor(0.45 * vim.o.columns) end,
                menu = 50, -- leading text (labelDetails)
                abbr = 50, -- actual suggestion item
            },
            ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
            show_labelDetails = true, -- show labelDetails in menu. Disabled by default

            -- The function below will be called before any actual modifications from lspkind
            -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
            before = function (entry, vim_item)
                -- ...
                return vim_item
            end
        })
    }
}


-- 配置诊断跳转（与 coc 配置的 [g 和 ]g 保持一致）
vim.keymap.set('n', '[g', '<cmd>Lspsaga diagnostic_jump_prev<CR>', { silent = true })
vim.keymap.set('n', ']g', '<cmd>Lspsaga diagnostic_jump_next<CR>', { silent = true })

-- 配置重命名（与 coc 的 <leader>rn 保持一致）
vim.keymap.set('n', '<leader>rn', '<cmd>Lspsaga rename<CR>', { silent = true })

vim.keymap.set('x', '<leader>=', function()
    vim.lsp.buf.format({ async = true })
end, { silent = true })



-- 配置诊断列表（与 coc 的 <leader>d 保持一致）
vim.keymap.set('n', '<leader>d', '<cmd>Lspsaga show_buf_diagnostics<CR>', { silent = true })

-- 快速修复（与 coc 的 <leader>qf 保持一致）
vim.keymap.set('n', '<leader>qf', '<cmd>Lspsaga code_action<CR>', { silent = true })


-- 跳转到定义、类型定义、实现和引用（与 coc 的 gd、gy、gi、gr 保持一致）
vim.keymap.set('n', 'gd', '<cmd>Lspsaga goto_definition<CR>', { silent = true })
vim.keymap.set('n', 'gD', '<cmd>tab split | Lspsaga goto_definition<CR>', { silent = true })
vim.keymap.set('n', 'gy', '<cmd>Lspsaga peek_type_definition<CR>', { silent = true })
vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', { silent = true })

-- 定义函数对象和类对象的文本对象（与 coc 的 if、af、ic、ac 保持一致）


vim.keymap.set('n', '<Esc>', function()
    if is_quickfix_open() then
        vim.cmd('cclose')
    else
        -- 可以添加其他操作，例如不执行任何操作，或者执行其他命令
        -- 例如：vim.cmd('echo "Function returned false"')
    end
end, { noremap = true, silent = true })
-- 更新快捷键映射
vim.api.nvim_set_keymap("n", "<C-j>", "<cmd>lua navigate_and_preview(1)<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-k>", "<cmd>lua navigate_and_preview(-1)<CR>", { noremap = true, silent = true })
-- 设置函数：调用 vim.lsp.buf.references 并填充 quickfix 列表
vim.api.nvim_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", { noremap = true, silent = true })


require('lint').linters_by_ft = {
  markdown = {'vale'},
}

--
--
-- Utilities for creating configurations
-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
--
-- vim.wo.foldmethod = 'syntax'
-- vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
-- vim.wo.foldlevel=99
--

local ts_repeat_move = require "nvim-treesitter.textobjects.repeatable_move"
vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)
--
-- local augroup = vim.api.nvim_create_augroup
-- local autocmd = vim.api.nvim_create_autocmd
-- augroup("__formatter__", { clear = true })
-- autocmd("BufWritePost", {
-- 	group = "__formatter__",
-- 	command = ":FormatWrite",
-- })

-- 在你的配置文件中（例如 ~/.config/nvim/init.lua）添加以下内容

-- 引入 lint 模块
local lint = require('lint')

-- 定义一个函数来切换 lint 的启用状态
local function toggle_lint()
    lint.try_lint({"cpplint"}) -- 如果 lint 是启用的，尝试进行代码检查
end
local function toggle_lint_dis()
    lint.try_lint() -- 如果 lint 是启用的，尝试进行代码检查
end

-- 创建一个命令来调用上面定义的函数
vim.api.nvim_create_user_command('Lint', toggle_lint, {})
vim.api.nvim_create_user_command('LintDisable', toggle_lint_dis, {})
vim.api.nvim_create_user_command('Q', 'qa!', {})
vim.api.nvim_create_user_command('W', 'wqa', {})
