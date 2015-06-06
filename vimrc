" Documentation
" Show environmen variables picked up by vim
" :echo &t_Co

" Environment {

    " Identify platform {
        silent function! LINUX()
            return has('unix') && has('macunix') && has('win32unix')
        endfunction
        silent function! WINDOWS()
            return (has('win16') || has('win32') || has('win64'))
        endfunction
        silent function! OSX()
            return has('macunix')
        endfunction
	" }

	" Basics {
		set nocompatible
	" }

    " Windows Compatible {
        " On Windows, also use '.vim' instead of 'vimfiles'; this makes synchronization
        " across (heterogeneous) systems easier.
        if WINDOWS()
          set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
        endif
    " }

" }

" quickfixes
set t_Co=256


" Use bundles config {

    if filereadable(expand("~/.vim/vimrc.bundles"))
        source ~/.vim/vimrc.bundles
    endif

" }

" General {

    set background=dark         " prefer dark background
    filetype plugin indent on	" automatically detect file types
    syntax on                   " syntax highlightning on
    set mouse=a                 " automatically enable mouse usage
    set mousehide               " hide the mouse cursor while typing
    scriptencoding utf-8
    set virtualedit=onemore     " allow cursor beyond last character on line

" }

" Vim UI {
    
    if filereadable(expand("~/.vim/bundle/vim-colors-solarized/colors/solarized.vim"))    
        let g:solarized_termcolors=256
        let g:solarized_termtrans=1
        let g:solarized_contrast="normal"
        let g:solarized_visibility="normal"
        color solarized
    endif
"    if filereadable(expand("~/.vim/bundle/vim-vividchalk/colors/vividchalk.vim"))    
"        color vividchalk
"    endif

    set showmode
    set cursorline

    set number                  " display line number
    set showmatch

    set visualbell t_vb=        " turn off visual bell and bell

" }

" Formatting {

	set nowrap
	set autoindent
	set shiftwidth=4		" use indents of 4 spaces
	set expandtab			" tabs are spaces, not tabs
    set tabstop=4
    set softtabstop=4
    set splitright                  " put hsplit right of the current
    set splitbelow                  " put vsplit below the current

    autocmd FileType haskell setlocal expandtab shiftwidth=2 softtabstop=2

" }

