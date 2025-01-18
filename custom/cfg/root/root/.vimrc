" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Show the cursor position all the time
set ruler

" Display the mode you're in
set showmode

" Do not save backup files cluttering our directories
set nobackup

" Keep 250 lines of command line history
set history=250

" Handle multiple buffers better
set hidden

" Enhanced command line completion
set wildmenu

" Complete files like a shell.
set wildmode=list:longest

" Display incomplete commands
set showcmd

" Search as you type
set incsearch

" Don't use Ex mode, use Q for formatting
map Q gq

" Intuitive backspacing
set backspace=indent,eol,start

" Proper indentation
set tabstop=4
set shiftwidth=4
set expandtab

" Allow per file config
set modeline

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Always set autoindenting on
set autoindent

" Enable file type detection
" Use the default filetype settings, so that mail gets 'tw' set to 72,
" 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
filetype plugin indent on

" For all text files set 'textwidth' to 78 characters.
if has('autocmd')
    augroup vimrcEx
        autocmd!
        autocmd FileType text setlocal textwidth=78
    augroup END
endif

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
" Also don't do it when the mark is in the first line, that is the default
" position when opening a file.
if has('autocmd')
    augroup RememberLastPosition
        autocmd!
        autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
    augroup END
endif

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(':DiffOrig')
    command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis
endif

" Load fzf plugin if we can find it
set rtp+=/usr/local/opt/fzf

" This if will only be true when eval is supported, which is needed for defining variables and functions
if 1
    " Alphabet for the base64encode() function
    let s:base64_alphabet = [
        \ 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H',
        \ 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
        \ 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X',
        \ 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
        \ 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n',
        \ 'o', 'p', 'q',' r', 's', 't', 'u', 'v',
        \ 'w', 'x', 'y', 'z', '0', '1', '2', '3',
        \ '4', '5', '6', '7', '8', '9', '+', '/' ]

    " Function for encoding the given text as base64
    function! s:base64encode(text)
        let bytes = map(range(len(a:text)), 'char2nr(a:text[v:val])')
        let base64 = []
        for i in range(0, len(bytes) - 1, 3)
            let n = bytes[i] * 0x10000
            let n = bytes[i] * 0x10000
                \ + get(bytes, i + 1, 0) * 0x100
                \ + get(bytes, i + 2, 0)
            call add(base64, s:base64_alphabet[n / 0x40000])
            call add(base64, s:base64_alphabet[n / 0x1000 % 0x40])
            call add(base64, s:base64_alphabet[n / 0x40 % 0x40])
            call add(base64, s:base64_alphabet[n % 0x40])
        endfor
        if len(bytes) % 3 == 1
            let base64[-1] = '='
            let base64[-2] = '='
        endif
        if len(bytes) % 3 == 2
            let base64[-1] = '='
        endif
        return join(base64, '')
    endfunction

    " Function for sending text to the clipboard using a OSC52 escape sequence
    function! OSC52()
        let osc52 = "\e]52;c;" . s:base64encode(@0) . "\x07"

        if has('nvim')
            call chansend(v:stderr, osc52)
        elseif filewritable('/dev/fd/2') == 1
            call writefile([osc52], '/dev/fd/2', 'b')
        else
            exec('silent! !echo ' . shellescape(osc52))
            redraw!
        endif
    endfunction

    " Send yanked text to the terminal using OSC52
    if has('autocmd')
        augroup OSC52Yank
            autocmd!
            autocmd TextYankPost * if v:event.operator ==# 'y' | call OSC52() | endif
        augroup END
    endif
else
    " Use the system clipboard as fallback when we cannot set up OSC52
    set clipboard^=unnamed,unnamedplus
endif

