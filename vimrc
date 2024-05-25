" SPDX-FileCopyrightText: 2024 Dominik Wombacher
"
" SPDX-License-Identifier: MIT

filetype on
filetype plugin on
filetype indent on

set fileencoding=UTF-8
set syntax=on
set colorcolumn=79
set ts=2
set sw=2
set sts=2
set et nu
set cursorline
set cuc
set wildmenu
set ignorecase
set smartcase
set laststatus=2

" in makefiles, don't expand tabs to spaces, since actual tab characters are
" needed, and have indentation at 8 chars to be sure that all indents are tabs
" (despite the mappings later):
autocmd FileType make set noexpandtab shiftwidth=8 softtabstop=0
