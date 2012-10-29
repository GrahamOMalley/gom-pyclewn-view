This plugin defines several functions that allow for easier use of Pyclewn.
These are:

PyclewnDebugToggle
    loads the .proj file first if one exists
    closes Tlist if open
    calls Pyclewn and sets up the window layout so there is a dgb_var window on the right and a Pyclewn console at the bottom
    OR
    destroys any Pyclewn windows and shuts down Pyclewn
    opens Tlist again

PyclewnBreakPointToggle
    turns breakpoint at line on/off, and saves the .proj file to persist bp changes

TODO:

Pyclewn(Next|Step)
    steps into or over line, if g:step_show_locals or g:next_show_locals are set also does Cinfo locals after Cstep or Cnext

Sample keymap to work with Pyclewn and this plugin:

"********************************************** CPP
augroup filetype_cpp
    autocmd!
    autocmd BufRead,BufNewFile *.cpp,*.c,*.h,*.cc let g:SuperTabDefaultCompletionType = "<c-x><c-u>"
    " PyClewn
    autocmd BufRead,BufNewFile *.cpp,*.c,*.h,*.cc let g:pyclewn_args="--gdb=async"
    autocmd BufRead,BufNewFile *.cpp,*.c,*.h,*.cc nnoremap <F2>              :exe "PyclewnDebugToggle"<CR>
    autocmd BufRead,BufNewFile *.cpp,*.c,*.h,*.cc nnoremap <F3>              :exe "Cfoldvar " . line(".")<CR>
    autocmd BufRead,BufNewFile *.cpp,*.c,*.h,*.cc nnoremap <F4>              :exe "!make"<CR>
    autocmd BufRead,BufNewFile *.cpp,*.c,*.h,*.cc nnoremap <F5>              :exe "Crun"<CR>
    autocmd BufRead,BufNewFile *.cpp,*.c,*.h,*.cc nnoremap <F6>              :exe "Ccontinue"<CR>
    autocmd BufRead,BufNewFile *.cpp,*.c,*.h,*.cc nnoremap <F7>              :exe "Cprint " . expand("<cword>") <CR>
    autocmd BufRead,BufNewFile *.cpp,*.c,*.h,*.cc nnoremap <F9>              :exe "PyclewnBreakPointToggle" <CR>
    autocmd BufRead,BufNewFile *.cpp,*.c,*.h,*.cc nnoremap <F10>             :Cnext <CR>
    autocmd BufRead,BufNewFile *.cpp,*.c,*.h,*.cc nnoremap <F11>             :Cstep <CR>
    autocmd BufRead,BufNewFile *.cpp,*.c,*.h,*.cc nnoremap <PageUp>          :exe "Cup"<CR>
    autocmd BufRead,BufNewFile *.cpp,*.c,*.h,*.cc nnoremap <PageDown>        :exe "Cdown"<CR>
    autocmd BufRead,BufNewFile *.cpp,*.c,*.h,*.cc nnoremap <leader>dl        :exe "Cinfo locals"<CR>
    autocmd BufRead,BufNewFile *.cpp,*.c,*.h,*.cc nnoremap <leader>ds        :exe "Cbt"<CR>
    autocmd BufRead,BufNewFile *.cpp,*.c,*.h,*.cc nnoremap <leader>df        :exe "Cframe"<CR>
    autocmd BufRead,BufNewFile *.cpp,*.c,*.h,*.cc nnoremap <leader>dd        :exe "Cdisassemble"<CR>
    autocmd BufRead,BufNewFile *.cpp,*.c,*.h,*.cc nnoremap <leader>dw        :exe "Cdbg " . expand("<cword>") <CR>
augroup END
