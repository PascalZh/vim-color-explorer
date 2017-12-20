if exists("g:vim_color_explorer_is_loaded") || &cp
  finish
endif
let g:vim_color_explorer_is_loaded=1
" Create commands
if !exists(":ColorExplorerToggle")
  command ColorExplorerToggle :call <SID>ColorExplorerToggle()
endif

" ColorExplorerToggle {{{1
let g:color_explorer_winnr=0
function! <SID>ColorExplorerToggle()

  let g:color_explorer_winnr=bufwinnr(bufnr('ColorExplorer'))
  if g:color_explorer_winnr==-1
    call <SID>OpenColorExplorerWindow()
  else
    execute g:color_explorer_winnr . "wincmd w"
    " q has been mapped to quit the window
    normal q
  endif

endfunction
" OpenColorExplorerWindow(){{{1
func! <SID>OpenColorExplorerWindow()
      let s:color_file_list = globpath(&runtimepath, 'colors/*.vim')
      let s:airline_color_file_list = globpath(&rtp, 'autoload/airline/themes/*.vim')
      exe "silent bot ".10."new "."ColorExplorer"
      setlocal bufhidden=delete
      setlocal nobuflisted
      setlocal buftype=nofile
      "to show ColorExplorer with airline better!
      setlocal ft=ColorExplorer
      setlocal modifiable
      setlocal noswapfile
      setlocal nowrap
      setlocal foldmethod=marker
      setlocal foldmarker={,}
      setlocal foldtext=FoldTextFunc()
      map <buffer> <silent> <cr> :call <SID>SelectScheme()<cr>
      map <buffer> <silent> q :bd<cr><C-w>p
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
endfunc
" SelectScheme {{{1
function! <SID>SelectScheme()
" Are we on a line with a file name?
    let current_line=getline('.')
    if strlen(current_line) == 0
        return
    endif
    let theme_name=substitute(matchstr(current_line, "[a-z-_0-9]\\+.vim$"),"\\\.vim","","g")

    if matchstr(current_line, "airline")=="airline"
        "echom "I've disabled this feature because of a severe bug"
        execute "AirlineTheme " . theme_name
    else
        execute "colorscheme " . theme_name
    endif
    echom "THEME_NAME: " . theme_name

endfunction

" FoldTextFunc {{{1
function! FoldTextFunc()
    let line =foldtext()
    let sub=substitute(line,'lines: ','','g')
    return sub
endfunction
" Airline support{{{1
function! ColorExplorerForAirline(...)
    if &filetype == 'ColorExplorer'
      let w:airline_section_a = 'ColorExplorer'
      let w:airline_section_b = ''
      let w:airline_section_c = ''
      let w:airline_section_x = ''
      let w:airline_section_y = ''
      let w:airline_section_z = ''
    endif
endfunction
"let g:airline_add_statusline_func_has_been_called=0
"if g:airline_add_statusline_func_has_been_called==0
    call airline#add_statusline_func('ColorExplorerForAirline')
    "let g:airline_add_statusline_func_has_been_called=1
"elseif
    "echom "Error???: from color-explorer."
"endif
