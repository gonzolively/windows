" Vundle Specific Options
filetype off         			    " Required for Vundle
set nocompatible
set rtp+=C:\tools\vim\vim91\Vundle.vim	" Add vundle to the RuntimePath

call vundle#begin()

"Vundle Plugins
Plugin 'felixhummel/setcolors.vim'
Plugin 'flazz/vim-colorschemes'
Plugin 'kien/rainbow_parentheses.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'Townk/vim-autoclose'
Plugin 'tpope/vim-ragtag'
Plugin 'vim-scripts/closetag.vim'
Plugin 'vim-scripts/IndentAnything'
Plugin 'vim-scripts/SearchComplete'
Plugin 'VundleVim/Vundle.vim'
Plugin 'Align'
Plugin 'ryanoasis/vim-devicons'

"File-type specific plugins
Plugin 'plasticboy/vim-markdown'
"Plugin 'instant-markdown/vim-instant-markdown' " Need to install NPM, then run this command 'npm -g install instant-markdown-d'

Plugin 'vim-python/python-syntax'
Plugin 'chase/vim-ansible-yaml'
Plugin 'elzr/vim-json'
Plugin 'mrk21/yaml-vim'
Plugin 'sukima/xmledit'
Plugin 'ap/vim-css-color'
call vundle#end()

" mrk21/yaml-vim
au! BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml foldmethod=indent
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

"Syntax highlighting
syntax enable
let python_highlight_all=1
let python_highlight_file_headers_as_comments=1

"Autocomplete settings
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

"General Settings
colorscheme antares
set autoread                   " Automatically reload file on changes
set backspace=indent,eol,start " Sets backspace to delete
set clipboard=unnamed
set cul                        " highlights current line
set encoding=utf8
set ff=unix
set guifont=DejaVu\ Sans\ Mono:h12
set hidden                     " Something about hiding buffers"
set history=1000               " show n # of lines of history
set hlsearch                   " highlight search item
set ignorecase                 " ignores case
set incsearch                  " hihglights as you type an expression
set modelines=0                " Some sort of security setting
set modifiable                 " Allows buffer to be edited, needed for NERDtree specifically
set nobackup
set noerrorbells
set noswapfile                 " Disables the creation of swp files"
set novisualbell
set nowb
set nowrap
set number                     " numbered lines
set pastetoggle=<C-t>          " Toggle paste indentation
set ruler                      " shows ruler (width and column)
set showmatch
set showmode
set smartcase                  " knows when to not ignore case
set t_Co=256
set tabstop=4                  " Set tab width of 2 spaces
set ttyfast
set virtualedit=onemore        " allow for cursor beyond last character
set nofoldenable               " disable folding
set re=2                       " Prevents hanging when opening Typescript files -https://vi.stackexchange.com/questions/25086/vim-hangs-when-i-open-a-typescript-file
"set spell spelllang=en_us      " turn on spellcheck
"set spellfile=~/.vim/spell/en.utf-8.add

"Command Aliases
:command Wq wq
:command WQ wq
:command W w
:command Q q
:command Bundleupdate BundleUpdate

"Filetype specific options
filetype plugin indent on       

"Highlight specific options
hi CursorLine gui=underline cterm=underline                "Highlight current line
hi Visual term=none cterm=none ctermbg=LightGrey
hi Search term=reverse ctermbg=8 guibg=LightGrey
hi Pmenu ctermfg=0 ctermbg=117

"NerdTree specific options
let NERDTreeShowHidden=1
map <C-n> :NERDTreeToggle<CR>   " Toggle NerdTree with Control n

"#################################### Status Bar ######################################
"" status bar colors
au InsertEnter * hi statusline guifg=black guibg=#d7afff ctermfg=black ctermbg=magenta
au InsertLeave * hi statusline guifg=black guibg=#8fbfdc ctermfg=black ctermbg=cyan
hi statusline guifg=black guibg=#8fbfdc ctermfg=black ctermbg=cyan

" Status Line Custom
let g:currentmode={
    \ 'n'  : 'Normal',
    \ 'no' : 'Normal·Operator Pending',
    \ 'v'  : 'Visual',
    \ 'V'  : 'V·Line',
    \ '^V' : 'V·Block',
    \ 's'  : 'Select',
    \ 'S'  : 'S·Line',
    \ '^S' : 'S·Block',
    \ 'i'  : 'Insert',
    \ 'R'  : 'Replace',
    \ 'Rv' : 'V·Replace',
    \ 'c'  : 'Command',
    \ 'cv' : 'Vim Ex',
    \ 'ce' : 'Ex',
    \ 'r'  : 'Prompt',
    \ 'rm' : 'More',
    \ 'r?' : 'Confirm',
    \ '!'  : 'Shell',
    \ 't'  : 'Terminal'
    \}

" Live wordcount function for status line
let g:word_count=wordcount().words
function WordCount()
    if has_key(wordcount(),'visual_words')
        let g:word_count=wordcount().visual_words."/".wordcount().words " count selected words
    else
        let g:word_count=wordcount().cursor_words."/".wordcount().words " or shows words 'so far'
    endif
    return g:word_count
endfunction

set laststatus=2
set noshowmode
set statusline=
set statusline+=%0*\ %n\                                 " Buffer number
set statusline+=%1*\ %<%F%m%r%h%w\                       " File path, modified, readonly, helpfile, preview
set statusline+=%3*│                                     " Separator
set statusline+=%2*\ %Y\                                 " FileType
set statusline+=%3*│                                     " Separator
set statusline+=%2*\ %{''.(&fenc!=''?&fenc:&enc).''}     " Encoding
set statusline+=\ (%{&ff})                               " FileFormat (dos/unix..)
set statusline+=%=                                       " Right Side
set statusline+=\ WC:\ %{WordCount()},                   " Wordcount
set statusline+=%3*│                                     " Separator
"set statusline+=%2*\ col:\ %02v\                        " Colomn number
set statusline+=%1*\ ln:\ %02l/%L\ (%3p%%)\              " Line number / total lines, percentage of document
set statusline+=%0*\ %{toupper(g:currentmode[mode()])}\  " The current mode
