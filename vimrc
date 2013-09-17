" Load pathogen
runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()

set tabstop=4       " Set tab length to 4 spaces
set shiftwidth=4    " Set indent length to 4 spaces when pressing << or >>
set expandtab       " Replace tab with spaces
set smarttab        " Delete 4 spaces with one backspace in blank lines

set nu              " Show line number
syntax on           " Syntax highlight

" Filetype detection, plugin files and indent files for specific file types 
filetype plugin indent on

" Highlight the 80th column as max line length and set color
set colorcolumn=80
highlight ColorColumn ctermbg=DarkGray

" Highlight the column cursor stands for indent checking and set color
set cursorcolumn
highlight CursorColumn ctermbg=DarkGray

set ignorecase      " Case-insensitive search
set smartcase       " Case-sensitive search if any caps
set hls             " Highlight searched text


"=============================================================================
" Function Key Mappings
"=============================================================================

" Toggle NERDTree window
map <F4> :NERDTreeToggle<CR>

" Toggle MRU window
map <F5> :MRU<CR>

" Toggle line number
map <F6> :set number!<CR>

" Run current script
map <F8> :call RunSrc()<CR>

" Define RunSrc()
func RunSrc()
exec "w"
if &filetype == 'c'
exec "!astyle --style=ansi --one-line=keep-statements -a --suffix=none %"
elseif &filetype == 'cpp' || &filetype == 'hpp'
exec "r !astyle --style=ansi --one-line=keep-statements -a --suffix=none %> /dev/null 2>&1"
elseif &filetype == 'perl'
exec "!astyle --style=gnu --suffix=none %"
elseif &filetype == 'py'||&filetype == 'python'
exec "!python %"
elseif &filetype == 'java'
exec "!astyle --style=java --suffix=none %"
endif
exec "e! %"
endfunc

" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction

" Always show the status line
set laststatus=2

" Format the status line
set statusline=\ %{HasPaste()}%F%m%r%h\ %w

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

" Delete trailing white space on save, useful for Python and CoffeeScript ;)
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
autocmd BufWrite *.py :call DeleteTrailingWS()
autocmd BufWrite *.coffee :call DeleteTrailingWS()

" Turn on paste mode when pasting and turn off after that
let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

func! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunc

"=============================================================================
" Plugin settings
"=============================================================================

" ctags
" Auto find tags file in current project folder
set tags=tags;/

" syntastic
let g:syntastic_auto_loc_list=1 " open error location list automaticly
let g:syntastic_python_checkers=['flake8'] " set syntastic checker to flake8

"=============================================================================
" Insert Mode Ctrl Key Mappings
"=============================================================================

" Ctrl-e: Go to end of line
inoremap <c-e> <esc>A
" Ctrl-a: Go to begin of line
inoremap <c-a> <esc>I
