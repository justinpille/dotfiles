set hidden

set scrolloff=8
set number
set relativenumber

set clipboard=unnamedplus
 
set tabstop=2 softtabstop=2
set shiftwidth=2
set expandtab
set smartindent

let mapleader = " "

" Change the working directory to the file being edited
" Print the new cwd
nnoremap <leader>cd :cd %:p:h<CR>:pwd<CR>

" Cleaj search
nnoremap <leader>cs :let @/=""<CR>

" Clear highlights
nnoremap <leader>ch :noh<CR>

call plug#begin()
" Telescope dependencies
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'neovim/nvim-lspconfig'
Plug 'kyazdani42/nvim-web-devicons'

" Telescope
Plug 'nvim-telescope/telescope.nvim'

" Telescope plugins
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'nvim-telescope/telescope-file-browser.nvim'

Plug 'ayu-theme/ayu-vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'sheerun/vim-polyglot'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'karb94/neoscroll.nvim'
Plug 'junegunn/vim-peekaboo'

Plug 'antoinemadec/FixCursorHold.nvim'

call plug#end()


set termguicolors

let ayucolor="dark"
colorscheme ayu



" Prettier stuff
command! -nargs=0 Prettier :CocCommand prettier.forceFormatDocument
nmap <leader>f :Prettier<CR>

" Open this file (a dot file)
nnoremap <leader>. :e /Users/justinpille/.config/nvim/init.vim<CR>

" Source this file
nnoremap <leader><CR> :so /Users/justinpille/.config/nvim/init.vim<CR>

" Use movement keys in insert mode 
inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>


"***************************
"*** Scrolling Behavior ***
"***************************


" Initialize neoscroll plugin
lua <<EOF
require('neoscroll').setup({
    -- All these keys will be mapped to their corresponding default scrolling animation
    mappings = {'<C-u>', '<C-d>', '<C-b>', '<C-f>',
                'zt', 'zz', 'zb'},
    hide_cursor = true,          -- Hide cursor while scrolling
    stop_eof = false,             -- Stop at <EOF> when scrolling downwards
    use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
    respect_scrolloff = false,   -- Stop scrolling when the cursor reaches the scrolloff margin of the file
    cursor_scrolls_alone = false, -- The cursor will keep on scrolling even if the window cannot scroll further
    easing_function = nil,       -- Default easing function
    pre_hook = nil,              -- Function to run before the scrolling animation starts
    post_hook = nil,             -- Function to run after the scrolling animation ends
    performance_mode = false,    -- Disable "Performance Mode" on all buffers.
})
EOF

" Scroll while keeping the cursor in the same screen position
nnoremap <C-j> <C-e>j  
nnoremap <C-k> <C-y>k


"**********************************
"*** End of Scrolling behavior ***
"**********************************


" Initialize telescope
lua <<EOF
require('telescope').setup {
  defaults = {
    initial_mode = 'normal'
  },
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    },
    file_browser = {
      theme = "ivy",
      mappings = {
        ["i"] = {
          -- your custom insert mode mappings
        },
        ["n"] = {
          -- your custom normal mode mappings
        },
      },
    },
  }
}

require('telescope').load_extension('fzf')
require("telescope").load_extension('file_browser')
EOF


" Initialize devicons plugin
lua <<EOF
require'nvim-web-devicons'.setup {
 -- your personnal icons can go here (to override)
 -- you can specify color or cterm_color instead of specifying both of them
 -- DevIcon will be appended to `name`
 override = {
  zsh = {
    icon = "",
    color = "#428850",
    cterm_color = "65",
    name = "Zsh"
  }
 };
 -- globally enable default icons (default to false)
 -- will get overriden by `get_icons` option
 default = true;
}
EOF


"***************************
"*** Telescope shortcuts ***
"***************************

" Open the list of telescope commands in insert mode
nnoremap <leader>t :Telescope<CR>i

" See a LIST of the current buffers
nnoremap <leader>b :Telescope buffers<CR>

" Explore the current working directory
nnoremap <leader>ew :Telescope file_browser<CR>

" Explore the current buffer's file location
nnoremap <leader>ef :Telescope file_browser path=%:p:h<CR>

" Explore home
nnoremap <leader>eh :Telescope file_browser path=$HOME<CR>

" Explore repos 
nnoremap <leader>er :Telescope file_browser path=$HOME/repos<CR>

" Explore notes
nnoremap <leader>en :Telescope file_browser path=$HOME/notes<CR>

"**********************************
"*** End of Telescope shortcuts ***
"**********************************

"***************************
"*** Buffer handling ***
"***************************

" Go to the next buffer
nnoremap <leader>n :bn<CR>

" Go to the previous buffer
nnoremap <leader>p :bp<CR>

" Close the current buffer
nnoremap <leader>q :bd<CR> 

" Close the current buffer without saving
nnoremap <leader>! :bd!<CR> 

"**********************************
"*** End of Buffer handling ***
"**********************************



"***************************
"*** CoC Shortcuts ***
"***************************

" Navigate errors
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)


" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)


" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction


" Rename symbol
nmap <leader>rn <Plug>(coc-rename)


autocmd CursorHold * silent call CocActionAsync('highlight')

" Used for the FixCursorHold plugin
" https://github.com/antoinemadec/FixCursorHold.nvim
" https://github.com/neovim/neovim/issues/12587
let g:cursorhold_updatetime = 200

hi CocHighlightText ctermbg=60 guibg=#333333


"***************************
"*** End of CoC Shortcuts ***
"***************************



"***************************
"*** Airline Settings ***
"***************************


let g:airline_powerline_fonts = 1


let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#tabline#buffer_nr_show = 1

"***************************
"*** End of Airline Settings ***
"***************************



" When going to the end of a file move it to the middle of the screen
nnoremap G Gzz


