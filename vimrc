" ============================================
"  Vim Configuaration
"   Brian Young
" ============================================
" TODO: Setup mpython
"   mpython is python
"   use custom config for syntax checking
"   Use yapf with special format for mpy (if token exists)
" TODO: Autoimport

set nocompatible     " Disable VI backwards compatibility

" ================ Plugins ===================
call plug#begin()
  " Basics
  Plug 'tpope/vim-sensible'          " Sensible defaults
  Plug 'flazz/vim-colorschemes'      " Color schemes

  " Motion and colors
  Plug 'easymotion/vim-easymotion'   " Hot key to move around easily
  Plug 'tpope/vim-repeat'            " Let . work with plugins
  Plug 'tpope/vim-commentary'        " Comment text objects
  Plug 'tpope/vim-surround'          " Brackets/quotes/etc as text objects
  " Plug 'tpope/vim-unimpaired'
  Plug 'luochen1990/rainbow'         " Rainbow parantheses
  Plug 'sheerun/vim-polyglot'        " Syntax highlighting for languages

  " Interfaces
  Plug 'scrooloose/nerdtree'         " File explorer
  Plug 'itchyny/lightline.vim'       " Status bar
  Plug 'ap/vim-buftabline'           " Show buffers
  Plug 'airblade/vim-gitgutter'      " Git data
  Plug 'jeetsukumaran/vim-buffergator' " Buffer jumping

  " Python IDE-type behavior
  Plug 'davidhalter/jedi-vim'        " Use Jedi to do things
  Plug 'ervandew/supertab'           " Use tab instead of <c-x><c-o>
  Plug 'dense-analysis/ale'          " Syntax checking
  Plug 'maximbaz/lightline-ale'      " ALE in status line

call plug#end()


" NOTES on python:
" - ale is used for syntax checking and fixing. It will shell out to 'flake8',
"   'black', and 'isort', so that whatever is on your path is what will be
"   used.
" - jedi-vim uses its own code in the process, but it looks for libraries in the
"   virtual environment.


" ================ Color and Display ====================
"  Basic UI Setup
filetype plugin indent on
set number              " Line numbers
set mouse=a             " Mouse usage
set cursorline          " Show current line highlighted
set ttymouse=xterm      " Fix RH7 XTERM Bug
if has('mouse_sgr')
  set ttymouse=sgr      " Allow mouse past 220 characters
endif
set wildmenu            " Visual autocomplete in command bar
set showmatch           " Show matching parantheses
set textwidth=80        " Text width
syntax on               " Syntax highlighting
set backspace=indent,eol,start  " Backspace behavior for MacOS
set incsearch           " Search as you type
set hlsearch            " Highlight searches
set list                " Enable white space showing
set colorcolumn=+1      " Color column at +1 of gutter
set listchars=tab:>~    " Highlight tabs
set foldlevel=99        " Never fold code at startup
set laststatus=2        " Always show status line
set lazyredraw          " Faster scrolling

" Color scheme
colo jellybeans       " Jelly beans theme (works on both GUI and CTERM)
set background=dark   " Modify fonts for dark bacgkround
highlight ColorColumn ctermbg=234 guibg=#333333
highlight CursorLine ctermbg=235 guibg=#3A3A3A

if &term =~ '256color'
    " Disable background color erase (BCE) so that color schemes
    " work properly inside tmux/screen
    set t_ut=
endif

" Silence bug in vim making first use of py3 silent
silent! py3 pass

highlight ExtraWhiteSpace ctermbg=234 guibg=#333333
match ExtraWhiteSpace /\s\+$/

" Fonts
set termencoding=utf-8
set encoding=utf-8
set guifont=Ubuntu\ Mono:h12

" Default tab settings (python is set in augroup)
set tabstop=2     " Visual size of tab
set softtabstop=2   " Size of soft tab
set shiftwidth=2  " Tabs for autoindentation
set expandtab     " Always use spaces instead of tabs
set autoindent    " Automatically indent

let g:buftabline_show=1        " Only show if two buffers
let g:buftabline_numbers=1     " Show buffer number
let g:buftabline_indicators=1  " Show flag if modified


" =============== Autocorrections =====================
iabbrev ouptuts outputs
iabbrev ouputs outputs
iabbrev oututs outputs
iabbrev ouptut output
iabbrev ouput output
iabbrev outut output
iabbrev Ouptuts Outputs
iabbrev Ouputs Outputs
iabbrev Oututs Outputs
iabbrev Ouptut Output
iabbrev Ouput Output
iabbrev Outut Output


" =============== File-type specific handling =========================
augroup configgroup
  " Clear existing autocommands
  autocmd!

  " Specify file type for mpython files
  au BufNewFile,BufRead *.mpy set filetype=mpython  " Special monte python

  " Python and mpython setup
  autocmd FileType mpython setlocal syntax=python
  autocmd FileType python,mpython setlocal tabstop=4
  autocmd FileType python,mpython setlocal softtabstop=4
  autocmd FileType python,mpython setlocal shiftwidth=4
  autocmd FileType python,mpython setlocal foldmethod=indent
  autocmd FileType mpython setlocal commentstring=#\ %s
augroup END


" ========== Key Mappings and Commands =============
" Navigate windows using Shift+Arrows
nmap <silent> <S-Up> :wincmd k<CR>
nmap <silent> <S-Down> :wincmd j<CR>
nmap <silent> <S-Left> :wincmd h<CR>
nmap <silent> <S-Right> :wincmd l<CR>
nmap <silent> <S-k> :wincmd k<CR>
nmap <silent> <S-j> :wincmd j<CR>
nmap <silent> <S-h> :wincmd h<CR>
nmap <silent> <S-l> :wincmd l<CR>


" Shortcuts
"  -- Past mode with F5 --
set pastetoggle=<F5>

"  -- Hardwrap mode with F6 --
inoremap <F6> <C-\><C-O>:ToggleHardWrap<CR>
nnoremap <silent> <F6> :ToggleHardWrap<CR>

"  -- Ctrl+n shows file tree --
map <C-n> :NERDTreeToggle<CR>   " CTRL+N to launch

"  -- Easymotion with single \ (\w to move forward) --
map <Leader> <Plug>(easymotion-prefix)

"  -- Ctrl+Z works like Ctrl+A since it gets blocked by tmux --
nnoremap <C-z> <C-a>

" -- Autofix toggle with F7 --
inoremap <F7> <C-\><C-O>:ToggleAutoFix<CR>
nnoremap <silent> <F7> :ToggleAutoFix<CR>

" =================== Commands ====================
"  -- Clear white space --
command! SWS execute ':let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>norm!``'

" "  -- Hard Wrap Toggle --
let g:wrapmode='c'

function! g:ToggleHardWrap()
  if g:wrapmode == 'c'
    let g:wrapmode = 'tc'
  elseif g:wrapmode == 'tc'
    let g:wrapmode = ''
  else
    let g:wrapmode = 'c'
  endif
  call g:ApplyWrapMode()
endfunction

function! g:ApplyWrapMode()
  if g:wrapmode == 'c'
    set formatoptions +=c
    set formatoptions -=t
  elseif g:wrapmode == 'tc'
    set formatoptions +=c
    set formatoptions +=t
  elseif g:wrapmode == ''
    set formatoptions -=c
    set formatoptions -=t
  endif
endfunction

call g:ApplyWrapMode()

command! ToggleHardWrap execute 'call g:ToggleHardWrap()'

function! g:ToggleAutoFix()
  if g:ale_fix_on_save
    let g:ale_fix_on_save=0
  else
    let g:ale_fix_on_save=1
  endif
endfunction

command! ToggleAutoFix execute 'call g:ToggleAutoFix()'


" =============== Plugin Configuration =======================
"  ~~ Rainbow Parentheses ~~
let g:rainbow_active = 1
let g:rainbow_conf = {
\    'ctermfgs': ['blue', 'brown', 'yellow', 'gray', 'darkgreen'],
\    'operators': '_,_',
\    'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
\    'separately': {
\        '*': {},
\        'tex': {
\            'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
\        },
\        'lisp': {
\            'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3'],
\        },
\        'vim': {
\            'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold', 'start=/(/ end=/)/ containedin=vimFuncBody', 'start=/\[/ end=/\]/ containedin=vimFuncBody', 'start=/{/ end=/}/ fold containedin=vimFuncBody'],
\        },
\        'html': {
\            'parentheses': ['start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'],
\        },
\    }
\}


"  ~~ Lightline status line ~~
let g:lightline = {
  \ 'colorscheme': 'jellybeans',
  \ 'active': {
  \   'left': [
  \     ['mode', 'paste'],
  \     ['readonly', 'filename', 'modified']
  \    ],
  \   'right': [
  \     ['linter_checking', 'linter_errors', 'linter_warnings',
  \      'linter_infos', 'linter_ok' ],
  \     ['lineinfo'],
  \     ['percent'],
  \     ['fileformat', 'fileencoding', 'filetype', 'hardwrap', 'fixer']
  \   ],
  \ },
  \ 'component': {
  \   'percent': '%p%% of %L',
  \ },
  \ 'component_function': {
  \    'hardwrap': 'HardWrapStatus',
  \    'fixer': 'FixerStatus',
  \ },
  \ 'component_expand':{
  \   'linter_checking': 'lightline#ale#checking',
  \   'linter_infos': 'lightline#ale#infos',
  \   'linter_warnings': 'lightline#ale#warnings',
  \   'linter_errors': 'lightline#ale#errors',
  \   'linter_ok': 'lightline#ale#ok',
  \ },
  \ 'component_type': {
  \   'linter_checking': 'right',
  \   'linter_infos': 'right',
  \   'linter_warnings': 'warning',
  \   'linter_errors': 'error',
  \   'linter_ok': 'right',
  \ }
\}

function! g:HardWrapStatus()
  if g:wrapmode == 'c'
    return 'comwrap'
  elseif g:wrapmode == 'tc'
    return '   wrap'
  elseif g:wrapmode == ''
    return 'no wrap'
  endif
endfunction


function! g:FixerStatus()
  if g:ale_fix_on_save
    let header = 'autofix'
  else
    let header = 'manfix'
  endif

  let fixers = []
  if exists('g:ale_fixers')
    let fixers += get(g:ale_fixers, &filetype, [])
  endif
  if exists('b:ale_fixers')
    let fixers += b:ale_fixers
  endif

  if fixers == []
    return ''
  else
    return header . '[' . join(fixers, ',') . ']'
  endif
endfunction



"  ~~ ALE Configuration ~~
let g:ale_linter_aliases = {'mpython': 'python'}
let g:ale_completion_enabled = 1

let g:ale_linters = {
  \ 'python': ['flake8'],
  \ 'mpython': ['flake8'],
  \ 'javascript': ['eslint'],
\}

let g:ale_lint_on_text_changed = 0  " never
let g:ale_lint_on_insert_leave = 1
let g:ale_fix_on_save = 1

" Ignore errors and awarnings
"  Ignore F403 and 405, which are undefined name with import *, and use of *.
"  You know you shouldn't you don't need to be nagged
let g:ale_python_flake8_options = '--ignore=E,W,F403,F405 --select=F,E999,C90'
augroup flake8
  autocmd!
  autocmd FileType mpython let b:ale_python_flake8_options =
    \ '--ignore=E,W,F403,F405 --select=F,E999,C90 --appendconfig '
    \ .expand('~/.vim/mpython_builtins.ini')
augroup END


" ~~ Jedi configuration ~~
autocmd FileType python,mpython setlocal completeopt-=preview
let g:jedi#popup_on_dot = 0
let g:jedi#show_call_signatures = 2
set noshowmode
let g:jedi#squelch_py_warning = 1
let g:jedi#smart_auto_mappings = 0
let g:SuperTabDefaultCompletionType = 'context'
set completeopt=menuone,longest

let g:jedi#documentation_command = "<leader>K"


" ~~ Use black/isort as needed ~~
"  1. Use black if ".black", ".autofix", or a "pyproject.toml" with [tool.black]
"     defined exists in any directory at the current directory or above.
"  2. Use isort if ".isort", ".autofix", ".isort.cfg", "pyproject.toml" with
"     [tool.isort], "setup.cfg" with [isort] is in any directory at the current
"     directory or above.
"  3. Always use autoimport
"  4. Add hotkey to enable/disable fixers


function! g:UseBlack(filename)
  let dirname = fnamemodify(a:filename, ":p:h")
  let root = finddir(".git", dirname . ";")
  let searchpath = dirname . ';' . root

  if findfile('.black', searchpath) != '' 
     \ || findfile('.autofix', searchpath) != ''
    return 1
  endif

  let pyproject = findfile('pyproject.toml', searchpath)
  if pyproject != '' && match(readfile(pyproject), '[tool.black]') > -1
    return 1
  endif
endfunction


function! g:UseIsort(filename)
  let dirname = fnamemodify(a:filename, ":p:h")
  let root = finddir(".git", dirname . ";")
  let searchpath = dirname . ';' . root

  if findfile('.isort', searchpath) != ''
    \ || findfile('.autofix', searchpath) != '' 
    \ || findfile('.isort.cfg', searchpath) != ''
    return 1
  endif

  let pyproject = findfile('pyproject.toml', searchpath)
  if pyproject != '' && match(readfile(pyproject), '[tool.isort]')
    return 1
  endif

  let setupcfg = findfile('setup.cfg', searchpath)
  if setupcfg != '' && match(readfile(setupcfg), '[isort]')
    return 1
  endif
endfunction


function! g:SetupFixers(filename)
  let fixers = []
  if g:UseBlack(a:filename)
    let fixers = add(fixers, 'black')
    set textwidth=88
  endif
  if g:UseIsort(a:filename)
    let fixers = add(fixers, 'isort')
  endif
  let b:ale_fixers = fixers
endfunction


augroup fixers
  autocmd!
  autocmd FileType python call SetupFixers(expand('%'))
augroup END
