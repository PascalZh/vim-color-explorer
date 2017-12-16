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
  exe "silent bot ".10."new "."ColorExplorer"

  setlocal bufhidden=delete
  setlocal buftype=nofile
  setlocal modifiable
  setlocal noswapfile
  setlocal nowrap
  setlocal foldmethod=marker
  setlocal foldmarker={,}
  setlocal foldtext=FoldTextFunc()
  " 如果使用<SID>的话好像不管用

  map <buffer> <silent> <cr> :call <SID>SelectScheme()<cr>
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
  silent put! ='Press q to quit;Press enter to choose'

  unlet! s:color_file_list
  unlet! s:airline_color_file_list

  setlocal nomodifiable
endfunction

" SelectScheme {{{1
function! <SID>SelectScheme()
" Are we on a line with a file name?
    let current_line=getline('.')
    if strlen(current_line) == 0
        return
    endif
    let theme_name=substitute(matchstr(current_line, "[a-z-_0-9]\\+.vim$"),"\\\.vim","","g")

    echom "THEME_NAME:" . theme_name
    if matchstr(current_line, "airline")=="airline"
        echom "I've disabled this feature because of a severe bug"
        "let g:airline_theme=theme_name
    else
        execute "colorscheme " . theme_name
    endif

endfunction

" FoldTextFunc {{{1
function! FoldTextFunc()
    let line =foldtext()
    let sub=substitute(line,'lines: ','','g')
    return sub
endfunction
