" VIM functions/macros file
" File:             functions.vim
" From:             http://www.multimania.com/phic/vim/index.html
" Last modified:    08-Sep-2005 10:36
" Modification history:
" 23-Mar-2000 pottsdl   Fixed check for existing diffs.tx buffer in DiffP
"                       function.
"-
" -----------------------------------------------------------------------------
" Phil's collection of vim functions
" -----------------------------------------------------------------------------
" Last Edit:    04-Aug-1999 08:54 AM
" vim:ts=4:sw=4:
" rcs:$Id: functions.vim,v 2.5 1999/02/09 14:12:08 phil Exp $
" -----------------------------------------------------------------------------

" =============================================================================
function! ShowManPage(whichpage)
" ShowManPage: function to show a man page
" the parameter is the page to show
" -----------------------------------------------------------------------------
        " modify the shortmess option:
        " A             don't give the "ATTENTION" message when an existing swap file is
        "               found.
        set shortmess+=A

        " if a buffer already exists delete it
        if bufexists("/manual\ page")
                bd! /manual\ page
        endif

        " create a new one
        new /manual\ page

        " read the man page in
        execute 'r!man ' a:whichpage '| col -b'

        " highlight it
        "source ~phil/.vim/manpages.vim
        "source $VIM/syntax/manpages.vim
        source $VIMRUNTIME/syntax/man.vim

        " set some options
        set ts=8
        set nomodified

        " go to the beginning of the buffer
        execute "normal 1G"

        " restore the shortmess option
        set shortmess-=A
endfunction "ShowManPage

" =============================================================================
function! ShowManPageCursor()
" functions to show a man page
" - ShowManPageCursor: of the word under the cursor
" - ShowManPageInput:  ask the user which page
" -----------------------------------------------------------------------------
        " get the word under the cursor
        let whichpage = expand("<cword>")

        call ShowManPage(whichpage)
endfunction "ShowManPageCursor

" ============================================================================= 
function! ShowManPageInput()
" -----------------------------------------------------------------------------
        " ask the user which page he wants
        let whichpage = input("man: ")

        call ShowManPage(whichpage)
endfunction "ShowManPageInput

" =============================================================================
function! ReadCommandInBuffer(bufferName, cmdName) " ReadCommandInBuffer
" - bufferName is the name which the new buffer with the command results
"   should have
" - cmdName is the command to execute
" -----------------------------------------------------------------------------
        " modify the shortmess option:
        " A             don't give the "ATTENTION" message when an existing swap file is
        "               found.
        set shortmess+=A

        " get the name of the current buffer
        let currentBuffer = bufname("%")

        " if a buffer with the name rlog exists, delete it
        if bufexists(a:bufferName)
                execute 'bd! ' a:bufferName
        endif

        " create a new buffer
        execute 'new ' a:bufferName

        " execute the rlog command
        execute 'r!' a:cmdName ' ' currentBuffer

        set nomodified

        " go to the beginning of the buffer
        execute "normal 1G"

        " restore the shortmess option
        set shortmess-=A
endfunction "ReadCommandInBuffer

" =============================================================================
function! ShowLog(bufferName, cmdName)
" ShowLog
" show the log results of the current file with a revision control system
" -----------------------------------------------------------------------------
        call ReadCommandInBuffer(a:bufferName, a:cmdName)

        " highlight it
        source ~phil/.vim/rlog.vim
endfunction "ShowLog

" =============================================================================
function! ShowDiff(bufferName, cmdName)
" ShowDiff
" show the diffs of the current file with a revision control system
" -----------------------------------------------------------------------------
        call ReadCommandInBuffer(a:bufferName, a:cmdName)

        " highlight it
        source $VIM/syntax/diff.vim
endfunction "ShowDiff

" =============================================================================
function! SwitchCH()
" SwitchCH
" switches between a C or C++ source file to the header or back
" We assume that there is no 'C' file with both a 'h' and a 'H' header
" -----------------------------------------------------------------------------
        " get the extension of the current file
        let currentExtension = expand("%:e")

        let currentFileWOExt = expand("%:r")
        let currentFileWOExtNorPath = expand("%:t:r")

        let cmdOpenBuffer = "buffer "
        if v:version < 504
                let cmdOpenFile = "edit "
        else
                let cmdOpenFile = "find "
        endif

        " now we look at the extension and try to open the appropriate file
        if currentExtension == "c" || currentExtension == "C"
                if bufexists(currentFileWOExt . ".h")
                        execute cmdOpenBuffer . currentFileWOExtNorPath . ".h"

                elseif bufexists(currentFileWOExt . ".H")
                        execute cmdOpenBuffer . currentFileWOExtNorPath . ".H"

                elseif filereadable(currentFileWOExt . ".h")
                        execute cmdOpenFile . currentFileWOExt . ".h"
                elseif filereadable(currentFileWOExt . ".H")
                        execute cmdOpenFile . currentFileWOExt . ".H"

                endif
        elseif currentExtension == "h" || currentExtension == "H"
                if bufexists(currentFileWOExt . ".c")
                        execute cmdOpenBuffer . currentFileWOExtNorPath . ".c"

                elseif bufexists(currentFileWOExt . ".C")
                        execute cmdOpenBuffer . currentFileWOExtNorPath . ".C"

                elseif filereadable(currentFileWOExt . ".c")
                        execute cmdOpenFile . currentFileWOExt . ".c"

                elseif filereadable(currentFileWOExt . ".C")
                        execute cmdOpenFile . currentFileWOExt . ".C"

                endif
                
        endif
endfunction "SwitchCH

" ***********************************************************************
" ***********************************************************************
"                          End of Philippe's Section
" ***********************************************************************
" ***********************************************************************

" ===========================================================================
fu! FindFunc()
" Description:  search for "heading" information associated with the syntax
" of supported filetypes, and display on the status line, while keeping the last
" search patttern.
" For example:  in a C file, relevant "heading" info. is the function name of
" the code block (defined by {}) that you are currently in.
" Inputs:       None.
" Outputs:      None.
"----------------------------------------------------------------------------
    let ftype=&ft       " Determine filetype
    let old_srch=@/     " Save old search pattern
    " based on filetype setup search pattern
    " remember for patterns '\' needs to be escaped.
    if ftype == "kl" || ftype == "pdl"
        let s_pat = "^BEGIN"
        "let s_pat2 = "^\\k.* "
        let s_pat2 = "^routine"
    elseif ftype == "c" || ftype == "cpp"
        let s_pat = "^{"
        let s_pat2 = "^\\k.*("
    elseif ftype == "edd"
        let s_pat = "^\\h*_T\\s*=\\s*<"
    elseif ftype == "dict"
        let s_pat = "^$.,"
    elseif ftype == "dt"
        let s_pat = "^CELL"
        "let s_pat2= "^\\k.* "
    else
        echo "Unknown filetype!"
        return
    endif

    if exists("s_pat")
        " Do search, find line, echo to statusline
        if exists("s_pat2")
            exe ":?".s_pat."??".s_pat2."? mark k"
        else
            exe ":?".s_pat."? mark k"
        endif
        exe ":echo getline(\"'k\")"
    endif
    let @/=old_srch
endf

" ===========================================================================
fu! OpenIfNew( name )
" I used the same logic in several functions, checking if the buffer was
" already around, and then deleting and re-loading it, if it was.
" -----------------------------------------------------------------------------
  " Find out if we already have a buffer for it
  let buf_no = bufnr(expand(a:name))

  " If there is a diffs.tx buffer, delete it
  if buf_no > 0
    if version < 600
      exe 'bd! '.a:name
    else
      exe 'bw! '.a:name
    endif
  endif
  " (Re)open the file (update).
  exe ':sp '.a:name
endf

" ===========================================================================
fu! DiffP( fname, ask_version )
" Do a diff with filename on line under cursor with its cleartool predecessor,
" store results in tmp/diffs.tx, and split open diffs.tx
" 01-Oct-1999 pottsdl   Modified to task ask_version param.
"                       if 0, then use predecessor as compare to.
"                       if 1, then use that version as compare to.
" ---------------------------------------------------------------------------
  " Build diff statement
  " diff <-switches> filename filename+@@+version(filename) > temp_diff_file
  let diff_switch=':!diff -btw -C3 '
  let outpath='~/tmp/'
  let outname='diffs.tx'
  let outfile=outpath.outname
  if (a:ask_version != 0)
    let cmp_to_ver = ""
    while (cmp_to_ver == "")
      let cmp_to_ver = input("Give version to compare to: ")
    endwhile
    exe diff_switch.a:fname.' '.a:fname.'@@'.cmp_to_ver.' > '.outfile
  else
    echo "Comparing to predecessor..."
    let cmp_to_ver = '`cleartool des -s -pre '.a:fname.'`'
    let debug=expand(cmp_to_ver)
    echo "Predecessor version: ". debug
    "echo "Predecessor file:    ".a:fname.'@@'.expand(cmp_to_ver)
    "let foo=input("OK?: ")
    exe diff_switch.a:fname.'@@'.cmp_to_ver.' '.a:fname.' > '.outfile
  endif

  " Find out if we already have a buffer for it
  let buf_no = bufnr(expand(outname))

  " If there is a diffs.tx buffer, delete it
  if buf_no > 0
      exe 'bd! '.outname
  endif
  " (Re)open the diffs.tx file to see diffs (update).
  exe ':sp '.outfile
endf

" ===========================================================================
fu! Generic_cap( type, kyword )
" Modification history:
" 15-Mar-2000 pottsdl   Consolidated Svcap, Builtin_cap, adn Rjcap into ONE
"                       function.
" ---------------------------------------------------------------------------
  if a:type == "builtin"
    let excstrg = "!built_in ".a:kyword." ".&shellpipe." ~/tmp/results.txt"
  elseif a:type == "svar"
    let excstrg = "!svcap ".a:kyword
  elseif a:type == "rj"
    let excstrg = "!rjcap ".a:kyword
  else
    echo "Unknown cap type..."
    return
  endif

  exe excstrg
  " Find out if we already have a buffer for it
  let buf_no = bufnr("results\.txt")

  " If there is a buffer, delete it
  if buf_no > 0
      bd! ~/tmp/results.txt
  endif
  " (Re)open the diffs.tx file to see diffs (update).
  exe ':sp ~/tmp/results.txt'
endf
nn ,bt :call Generic_cap("builtin","<C-R>=expand('<cword>')<cr>")<CR><CR>
nn ,sv :call Generic_cap("svar","<C-R>=expand('<cword>')<CR>")<CR><CR>

" ===========================================================================
function! PadR(number) range abort
" Description: Space pads lines to 80 characters.
" From:        990723 JSpetz@calvin.idpnet.com mail to vim list
" Regarding:          Request for improvements to a vim user function, PadR()
" TODO: Find a way to build the space string instead of having that stupid
" long line.
" Modification history:
" 23-Feb-2000 pottsdl   Added ability to pass in param for padding.
" ---------------------------------------------------------------------------
  let hold_ch=&ch
  let &ch=3
  if a:number != 0
    echo "Setting num_spc=".a:number
    let num_spc=a:number
  else
    echo "Setting num_spc=80"
    let num_spc=80
  endif

  " The below is a string of 80 space characters
  let loop=1
  let s = ' '
  while loop <  num_spc
    let s = s.' '
    let loop = loop + 1
  endwhile
  "let s='                                                                                '

  let i=a:firstline
  while i <= a:lastline
    let t = getline(i)
    "if strlen(t) < 80
    if strlen(t) < num_spc
      let t = t . s
      "let t = strpart(t, 0 ,80)
      let t = strpart(t, 0 , num_spc)
      call setline(i,t)
    endif
    let i = i + 1
  endwhile
  exe 'let &ch=' . hold_ch
endfunction

" ===========================================================================
fu! Delineate(line_char)
" Delinate code, start out a separation marker from current indent
" and extend out to textwidth
" ---------------------------------------------------------------------------
  if a:line_char == ""
    let line_char = "-"
  else
    let line_char = a:line_char
  endif

  " Use this to get current indent
  exe 'normal ox'
  let curcol=col(".")
  let currow=line(".")
  
  " Default to 80 char width if no textwidth
  if &tw < 1
    let numchars = 80 - curcol
  else
    let numchars= &tw - curcol
  endif

  " Init tmpstr so it has indent in it
  let linestr = getline(currow)
  let tmpstr = strpart(linestr, 0, strlen(linestr)-1)

  let charcnt = 1
  while charcnt <= numchars
    let tmpstr = tmpstr.line_char
    let charcnt = charcnt + 1
  endw

  call setline(currow, tmpstr)
endfu
nmap ,dl :call Delineate("=")<cr>

" ===========================================================================
fu! Comm2Srch()
" Create a regular expression string that OR's together all of the possible
" comment combinations based on &comments, and return it
" ---------------------------------------------------------------------------
  " Store comments string
  let cmnt=&comments
  " Get rid of formatting stuff, up to :, and
  " change the comma to an expression OR
  "s/[nbfs1mex]*:\([^,]*\),/\1\\|
  let tmp = substitute(cmnt, '[nbfs1mex]*:\([^,]*\),*', '\1\\|', 'g')
  " Now escape *, /, and \
  "s+\(\*\|/\|\\[^|]\)+\\\0+g
  let pat = substitute(tmp, '\(\*\|/\|\\[^|]\)', '\\\0', 'g')

  return(pat)
  "map \<tab> :s/\(\*\)\( \{<c-r>=&shiftwidth<cr>}\)\(.*$\)/\1\2\2\3
  "map \<tab> :s/\(<c-r>=pat<cr>\)\( \{<c-r>=&shiftwidth<cr>}\)\(.*$\)/\1\2\2\3
endf "Comm2Srch

" ===========================================================================
fu! CommWrappr()
" Use &comment from Comm2Srch to indent the text part of a normal
" modification history.
" ---------------------------------------------------------------------------
  let hold_ch=&ch
  let &ch=2
  " Find a comment, indentation match, and regular text to EOL
  " indent it by replacing with:  comment, 2 copies of indentation, and then
  " the rest
  "exe "s/^\\(\\s*\\(".Comm2Srch()."\\)\\)\\( \\{".&shiftwidth."}\\)\\(.*$\\)/\\1\\3\\3\\4"
  exe "s/^\\(\\s*\\(".Comm2Srch()."\\)\\)\\( \\)\\(.*$\\)/\\1\\3\\3\\3\\3\\4"
  exe 'let &ch='.hold_ch
endf "CommWrappr

" ===========================================================================
fu! TemplateHandler()
" - Check if a template exists in the templates directory for the given new
"   file's extension.
" - If it does, read it into the new file.
" - Source in Stephen Riehm's Bracketing macros.
" 11-Apr-2000 pottsdl   expanded to handle Windoze as well as Unix
" ---------------------------------------------------------------------------
  " Bypass template handling for my weekly status reports, it would
  " double trigger, once for status_template.html and once for template.html
  if expand("%:t") !~ "week_of_.*" || exists("notemplates")
    let fileis = expand("$TEMPLATES")."/template.".expand("%:t:e")
    if filereadable(fileis)
      exe '0r $TEMPLATES/template.%:t:e'

      " " If a PDL file, Greg has setup to use < instead of �
       if expand("%:t:e") == "pdl"
         exe '%s/�\s*name\s*�/'.expand("%:t")
         let sdf=substitute(expand("%:p"),'\/vobs\/\(\h\+\/design\).*$', '\1', 'g')
         exe '%s+<\s*sdf\s*>+'.sdf
       endif
       exe '%s/�\s*Date\s*�/'.strftime("%d-%b-%Y")
       exe '%s/�\s*Author\s*�/Douglas L. Potts'
      " else
        " exe '%s/<\s*date\s*>/'.strftime("%d-%b-%Y")
        " exe '%s/<\s*author\s*>/Douglas L. Potts'
        " exe '%s/<\s*name\s*>/'.expand("%:t")
        " exe '%s/\<DD\/MM\/YY.*$/'.strftime("%d-%b-%y").' ####        dlp      Created.'
      " endif
      if has("gui_running")
        if has("unix")
          SrcIfReadable $VIM/mymacro/bracketing.no-meta.vim
        else
          SrcIfReadable $UVIM\\\\mymacro\\\\bracketing.meta.vim
        endif
      else
        if has("unix")
          SrcIfReadable $VIM/mymacro/bracketing.no-meta.vim
        else
          SrcIfReadable $UVIM\\\\mymacro\\\\bracketing.no-meta.vim
        endif
      endif
    endif
  endif
endf "TemplateHandler

" vim:tw=0:
