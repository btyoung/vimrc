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
  " Plug 'davidhalter/jedi-vim'        " Use Jedi to do things
  Plug 'ervandew/supertab'           " Use tab instead of <c-x><c-o>
  Plug 'maximbaz/lightline-ale'      " ALE in status line
  Plug 'prabirshrestha/vim-lsp'
  Plug 'mattn/vim-lsp-settings'
  Plug 'rhysd/vim-healthcheck'

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

" highlight ExtraWhiteSpace ctermbg=234 guibg=#333333
" match ExtraWhiteSpace /\s\+$/

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


" =============== File-type specific handling =========================
augroup configgroup
  " Clear existing autocommands
  autocmd!

  " Specify file type for mpython files
  autocmd BufNewFile,BufRead *.mpy set filetype=python

  " Python and mpython setup
  autocmd FileType python setlocal tabstop=4
  autocmd FileType python setlocal softtabstop=4
  autocmd FileType python setlocal shiftwidth=4
  autocmd FileType python setlocal foldmethod=indent
augroup END


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

iabbrev improt import


" ========== Key Mappings and Commands =============
" Navigate windows using Shift+Arrows
" nnoremap <silent> <S-up> :wincmd k<cr>
" nnoremap <silent> <S-Down> :wincmd j<CR>
" nnoremap <silent> <S-Left> :wincmd h<CR>
" nnoremap <silent> <S-Right> :wincmd l<CR>
" nnoremap <silent> <S-k> :wincmd k<CR>
" nnoremap <silent> <S-j> :wincmd j<CR>
" nnoremap <silent> <S-h> :wincmd h<CR>
" nnoremap <silent> <S-l> :wincmd l<CR>


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
" inoremap <F7> <C-\><C-O>:ToggleAutoFix<CR>
" nnoremap <silent> <F7> :ToggleAutoFix<CR>
nnoremap <silent> fa :call ToggleAutoFix()<CR>


" =================== Commands ====================
command! SWS execute ':let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>norm!``'
command! FormatJSON %!python -m json.tool
command! ToggleHardWrap execute 'call g:ToggleHardWrap()'

" -- Personal variables to manage toggle-modes --
let g:wrapmode='c'
let g:lsp_auto_format = 1

" -- Hard Wrap Toggle --
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

" -- Autoformat Toggle --
function! g:ToggleAutoFix()
  if g:lsp_auto_format
    let g:lsp_auto_format = 0
  else
    let g:lsp_auto_format = 1
  endif
endfunction


" =============== Plugin Configuration =======================
"  ~~ Rainbow Parentheses ~~
let g:rainbow_active = 1
let g:rainbow_conf = {
  \ 'ctermfgs': ['blue', 'brown', 'yellow', 'gray', 'darkgreen'],
  \ 'operators': '_,_',
  \ 'parentheses': [
  \   'start=/(/ end=/)/ fold', 
  \   'start=/\[/ end=/\]/ fold',
  \   'start=/{/ end=/}/ fold'
  \ ],
  \ 'separately': {
  \   '*': {},
  \   'tex': {
  \     'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
  \   },
  \   'lisp': {
  \     'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3'],
  \   },
  \   'vim': {
  \     'parentheses': [
  \       'start=/(/ end=/)/',
  \       'start=/\[/ end=/\]/',
  \       'start=/{/ end=/}/ fold',
  \       'start=/(/ end=/)/ containedin=vimFuncBody',
  \       'start=/\[/ end=/\]/ containedin=vimFuncBody',
  \       'start=/{/ end=/}/ fold containedin=vimFuncBody'
  \      ],
  \   },
  \   'html': {
  \     'parentheses': [
  \       'start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'
  \     ],
  \   },
  \  }
\ }


"  ~~ Lightline status line ~~
let g:lightline = {
  \ 'colorscheme': 'jellybeans',
  \ 'active': {
  \   'left': [
  \     ['mode', 'paste'],
  \     ['readonly', 'filename', 'modified'],
  \   ],
  \   'right': [
  \     ['lsp'],
  \     ['lineinfo'],
  \     ['percent'],
  \     ['fileformat', 'fileencoding', 'filetype', 'hardwrap', 'fmts'],
  \   ],
  \ },
  \ 'component': {
  \   'percent': '%p%% of %L',
  \ },
  \ 'component_function': {
  \    'hardwrap': 'HardWrapStatus',
  \    'lsp': 'LspStatus',
  \    'fmts': 'Formatters',
  \ },
\ }

function! g:HardWrapStatus()
  if g:wrapmode == 'c'
    return 'comwrap'
  elseif g:wrapmode == 'tc'
    return '   wrap'
  elseif g:wrapmode == ''
    return 'no wrap'
  endif
endfunction

let g:server_status = {
      \ 'unknown server': '?',
      \ 'exited': '[x]',
      \ 'starting': '...',
      \ 'failed': '!',
      \ 'running': '',
      \ }

function! g:LspStatus() abort
  let l:server_names = lsp#get_allowed_servers(bufnr('%'))

  if len(l:server_names) ==# 0
    return ''
  endif

  let l:status_str = ''
  for l:server_name in l:server_names
    let l:status = lsp#get_server_status(l:server_name)
    let l:status_str = l:status_str . " " . l:server_name 
      \ . g:server_status[l:status] . " "
  endfor

  let l:counts = lsp#get_buffer_diagnostics_counts()
  if l:counts['error'] ==# 0 && l:counts['warning'] ==# 0
    let l:status_str = l:status_str . 'OK'
  else
    let l:status_str = l:status_str . 'E:' . l:counts['error']
        \ . ' W:' . l:counts['warning']
  endif

  return l:status_str
endfunction

function! g:Formatters()
  if !g:pylsp_cafmt
    return (g:lsp_auto_format ? 'auto' : 'man')
  endif

  let l:fmts = ''
  if exists('b:cafmts')
    let l:fmts = join(map(b:cafmts, 'v:val[0]'), '')
  endif

  if l:fmts !=# ''
    return (g:lsp_auto_format ? 'auto' : 'man') . '[' . l:fmts . ']'
  else
    return 'nofix'
  endif
endfunction


" === LSP settings ===
if executable('pylsp')
  autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'pylsp',
        \ 'allowlist': ['python'],
        \ 'cmd': {server_info->['pylsp']},
        \ 'workspace_config': {
        \   'pylsp': {'plugins': {'flake8': {'enabled': v:true}}}
        \ },
        \ })
endif


function! s:set_up_cafmt() abort
  function! s:handle_cafmt_query(bufnr, data)
    let l:response = get(a:data, 'response', {})
    if get(l:response['result'], 'linelength', 0) !=# 0
      call setbufvar(a:bufnr, 'textwidth', l:response['result']['line-length'])
    endif
    call setbufvar(a:bufnr, 'cafmts', l:response['result']['formatters'])
  endfunction

  command! CafQuery call lsp#send_request('pylsp', {
        \ 'method': 'workspace/executeCommand',
        \ 'params': {
        \     'command': 'cafmt.query',
        \     'arguments': {
        \         'doc_uri': lsp#utils#get_buffer_uri(bufnr('%')),
        \     },
        \ },
        \ 'sync': 0,
        \ 'on_notification': function('s:handle_cafmt_query', [bufnr('%')]),
        \ })

  command! CafCycle call lsp#send_request('pylsp', {
        \ 'method': 'workspace/executeCommand',
        \ 'params': {
        \     'command': 'cafmt.cycle',
        \     'arguments': {
        \         'doc_uri': lsp#utils#get_buffer_uri(bufnr('%')),
        \     },
        \ },
        \ 'sync': 1,
        \ 'on_notification': function('s:handle_cafmt_query', [bufnr('%')]),
        \ })

  command! -nargs=1 CafApply call lsp#send_request('pylsp', {
        \ 'method': 'workspace/executeCommand',
        \ 'params': {
        \     'command': 'cafmt.apply',
        \     'arguments': {
        \         'doc_uri': lsp#utils#get_buffer_uri(bufnr('%')),
        \         'format': <f-args>,
        \     },
        \ },
        \ 'sync': 0,
        \ 'on_notification': function('s:handle_cafmt_query', [bufnr('%')]),
        \ })
endfunction



function! s:autoformat()
  if g:lsp_auto_format
    call execute('LspDocumentFormatSync')
  endif
endfunction

function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes
  if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
  nmap <silent> <buffer> ff :call execute('LspDocumentFormat')<CR>
  nmap <buffer> gd <plug>(lsp-definition)
  nmap <buffer> gs <plug>(lsp-document-symbol-search)
  nmap <buffer> gS <plug>(lsp-worskspace-symbol-search)
  nmap <buffer> gr <plug>(lsp-references)
  nmap <buffer> gi <plug>(lsp-implementation)
  nmap <buffer> gt <plug>(lsp-type-definition)
  nmap <buffer> <leader>rn <plug>(lsp-rename)
  nmap <buffer> [g <plug>(lsp-previous-diagnostic)
  nmap <buffer> ]g <plug>(lsp-next-diagonstic)
  nmap <buffer> K <plug>(lsp-hover)
  nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
  nnoremap <buffer> <expr><c-d> lsp#scroll(-4)

  call s:detect_pylsp_cafmt()
  if g:pylsp_cafmt
    call execute('CafQuery')
    nmap <silent> <buffer> fc :call execute('CafCycle')<CR>
    nmap <silent> <buffer> fb :call execute('CafApply black')<CR>
    nmap <silent> <buffer> fi :call execute('CafApply isort')<CR>
  endif

  let g:lsp_format_sync_timeout = 1000
  " autocmd! BufWritePre *.py,*.mpy call s:autoformat()
  autocmd! BufWritePre * call s:autoformat()
 " execute('LspDocumentFormatSync)

endfunction

let g:pylsp_cafmt = v:null
function! s:detect_pylsp_cafmt() 
  if g:pylsp_cafmt is v:null
    let l:cap = lsp#get_server_capabilities('pylsp')
    if len(l:cap) >= 0
      let l:cmds = get(l:cap['executeCommandProvider'], 'commands', [])
      let g:pylsp_cafmt = len(filter(l:cmds, 'v:val[:5] ==# "cafmt."')) > 0
      if g:pylsp_cafmt
        call s:set_up_cafmt()
      endif
    endif
  endif
endfunction

let g:lsp_diagnostics_enabled=1
" Echo shows to status line, float shows a window, virtualtext shows in-line
let g:lsp_diagnostics_echo_cursor=1
let g:lsp_diagnostics_echo_delay=150
let g:lsp_diagnostics_float_cursor=0
let g:lsp_diagnostics_highlights_enabled=0
let g:lsp_diagnostics_signs_enabled=1
let g:lsp_diagnostics_signs_delay=150
let g:lsp_diagnostics_virtual_text_enabled=0
let g:lsp_diagnostics_virtual_text_delay=150
let g:lsp_diagnostics_virtual_text_prefix='#> '
let g:lsp_diagnostics_virtual_text_align='after'
let g:lsp_diagnostics_virtual_text_wrap='truncate'
let g:lsp_diagnostics_virtual_text_padding_left=2
let g:lsp_inlay_hints_enabled=1
let g:lsp_show_message_log_level='log'
let g:lsp_log_file=expand('~/vim-lsp.log')

augroup lsp_install
  au!
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
