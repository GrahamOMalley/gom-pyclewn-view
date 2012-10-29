

" TODO: integrate Valgrind somehow, keymap, buffer plugin?

function! PyDebugToggle()
    "Toggle the flag (or set it if it doesn't yet exist)...
    let w:python_debug_view_on = exists('w:python_debug_view_on') ? !w:python_debug_view_on : 0

    if w:python_debug_view_on
        :execute "Dbg quit"
    else
        silent! :execute "Dbg ."
    endif
endfunction

" annoyingly Pyclewn doesn't support this 'out of the box'
" I'll cheat a little in this function; as I have forced a save/load of the
" .proj file everytime a breakpoint is set/cleared, I can use this file to
" check if a line should be break or cleared
function! PyclewnBreakPointToggle()

    " read our .proj file, get list of lines containing bps
    "diff against current line
    let s:breakpoint_on = 0
    for fline in readfile(".proj")
        let fields = split(fline, ':', 1)
        if len(fields) == 2
            if fields[1] == line(".")
                let s:breakpoint_on = 1
            endif
        endif
    endfor


    if s:breakpoint_on
        " clear and save
        :exe "Cclear " . expand("%:p") . ":" . line(".")
        :exe "Cproject .proj"
    else
        " break and save proj
        :exe "Cbreak " . expand("%:p") . ":" . line(".")
        :exe "Cproject .proj"
    endif
endfunction
"command! PyclewnBreakPointToggle call PyclewnBreakPointToggle()
command! -nargs=0 -bar PyclewnBreakPointToggle call s:PyclewnBreakPointToggle()

function! PyclewnDebugToggle()
    "Toggle the flag (or set it if it doesn't yet exist)...
    let g:gom_debug_view_on = exists('g:gom_debug_view_on') ? !g:gom_debug_view_on : 0

    if g:gom_debug_view_on
        call PyclewnDebugStop()
    else
        call PyclewnDebugStart()
    endif
endfunction
command! PyclewnDebugToggle call PyclewnDebugToggle()

" shut down debugger
function! PyclewnDebugStop()
    :wincmd k
    :wincmd h
    :only
    " remove console and dbgvar buffers from previous session
    if bufexists("(clewn)_console")
        bwipeout (clewn)_console
    endif
    if bufexists("(clewn)_dbgvar")
        bwipeout (clewn)_dbgvar
    endif
    :nbclose
    :TlistOpen
    :wincmd l
endfunction

" function to start debugger, rearrange window layout with watch window and
" gdb console
function! PyclewnDebugStart()
    " close Tlist if open

    :execute "TlistClose"
    " start the debugger, 
    silent! :execute "Pyclewn"
    " load the .proj file,
    :execute "Csource .proj"
    " load the _dbgr buffer
    silent! :execute "Cdbgvar"
    :execute "only"

    " layout 1
    " console
    :botright 20split (clewn)_console
    :set syntax=cpp
    :wincmd k
    " TODO this screws up on different boxes
    :rightbelow 190vsplit (clewn)_dbgvar
    :set syntax=cpp
    :wincmd h
    " return to main window
endfunction
