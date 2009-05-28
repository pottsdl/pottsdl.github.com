" flist.vim maps for Vim
"  Author  : Charles E. Campbell, Jr.
" Copyright: Charles E. Campbell, Jr.
" License  : refer to the <Copyright> file for flist

" Make various lists of C/C++ functions
"  \p? prototypes : \[px]g: globals   \pc: comment   \pp: all prototypes
"  \x? externs    : \[px]s: statics                  \xx: all externs
map \pc   :w<CR>:!flist -c  % >tmp.vim<CR>:r tmp.vim<CR>:!rm tmp.vim<CR>
map \pg   :w<CR>:!flist -pg % >tmp.vim<CR>:r tmp.vim<CR>:!rm tmp.vim<CR>
map \pp   :w<CR>:!flist -p  % >tmp.vim<CR>:r tmp.vim<CR>:!rm tmp.vim<CR>
map \ps   :w<CR>:!flist -ps % >tmp.vim<CR>:r tmp.vim<CR>:!rm tmp.vim<CR>
map \xg   :w<CR>:!flist -xg % >tmp.vim<CR>:r tmp.vim<CR>:!rm tmp.vim<CR>
map \xs   :w<CR>:!flist -xs % >tmp.vim<CR>:r tmp.vim<CR>:!rm tmp.vim<CR>
map \xx   :w<CR>:!flist -x  % >tmp.vim<CR>:r tmp.vim<CR>:!rm tmp.vim<CR>
