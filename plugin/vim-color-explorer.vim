if exists("g:vim_color_explorer_is_loaded") || &cp
  finish
endif
let g:vim_color_explorer_is_loaded=1
" Create commands
if !exists(":ColorExplorerToggle")
  command! ColorExplorerToggle call <SID>ColorExplorerToggle()
endif

" ColorExplorerToggle {{{1
let g:color_explorer_winnr=0
function! s:ColorExplorerToggle()
  let g:color_explorer_winnr=bufwinnr(bufnr('ColorExplorer'))
  if g:color_explorer_winnr==-1
    call s:OpenColorExplorerWindow()
  else
    execute g:color_explorer_winnr . "wincmd w"
    " q has been mapped to quit the window
    normal q
  endif
endfunction
" OpenColorExplorerWindow(){{{1
function! s:OpenColorExplorerWindow()
  let s:color_file_list = split(globpath(&runtimepath, 'colors/*.vim'), "\n")
  let s:airline_color_file_list = split(globpath(&rtp, 'autoload/airline/themes/*.vim'), "\n")
  let color = []
  let airline_color = []
  for l in s:color_file_list
    let color += [split(l, '/')[-1][0:-5]]
  endfor
  for l in s:airline_color_file_list
    let airline_color += ['airline/'.split(l, '/')[-1][0:-5]]
  endfor
  exe "silent botright ".18."vnew "."ColorExplorer"
  setlocal bufhidden=delete
  setlocal nobuflisted
  setlocal buftype=nofile
  setlocal ft=ColorExplorer
  setlocal modifiable
  setlocal noswapfile
  setlocal nowrap
  setlocal nonumber
  setlocal norelativenumber
  setlocal signcolumn=no

  map <buffer> <silent> <cr> :call <SID>SelectScheme()<cr>
  map <buffer> <silent> o :call <SID>SelectScheme()<cr>
  map <buffer> <silent> q <C-w>q
  syntax match ColorExplorer /Colorschemes »»»/
  syntax match ColorExplorer /Airline Colorschemes »»»/
  hi link ColorExplorer Constant

  silent put ='Colorschemes »»»'
  let color_ = join(color, "\n")
  silent put =color_

  if exists(":AirlineTheme") == 2
    silent put =''
    silent put ='Airline Colorschemes »»»'
    let airline_color_ = join(airline_color, "\n")
    silent put =airline_color_
  endif

  normal! gg
  silent put! ='<enter>/o : choose'
  silent put! ='q         : quit'
  unlet! s:color_file_list
  unlet! s:airline_color_file_list
  setlocal nomodifiable
endfunction
" SelectScheme {{{1
function! <SID>SelectScheme()
  " Are we on a line with a file name?
  let theme_name=getline('.')
  if strlen(theme_name) == 0
    return
  endif
  if matchstr(theme_name, "airline")=="airline"
    execute "AirlineTheme " . split(theme_name, '/')[1]
  else
    execute "colorscheme " . theme_name
  endif
  echom "THEME_NAME: " . theme_name
endfunction
