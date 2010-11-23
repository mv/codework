
" MyLib {

    " MVF_addlinenumbers {
    "     add explict line numbers to the left
    ":function! MVF_addlinenumbers()
    ":    exec ":% !awk '{printf \"\\%3d \\%s\\n\", nr, $0}'"
    ":endfunction
    " }

    " MVF_TerminateLastLine {
    "    Last line of a file must be a \n
    "function! MVF_TerminateLastLine()
    "   " save state
    "   let _s=@/
    "   let l = line(".")
    "   let c = col(".")

    "   " last line
    "   let s:lst = line("$")
    "   let s:str = getline( s:lst )
    "   if s:str !~ '^$'
    "       " Go last line, add new, del comments
    "       normal Go
    "       normal Gd$
    "   endif
    "   echo "Line " [s:lst] [s:str]
    "   " Restore state
    "   let @/=_s
    "   call cursor(l, c)
    "endfunction

    "if exists( 'MVF_TerminateLastLine()' )
    "   autocmd BufWritePre   * execute MVF_TerminateLastLine()
    "endif

    "map <leader>last :call TerminateLastLine() <CR>
    " }

    " MVF_StripTrailingWhitespaces {
    "    http://vimcasts.org/episodes/tidying-whitespace/
    "function! MVF_StripTrailingWhitespaces()
    "    " Preparation: save last search, and cursor position.
    "    let _s=@/
    "    let l = line(".")
    "    let c = col(".")
    "    " Do the business:
    "    %s/\s\+$//e
    "    " Clean up: restore previous search history, and cursor position
    "    let @/=_s
    "    call cursor(l, c)
    "endfunction
    "" }

" }

" vim:ft=vim

