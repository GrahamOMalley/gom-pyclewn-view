" File: gom-pyclewn-view.vim
" Author: Graham O' Malley
" Description: Some useful functions to toggle pyclewn debugger (with syntax
" highlighted watch window and dgb console) as well as options to control step
" output (toggle printing locals when stepping)
" Last Modified: October 29, 2012

" TODO: integrate Valgrind somehow, keymap, buffer plugin?

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
command! PyclewnBreakPointToggle call PyclewnBreakPointToggle()

" I have this mapped to F2, maybe some kind of smart F5 mapping would be
" better? 
function! PyclewnDebugToggle()
    "Toggle the flag (or set it if it doesn't yet exist)...
    let g:gom_debug_view_on = exists('g:gom_debug_view_on') ? !g:gom_debug_view_on : 0

    " g:gom_debug_view_on has just been toggled
    if !g:gom_debug_view_on
        :echo "debug view is ON, stopping debug view"
        call PyclewnDebugStop()
    else
        :echo "debug view is OFF, starting debug view"
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
    " TODO  vsplit sizes look different depending on terminal and screen res,
    " this could be a plugin var
    :rightbelow 190vsplit (clewn)_dbgvar
    :set syntax=cpp
    :wincmd h
    " return to main window
endfunction

" Functions that allow stepping with locals being printed out on each step,
" can turn this on and off as sometimes its slow for large data structures
function! PyclewnLocalsToggle()
    let g:pyclewn_locals_on = exists('g:pyclewn_locals_on') ? !g:pyclewn_locals_on : 0
    if g:pyclewn_locals_on 
        :exe "Cinfo locals"
    endif
endfunction
command! PyclewnLocalsToggle call PyclewnLocalsToggle()

function! PyclewnNext()
    :exe "Cnext"
    let g:pyclewn_locals_on = exists('g:pyclewn_locals_on') ? g:pyclewn_locals_on : 0
    if g:pyclewn_locals_on 
        :exe "Cinfo locals"
    endif
endfunction
command! PyclewnNext call PyclewnNext()

function! PyclewnStep()
    :exe "Cstep"
    let g:pyclewn_locals_on = exists('g:pyclewn_locals_on') ? g:pyclewn_locals_on : 0
    if g:pyclewn_locals_on 
        :exe "Cinfo locals"
    endif
endfunction
command! PyclewnStep call PyclewnStep()

" I like having Tlist open automatically for certain filetypes, but it looks
" weird in debugger layout and I don't really need it
function! PyclewnToggleTlist()
    let g:gom_debug_view_on = exists('g:gom_debug_view_on') ? g:gom_debug_view_on : 0
    if !g:gom_debug_view_on
        :echo "debug mode is OFF, opening tlist for file"
        :execute "TlistOpen"
        :wincmd l
    endif
endfunction
command! PyclewnToggleTlist call PyclewnToggleTlist()
