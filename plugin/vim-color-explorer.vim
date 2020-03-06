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
    let s:color_file_list = split(globpath(&runtimepath, 'colors/*.vim'), "\n")
    let s:airline_color_file_list = split(globpath(&rtp, 'autoload/airline/themes/*.vim'), "\n")
    let l:color = []
    let l:airline_color = []
    for l in s:color_file_list
        let l:color += [split(l, '/')[-1][0:-5]]
    endfor
    for l in s:airline_color_file_list
        let l:airline_color += ['airline/'.split(l, '/')[-1][0:-5]]
    endfor
    exe "silent bot ".10."new "."ColorExplorer"
    setlocal bufhidden=delete
    setlocal nobuflisted
    setlocal buftype=nofile
    "to show ColorExplorer with airline better!
    setlocal ft=ColorExplorer
    setlocal modifiable
    setlocal noswapfile
    setlocal nowrap
    "setlocal foldmethod=marker
    "setlocal foldmarker={,}
    "setlocal foldtext=FoldTextFunc()
    map <buffer> <silent> <cr> :call <SID>SelectScheme()<cr>
    map <buffer> <silent> o :call <SID>SelectScheme()<cr>
    map <buffer> <silent> q <C-w>q
    syntax match ColorExplorer /Colorschemes »»»/
    syntax match ColorExplorer /Airline Colorschemes »»»/
    hi link ColorExplorer Constant
    silent put ='Colorschemes »»»'
    let l:color_ = join(l:color, "\n")
    silent put =l:color_
    silent put =''
    silent put ='Airline Colorschemes »»»'
    let l:airline_color_ = join(l:airline_color, "\n")
    silent put =l:airline_color_
    normal! gg
    silent put! ='Press q to quit;Press enter/o to choose'
    unlet! s:color_file_list
    unlet! s:airline_color_file_list
    setlocal nomodifiable
endfunc
" SelectScheme {{{1
function! <SID>SelectScheme()
    " Are we on a line with a file name?
    let theme_name=getline('.')
    if strlen(theme_name) == 0
        return
    endif
    if matchstr(theme_name, "airline")=="airline"
        "echom "I've disabled this feature because of a severe bug"
        execute "AirlineTheme " . split(theme_name, '/')[1]
    else
        execute "colorscheme " . theme_name
    endif
    echom "THEME_NAME: " . theme_name
endfunction

" FoldTextFunc {{{1
"function! FoldTextFunc()
"let line =foldtext()
"let sub=substitute(line,'lines: ','','g')
"return sub
"endfunction
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
