" VIM functions/macros file
" File:             al_funcs.vim
" Last modified:    08-Sep-2005 10:35
" Commentify :      A generic function for vim5.2
" allan.kelly@ed.ac.uk 07th September 1998
" Intended for use through a simple wrapper + keybinding. See CommentifyC at the
" end for an example.

"============================================================================== 

fu! InsertLine ( linenum, linestring )
   exe 'normal' . ":" . a:linenum . "insert\<CR>" . a:linestring . "\<CR>.\<CR>"
endf "InsertLine

"============================================================================== 

fu! AppendLine ( linenum, linestring )
   exe 'normal' . ":" . a:linenum . "append\<CR>" . a:linestring . "\<CR>.\<CR>"
endf "AppendLine

"============================================================================== 

fu! SubstLine ( linenum, pat, rep, flags )
   let thislineStr = getline( a:linenum )
   let thislineStr = substitute( thislineStr, a:pat, a:rep, a:flags )
   call setline( a:linenum, thislineStr )
endf "SubstLine

"============================================================================== 

fu! Commentify ( b_comment, opencomm, closecomm, midcomm, firstln, lastln )
   if a:b_comment
      let midline = a:firstln
      while midline <= a:lastln
         call SubstLine ( midline, '^.*$', a:midcomm . '&', "" )
         let midline = midline + 1
      endwhile
      call InsertLine ( a:firstln, a:opencomm )
      let lastln = a:lastln + 1
      call AppendLine ( lastln, a:closecomm )
   else
      let opencommMatch = escape ( a:opencomm, '*.' )
      let closecommMatch = escape ( a:closecomm, '*.' )
      let midcommMatch = escape ( a:midcomm, '*.' )
      
      let firstlnStr = getline(a:firstln) 
      if ( firstlnStr =~ '^\s*' . opencommMatch . '\s*$' )
         " We're at the top of a block. Remove the line.
         exe 'normal dd'
         let firstline = a:firstln
         let lastline = a:lastln - 1
      elseif ( firstlnStr =~ '^\s*' . midcommMatch )
         " We're in the middle of a block. Add a block-end above and uncomment 
         " this line.
         call InsertLine ( a:firstln, a:closecomm )
         call SubstLine ( a:firstln + 1,  '^' . midcommMatch, "", "" )
         let firstline = a:firstln + 2
         let lastline = a:lastln + 1
      else
         " Something weird. Abort.
         echohl Warning Msg | echo "Couldn't apply uncomment." | echohl None
         return -1
      endif
      
      if ( a:firstln == a:lastln )
         call AppendLine ( lastline, a:opencomm )
         return 0
      else
         let midline = firstline
         while midline < lastline
            call SubstLine ( midline, '^' . midcommMatch, "", "" )
            let midline = midline + 1
         endwhile
      endif
      
      let lastlnStr = getline(lastline)   
      if ( lastlnStr =~ '^\s*' . closecommMatch . '\s*$' )
         " We're at the end of a block. Remove the line.
         exe 'normal' . lastline . 'G'
         exe 'normal dd'
      elseif ( lastlnStr =~ '^\s*' . midcommMatch )
         " We're in the middle of a block. Add a block-start below and uncomment
         " this line.
         call AppendLine ( lastline, a:opencomm )
         call SubstLine ( midline, '^' . midcommMatch, "", "" )
      else
         " Probably the user went past the end of the commented block.
         let midline = firstline
         while midline < lastline
            let midlnStr = getline(midline)  
            if ( midlnStr =~ '^\s*' . closecommMatch . '\s*$' )
               " We're at the end of a block. Remove the line.
               exe 'normal' . midline . 'G'
               exe 'normal dd'
               " exe "echo 'line" . line(".") . "removed'"
               return 0
            endif
            let midline = midline + 1
         endwhile
      endif
   endif
endf "Commentify

"============================================================================== 

" For C, v-mapped to ,cmtn by autocmd
fu! CommentifyC ( b_comment ) range
   let opencomm  = "/*  "
   let closecomm = " */"
   let midcomm   = " *  "
   call Commentify ( a:b_comment, opencomm, closecomm, midcomm, a:firstline, a:lastline )
endf "CommentifyC

"============================================================================== 

" For HTML, v-mapped to ,cmtn by autocmd
fu! CommentifyHTML ( b_comment ) range
   let opencomm  = "<!--  "
   let closecomm = "  -->"
   let midcomm   = "      "
   call Commentify ( a:b_comment, opencomm, closecomm, midcomm, a:firstline, a:lastline )
endf "CommentifyHTML

"============================================================================== 

" For KAREL, v-mapped to ,cmtn by autocmd
fu! CommentifyKL (b_comment) range
  let opencomm  = "--"
  let closecomm = "--"
  let midcomm   = "--"
  call Commentify ( a:b_comment, opencomm, closecomm, midcomm, a:firstline, a:lastline)
endf "CommentifyKL

"============================================================================== 

" For Dictionaries, v-mapped to ,cmtn by autocmd
fu! CommentifyDict (b_comment) range
  let opencomm  = "* "
  let closecomm = "* "
  let midcomm   = "* "
  call Commentify ( a:b_comment, opencomm, closecomm, midcomm, a:firstline, a:lastline)
endf "CommentifyDict

"============================================================================== 

" For .dat files from EDD files, v-mapped to ,cmtn by autocmd
fu! CommentifyDat (b_comment) range
  let opencomm  = "! "
  let closecomm = "! "
  let midcomm   = "! "
  call Commentify ( a:b_comment, opencomm, closecomm, midcomm, a:firstline, a:lastline)
endf "CommentifyDat

"============================================================================== 

" For vim scripts, v-mapped to ,cmtn by autocmd
fu! CommentifyVim ( b_comment ) range
   let opencomm  = "\" "
   let closecomm = "\" "
   let midcomm   = "\" "
   call Commentify ( a:b_comment, opencomm, closecomm, midcomm, a:firstline, a:lastline )
endf "CommentifyVim

"============================================================================== 

" For procmailrc, v-mapped to ,cmtn by autocmd
fu! CommentifyProc ( b_comment ) range
   let opencomm  = "# "
   let closecomm = "# "
   let midcomm   = "# "
   call Commentify ( a:b_comment, opencomm, closecomm, midcomm, a:firstline, a:lastline )
endf "CommentifyProc

"============================================================================== 

" Perform substitution on the existing line
" args :linenum s/pat/rep/flags
fu! SubstLine ( linenum, pat, rep, flags )
    let thislineStr = getline( a:linenum )
    let thislineStr = substitute( thislineStr, a:pat, a:rep, a:flags )
    call setline( a:linenum, thislineStr )
endf

"============================================================================== 
function! ToggStamp()
  if g:dsb_stamp == 1
    let g:dsb_stamp = 0
    exe 'echo "Timestamp enabled"'
  else
    let g:dsb_stamp = 1
    exe 'echo "Timestamp disabled"'
  endif
endfunction "ToggStamp
"============================================================================== 
" This function adapted from vim discussion by Michael Geddes
" <mgeddes@cybergraphic.com.au> and 'Siew Kam Onn' <KOSIEW@MY.oracle.com>
" It requires a .vimrc entry like:
" au BufWrite * call StampFileEditTime()
" ------------------------------------------------------------------------------
function! StampFileEditTime()
    "let pat = '^\(.*Last edit:\).*'
    "let rep = '\1 '.strftime('%Y %b %d, %X')
    if &bin
      return
    endif
    if !g:dsb_stamp
      exe "mark m"

      " DLP Added my date formatting, and changed so whitespace is conserved
      "let pat = '^\(.*Last edit\(ed\)*:\s*\|.*Last modified:\s*\|.*Last revised:\s*\).*'
      let pat = '^\(.*Last [Ee]dit\(ed\)*:\s*\|.*Last [Mm]odified:\s*\|.*Last [Rr]evised:\s*\)\d\d-\h\+-\d\d\+\s\d\+:\d\d\(.*\)'
      "let rep = '\1'.strftime('%d-%b-%Y %H:%M')
      let rep = '\1'.strftime('%d-%b-%Y %H:%M').'\2'
      " Try the first 5 lines
      let lineno = 0
      while lineno <= 5
          call SubstLine (lineno,pat,rep,"")
          let lineno = lineno + 1
      endwhile
      " Try the last line
      "let lineno = line("$")
      " DLP changed to check last 10 lines as well
      let lineno = line("$") - 10
      while lineno <= line("$")
          call SubstLine (lineno,pat,rep,"")
          let lineno = lineno + 1
      endwhile
      call SubstLine (lineno,pat,rep,"")
      exe "normal 'm"
    endif "if we disabled time stamp (dsb_stamp)
endfunction

if version >= 600
  " YEAAA!  Vim 6.0 handles guessing suffixes now!
  set suffixesadd=".pdl"
else
"============================================================================== 
" DLP Requires vim 5.4 or above for sfind commands
" mapping is only used for KL files (see ~/.unixrc)
" from vim mailing list:
" Date:   Fri, 18 Jun 1999 12:52:34 +0200
" From:   Stefan Roemer <roemer@informatik.tu-muenchen.de>
" To:     John Spetz <JSpetz@calvin.idpnet.com>
" Cc:     Vim users mailing list <vim@vim.org>
" Subject: Re: Support for default extensions with gf and C-Wf
fu! FindFile(fn, splt)
  " DLP change, all of our UNIX files are lowercase
  " so ASSUME we meant lowercase if it wasn't already that way.
  " 30-Jul-1999 added split option so I don't "have" to split the win.
  "echo "Receiving params: ".a:fn." and ".a:splt
  "if has("unix")
    "let fn=fnamemodify(a:fn, ":s/[a-zA-Z0-9_.]*/\\L\\0/i")
  "else
    let fn=a:fn
  "endif
  if a:splt == 1
      exe'sfind'fn
  else
      exe'find'fn
  endif
  "if expand('%')!~a:fn.'$'
  if expand('%')!~fn.'$'
    "let ext='.ext1|.ext2|.ext3|'
    "let ext='.kl|.hc|.hf|.hm|.hp|.ht|.hv|.pdl|'
    let ext='.pdl|'
    while ext!=''
      let e=matchstr(ext,'[^|]\+')
      let ext=substitute(ext,'^[^|]\{-}|\(.*\)','\1','')
      if a:splt == 1
          exe'sfind'fn.e
      else
          exe'find'fn.e
      endif
      if expand('%')=~fn.e.'$'|return|endif
    endwhile
  endif
endf
" 
" nn gf :call FindFile(expand(expand('<cfile>')),0)<cr>
" nn ]f :call FindFile(expand(expand('<cfile>')),0)<cr>
" nn [f :call FindFile(expand(expand('<cfile>')),0)<cr>
" nn <c-w>f :call FindFile(expand(expand('<cfile>')),1)<cr>
" nn <c-w><c-f> :call FindFile(expand(expand('<cfile>')),1)<cr>
" 
nn gf :call FindFile(expand('<cfile>'),0)<cr>
nn ]f :call FindFile(expand('<cfile>'),0)<cr>
nn [f :call FindFile(expand('<cfile>'),0)<cr>
nn <c-w>f :call FindFile(expand('<cfile>'),1)<cr>
nn <c-w><c-f> :call FindFile(expand('<cfile>'),1)<cr>
endif

"============================================================================== 

" From: Christian J. Robinson (81) RE: display string in hex?
"       on the vim-dev mailing list.
" Functions ConvertBase, HexStr, ConvertBaseStr
" (Christian J. Robinson)-[ICQ UIN: 15869262]-<Running RedHat Linux>
" infynity@cyberhighway.net   http://www.cyberhighway.net/~infynity/
" For my PGP key: hkp://pgpkeys.mit.edu/0x991DB689  -  Or finger me.
function! ConvertBase(int, base)
  if (a:base < 2 || a:base > 16)
          echohl ErrorMsg
          echo "Bad base - must be between 2 and 16."
          echohl None
          return ''
  endif
  
  if (a:int == 0)
          return 0
  endif
  
  let out=''
  let int=a:int

  while (int != 0)
          let out = "0123456789ABCDEF"[(int % a:base)] . out
          let int = int / a:base
  endwhile
  
  return out
endfunction

"============================================================================== 

function! HexStr(str)
  let out=''
  let ix=0
  while (ix < strlen(a:str))
          let out = out . ConvertBase(char2nr(a:str[ix]),16)
          let ix = ix+1
  endwhile
  return out
endfunction

"============================================================================== 

"Or if you want to be able to convert a string to any base:
function! ConvertBaseStr(str, base)
  let out=''
  let ix=0
  while (ix < strlen(a:str))
          let out = out . ConvertBase(char2nr(a:str[ix]), a:base)
          let ix = ix+1
  endwhile
  return out
endfunction

"============================================================================== 
fu! Html2Txt()
    " Strip all tags base on the fact that they:
    " - Are a one line tag
    " - Begin with <
    " - Can contain any number of alphanumeric characters
    " - Can contain any number of slash, space, equals, double quotes,
    "   semicolon, dash, or dot
    " - End with >
    exe '%s/<[a-zA-Z0-9\/ =";\-\.]*>//ge'
    exe '%s/\s*$//ge'
    exe 'g/^$/,/./-j'
endf "Html2Txt

"============================================================================== 
fu! BoxesWrapper(remove) range abort
" Wrapper for boxes, to allow use of box_dsgn variable which is changed by
" autocmd for specific syntaxes, and use default if none is specified.
" nmap ,qc :.!boxes -d c-cmt<CR>
" nmap ,Qc :.!boxes -d c-cmt -r<CR>
" vmap ,qc :!boxes -d c-cmt<CR>
" vmap ,Qc :!boxes -d c-cmt -r<CR>
"
" ,q comments out, ,Q comments in. The "boxes" programm has been written
" with C commenting in mind, and it even takes care of */ - so
"    i = 0 ; /* this is a comment */
"    becomes
"       /* i = 0 ; /* this is a comment *\/ */
"
"------------------------------------------------------------------------------ 
  " Remove uses autodetection...
  if g:box_dsgn == ""
  endif

  if g:box_dsgn == ""
    if a:remove
      exe a:firstline.','.a:lastline.'!boxes -r'
    else
      exe a:firstline.','.a:lastline.'!boxes'
    endif
  else
    if a:remove
      exe a:firstline.','.a:lastline.'!boxes -d '.g:box_dsgn.' -r'
    else
      exe a:firstline.','.a:lastline.'!boxes -d '.g:box_dsgn
    endif
  endif
endf "BoxesWrapper

exe "so ".func_dir."/smartCTRL_w.vim"

" ----- put these lines in your 'vimrc' or ':source' them ------- [Vim5.3] ---
" Function: Perform an Ex command on a visual highlighted block (CTRL-V).
" Usage:    Mark visual block (CTRL-V), press ':B ' and enter an Ex command
"           [cmd]. On the command-line the visual range is automatically
"           inserted, ie. ":'<,'>B [cmd]" is displayed there (as usual).
"           Command-line completion is supported for Ex commands.
" Note:     There must be a space before the '!' when invoking external shell
"           commands, eg. ':B !sort'. Otherwise an error is reported.
" Author:   Stefan Roemer <roemer@informatik.tu-muenchen.de>
"
" Use ctrl-v to visually mark the block then use
"    :B if more lines than the marked block are inserted, cut them off
"    :C to keep all lines even if there are additional lines inserted
" affected: mark register m
" ------------------------------------------------------------------------------
fu! VisBlockCmd(flag,cmd)
  let x1=virtcol("'<")|let y1=line("'<")
  let x2=virtcol("'>")|let y2=line("'>")
  '>pu_|km|let a=''|let b=''|let l=y1
  while l<=y2
    let ln=getline(l)|let p1=strpart(ln,0,x1-1)|let p2=strpart(ln,x2,999999999)
    let a=a.p1."\n"|let b=b.p2."\n"|call setline(l,strpart(ln,x1-1,x2-x1+1))
    let l=l+1
  endw
  exe"'<,'>".a:cmd
  let l=y2-line("'m")|while l>=0|'m-1pu_|let l=l-1|endw|let l=y1
  while l<=y2
    call setline(l,matchstr(a,"[^\<c-j>]*").getline(l).matchstr(b,"[^\<c-j>]*"))
    let a=substitute(a,".\\{-}\<c-j>",'','')
    let b=substitute(b,".\\{-}\<c-j>",'','')
    let l=l+1
  endw
  if a:flag==1|exe"'md"|else|exe y2+1.",'md"|endif
endf
" ------------------------------------------------------------------------------
com! -ra -n=+ -complete=command B call VisBlockCmd(0,'<a>')
com! -ra -n=+ -complete=command C call VisBlockCmd(1,'<a>')
" ------------------------------------------------------------------------------

" ===========================================================================
" Date:   Mon, 12 Jul 1999 15:31:21 +0200
" From: Stefan Roemer <roemer@informatik.tu-muenchen.de>
" To: Johannes Zellner <johannes@zellner.org>
" Cc: Vim users mailing list <vim@vim.org>
" Subject: Re: command & `complete'
fu! CmdlineCompl(flag)
" ---------------------------------------------------------------------------
    " ---------- user customizable: completion style (CTRL-X CTRL-???) --------
    if !exists("g:ccp_cmd")|let g:ccp_cmd="\<c-x>\<c-n>"|endif
    " -------------------------------------------------------------------------
    " Note: this function changes the p and q mark registers
    " -------------------------------------------------------------------------
    if !exists("g:ccp_pos")|let g:ccp_pos=0|endif
    if !exists("g:ccp_lst")|let g:ccp_lst=0|endif|let n=g:ccp_lst
    if !exists("g:ccp_str")|let g:ccp_str=""|endif|let s=g:ccp_str
    let m=@m|exe'norm mq'|put_|exe'norm"lp^r'."\<c-x>".'x$mppb"mdt'."\<c-x>".'x'
    if match(n,@m)||col("`p")!=g:ccp_pos
      let s=""|let n=@m|let g:ccp_pos=col("`p")
    elseif s[0]=~"\<c-p>\<c-n>"[a:flag]
      let s=strpart(s,1,999999)|let@m=n
    else
      let s=s."\<c-p>\<c-n>"[!a:flag]|let m=n
    endif
    exe"norm a\<c-r>m".g:ccp_cmd.s."\e^\"ly$u`q"
    let g:ccp_lst=n|let g:ccp_str=s|let@m=m
    call histdel(':','^".*')
endf

" search forward
cno <c-x><c-n> <c-b>"<cr>:let@l=@:<cr>:call CmdlineCompl(0)<cr>:<c-r>l
" search backwards
cno <c-x><c-p> <c-b>"<cr>:let@l=@:<cr>:call CmdlineCompl(1)<cr>:<c-r>l
"----------------------------------------------------------------------------

" ===========================================================================
" Date:  Fri, 22 Oct 1999 05:19:54 -0400
" From:  Stefan Roemer <roemer@informatik.tu-muenchen.de>
" To:    Douglas L. Potts <pottsdl@frc.com>
" Cc:    Vim users mailing list <vim@vim.org>
" Subject: Re: command & `complete'
fu! SearchCompl(flag)
" ---------- user customizable: completion style (CTRL-X CTRL-???) ----------
  if !exists("g:ccp_cmd")|let g:ccp_cmd="\<c-x>\<c-n>"|endif
" ---------------------------------------------------------------------------
" Note: this function changes the p and q mark registers and the register l  
" ---------------------------------------------------------------------------
  if !exists('g:scp_pos')|let g:scp_pos=0|endif
  if !exists('g:scp_lst')|let g:scp_lst='@'|endif|let n=g:scp_lst
  if !exists('g:scp_str')|let g:scp_str=''|endif|let s=g:scp_str
  " Store current register l in local var 'l'
  let @l=histget('/',-1)
  " Store current register m in local var 'm'
  let m=@m|let@m=' '
  " Mark current location as q, paste something, 
  exe'norm mq'|put_|exe'norm"lp"mp"mdbx'
  if match(@m,n)
    let s=''|let n=@m
  elseif s[0]=="\<c-p>\<c-n>"[a:flag]
    let s=strpart(s,1,999999)|let@m=n  
  else
    let s=s."\<c-p>\<c-n>"[!a:flag]|let@m=n
  endif
  exe'norm a'.@m.g:ccp_cmd.s."\e^\"ly$u`q"
  let g:scp_lst=n|let g:scp_str=s|let@m=m
  call histdel('/',-1)
endf
" search '/': complete "next" (like <c-n>)
cno <c-z><c-n> <c-c>:call SearchCompl(0)<cr>/<c-r>l
" search '/': complete "previous" (like <c-p>)
cno <c-z><c-p> <c-c>:call SearchCompl(1)<cr>/<c-r>l
" ---------------------------------------------------------------------------
fu! BracketWrapper(brckt_cmd, wasvisual)
" used for [[, ]], ][, [] movement mappings, including movement while in
" visual mode.
" LIMITATION: can't restore original "Visual selection type", ie. has to
" assume linewise selections.
" ---------------------------------------------------------------------------
  " Save search pattern
  let oldsrc=@/

  if &ft == "kl" || &ft == "pdl"
    let bkeywrd = '\s*BEGIN'
    let ekeywrd = '\s*END$'
  "elseif &ft == "ht"
  "  let bkeywrd = 'typedef'
  "  let ekeywrd = "}"
  elseif &ft == "vim"
    let bkeywrd = 'fun\k*'
    let ekeywrd = "endf\k*"
  elseif &ft == "boxes"
    let bkeywrd = 'BOX \k*'
    let ekeywrd = "END \k*"
  else
    echo "Unknown filetype for BracketWrapper"
    return
  endif

  if a:brckt_cmd == "[["
    exe "?^".bkeywrd."?"
  elseif a:brckt_cmd == "[]"
    exe "?^".ekeywrd."?"
  elseif a:brckt_cmd == "]]"
    exe "/^".bkeywrd."/"
  elseif a:brckt_cmd == "]["
    exe "/^".ekeywrd."/"
  else
    return
  endif

  if a:wasvisual == 1
    " Store this posn in virtual mark, go back to `<, and reselect to this mark
    let marka = line(".") . "normal" . virtcol(".") . "|"
    normal `<V
    exe marka
  endif

  " Restore old search pattern
  let @/=oldsrc
endf

fu! VirMark()
  if exists("b:marka")
    exe b:marka
    unlet b:marka
  else
    let b:marka = line(".") . "normal" . col(".") . "|"
    let linea = matchstr(b:marka, "\\d\\+")
    let cola  = substitute(b:marka, '.\{-}\(\d\+\)|', '\1', "")
    echo "Mark at col:".cola." line:".linea
  endif
endf

" ---------------------------------------------------------------------------
fun! BuffersDelete(pat)
" Delete all buffers that match a filename pattern
" ---------------------------------------------------------------------------
  " Try to keep track of where we were
  let old_buffer = bufnr("%")
  let i = 1
  while (i <= bufnr("$"))
    if bufexists(i)
      echo "In buffer:".bufname(i)
      let foo=input("Press return.")
      if bufname(i) =~ a:pat
        exe "bd ".bufname(i)
        echo "Deleting buffer: ".bufname(i)
        "DBG let foo=input("Press return.")
        " But if we delete where we were
        if i == old_buffer
          let old_buffer = 0
        endif
      endif
    endif
    let i = i + 1
  endwhile
  " Don't go there, just stay wherever we end up last.
  if old_buffer != 0
    exe "buffer ".old_buffer
  endif
endf
:com! -nargs=1 -complete=command Bd exe "call BuffersDelete(\"<a>\")"

" ---------------------------------------------------------------------------
" Purpose: execute a command in all buffers
" Author: Ralf Arens
" URL: http://home.tu-clausthal.de/~mwra/vim/AllBuffers.vim
" Last Modified: 2000-03-10 13:08:40 CET
" - executes a command in all buffers
" - attention: command has to be quoted, e.g. :call AllBuffersDo("%s,foo,bar")
" ---------------------------------------------------------------------------
fun! AllBuffers(cmnd)
  let old_autowrite=&aw
  set aw
  " Double quotes from the user command, will screw up the execute statement
  " if they are here, remove them (safe because the 'call' version strips out
  " the double quotes anyway
  if a:cmnd =~ '"'
    echo "Double quote detected"
    let cmnd = substitute(a:cmnd, '"', '', 'g')
  else
    let cmnd = a:cmnd
  endif
  let do_all = 0
  let old_buffer = bufnr("%")
  let i = 1
  while (i <= bufnr("$"))
    if bufexists(i)
      execute "buffer" i
      if do_all == 0
        echo "Current buffer is:".bufname("%")
        let foo = input("Execute cmd: ".cmnd." on this buffer (y/n/a/q)? ")
      endif
      if foo =~ '[Yy]\([Ee][Ss]\)\=' || do_all > 0
        echo "Executing ".cmnd
        execute cmnd
      elseif foo =~ '[Qq]\([Uu][Ii][Tt]\)\='
        let i = bufnr("$")
      elseif foo =~ '[Aa]\([Ll][Ll]\)\='
        let do_all = 1
        execute cmnd
      else
        echo "NO MATCHES!!!!"
      endif
    else
      echo "Buffer ".bufname("%")." does not EXIST!!"
    endif
    let i = i+1
  endwhile
  exe "buffer" old_buffer
  let &aw=old_autowrite
endfun
com! -nargs=+ -complete=command AllBuffers call AllBuffers(<q-args>)

" From :h map.txt
fun! Allargs(cmnd)
  let old_autowrite=&aw
  set aw
  " Double quotes from the user command, will screw up the execute statement
  " if they are here, remove them (safe because the 'call' version strips out
  " the double quotes anyway
  if a:cmnd =~ '"'
    echo "Double quote detected"
    let cmnd = substitute(a:cmnd, '"', '', 'g')
  else
    let cmnd = a:cmnd
  endif
  let do_all = 0
  let old_buffer = bufnr("%")
  let i = 0
  while i < argc()
    if filereadable(argv(i))
      exe "e ".argv(i)
      if do_all == 0
        echo "Current buffer is:".bufname("%")
        let foo = input("Execute cmd: ".cmnd." on this buffer (y/n/a/q)? ")
      endif
      if foo =~ '[Yy]\([Ee][Ss]\)\=' || do_all > 0
        echo "Executing ".cmnd
        execute cmnd
      elseif foo =~ '[Qq]\([Uu][Ii][Tt]\)\='
        let i = bufnr("$")
      elseif foo =~ '[Aa]\([Ll][Ll]\)\='
        let do_all = 1
        execute cmnd
      else
        echo "NO MATCHES!!!!"
      endif
    else
      echo "Buffer ".bufname("%")." does not EXIST!!"
      "exe a:command
    endif
    let i = i + 1
  endwhile
  exe "buffer" old_buffer
  let &aw=old_autowrite
endfun
com! -nargs=+ -complete=command Allargs call Allargs(<q-args>)

fun! Filelist()
        let fileIndex = 1
        let fileList = ""
        while (fileIndex <= bufnr("$"))
                let fileList = fileList . " " . bufname(fileIndex)
                let fileIndex = fileIndex + 1
        endwhile
        return fileList
endfun
map ,.gp :execute ":grep ".expand("<cword>")." ".Filelist()

" ===========================================================================
fu! Execute_block() range
" Take the selected range of lines, and execute them as if they
" were a shell script.
" CAREFUL: of multi-line statements like for; do; done, they should all be
" on ONE line.
" ---------------------------------------------------------------------------
  echo "Firstline:".a:firstline
  echo "Lastline:".a:lastline

  " if firstline says shell, then execute as shell commands
  if getline(a:firstline) =~ 'shell'
    let cmd_prefix=":!"
  else " otherwise treat them as ex commands
    " Try to take care of us, if we put the extra ':' in the block
    let c = getline(line("."))[col(".") - 1]
    echo "c is:".c
    if c == ':'
      let cmd_prefix=""
    else
      let cmd_prefix=":"
    endif
  endif

  let bname = input("On what buffer should this cmd be exe: ")
  let mybuf = bufnr(bname)
  if mybuf == -1
    echo "No buffer of that name!!"
    sleep 5
    return
  endif
  "echo "Buffer found is:".mybuf
  "sleep 5

  let this_buf = bufnr("%")
  let curr_line = a:firstline+1
  while curr_line <= a:lastline
    let line_str = getline(curr_line)
    if line_str != ""
      let exe_str = cmd_prefix.line_str
      echo "Current buffer is:".bufname("%")
      exe ":b ".mybuf
      echo "Current buffer is:".bufname("%")
      "echo "Execute ".exe_str
      exe exe_str
      exe ":b ".this_buf
    endif
    let curr_line = curr_line + 1
  endwhile
endf

fu! BoolSwitch(turn_on)
  let curword=expand("<cword>")
  let changed=curword
  if a:turn_on == 1
    if curword == "disable"
      let changed="enable"
    elseif curword == "DISABLE"
      let changed="ENABLE"
    elseif curword == "off"
      let changed="on"
    elseif curword == "OFF"
      let changed="ON"
    elseif curword == "false"
      let changed="true"
    elseif curword == "FALSE"
      let changed="TRUE"
    elseif curword == "left"
      let changed="right"
    elseif curword == "LEFT"
      let changed="RIGHT"
    elseif curword == "undef"
      let changed="define"
    endif
  else " turn off
    if curword == "enable"
      let changed="disable"
    elseif curword == "ENABLE"
      let changed="DISABLE"
    elseif curword == "on"
      let changed="off"
    elseif curword == "ON"
      let changed="OFF"
    elseif curword == "true"
      let changed="false"
    elseif curword == "TRUE"
      let changed="FALSE"
    elseif curword == "right"
      let changed="left"
    elseif curword == "RIGHT"
      let changed="LEFT"
    elseif curword == "define"
      let changed="undef"
    endif
  endif
  exe "norm! ciw".changed."\<esc>"
endf
nmap ,0 :call BoolSwitch(0)<cr>
nmap ,1 :call BoolSwitch(1)<cr>

" This function requires my OpenIfNew function, defined in functions.vim
if version >= 600
  fu! OpenCalendar(year)
    if a:year == ""
      let s:year = strftime("%Y")
    else
      let s:year = a:year
    endif
    let s:calfilename = "Calendar"

    " Only keep ONE around
    if bufnr(s:calfilename) > 0
      exe 'bw! '.s:calfilename
    endif
    exe 'new '.s:calfilename

    " Make it just a viewable window
    set modifiable
    let s:old_report=&report
    let &report=9999
    silent exe ':0r!cal '.s:year
    set nomodified
    set nomodifiable
    let &report=s:old_report
    normal 1G
  endfu
endif

" ---------------------------------------------------------------------------
" vim:tw=0:
