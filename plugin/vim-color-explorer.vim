" Create commands
if !exists(":ColorSchemeExplorer")
  command ColorSchemeExplorer :call <SID>ColorSchemeExplorer()
endif

" ColorSchemeExplorer {{{1
function! <SID>ColorSchemeExplorer()
  let s:color_file_list = globpath(&runtimepath, 'colors/*.vim')
  let s:airline_color_file_list = globpath(&rtp, 'autoload/airline/themes/*.vim')
  "let s:color_file_list = substitute(s:color_file_list, '\', '/', 'g')

  "setlocal autochdir
  exe "silent bot ".10."new "."Color Explorer"

  setlocal bufhidden=delete
  setlocal buftype=nofile
  setlocal modifiable
  setlocal noswapfile
  setlocal nowrap
  setlocal foldmethod=marker
  setlocal foldmarker={,}
  setlocal foldtext=FoldTextFunc()
  " 如果使用<SID>的话好像不管用

  map <buffer> <silent> ? :call <SID>ToggleHelp()<cr>
  map <buffer> <silent> <cr> :call <SID>SelectScheme()<cr>
  map <buffer> <silent> <2-leftmouse> :call <SID>SelectScheme(0)<cr>
  map <buffer> <silent> q :bd!<cr>

  "cd ..
  "read ++enc=utf-8 ++ff=unix freqlist
  "normal! ggdd
  "put! ='MostUsed{'
  "normal! G
  "put ='}'
  silent put ='Colorschemes{'
  silent put =s:color_file_list
  silent put ='}'
  silent put ='Airline Colorschemes{'
  silent put =s:airline_color_file_list
  silent put ='}'
  normal! gg

  unlet! s:color_file_list
  unlet! s:airline_color_file_list

  setlocal nomodifiable
endfunction

" SelectScheme {{{1
function! <SID>SelectScheme()
  " Are we on a line with a file name?
  if strlen(getline('.')) == 0
    return
  endif

  call <SID>Reset()

  execute "source" getline('.')
endfunction

" Reset {{{1
function! <SID>Reset()
  hi clear Normal
  set bg&

  " Remove all existing highlighting and set the defaults.
  hi clear

  " Load the syntax highlighting defaults, if it's enabled.
  if exists("syntax_on")
    syntax reset
  endif
endfunction

" FoldTextFunc {{{1
function! FoldTextFunc()
    let line =foldtext()
    let sub=substitute(line,'lines: ','','g')
    return sub
endfunction
" ToggleHelp {{{1
function! <SID>ToggleHelp()
  " Save position
  normal! mZ

  let header = "\" Press ? for Help\n"
  silent! put! =header

  " Jump back where we came from if possible.
  0
  if line("'Z") != 0
    normal! `Z
  endif
endfunction

"----------------------------------------------------------"
"call <SID>ColorSchemeExplorer()
"function! <SID>WriteFreqListFile(colorfile)
"endfunction

" vim:ft=vim foldmethod=marker
