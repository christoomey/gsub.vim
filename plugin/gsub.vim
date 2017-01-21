function! s:DisplaySearchResults(results)
  silent pedit Gsub-preview
  wincmd P
  setlocal buftype=nofile
  setlocal noswapfile
  setlocal nowrap
  setlocal filetype=gsub
  10wincmd +
  normal ggdG
  call append(0, a:results)
  normal ddgg
endfunction

function! s:Gsearch(...)
  if a:0 == 0
    let search = substitute(
          \ substitute(getreg("/"), '\\<', '\\b', "g"),
          \ '\\>', '\\b', "g")
  else
    let search = a:1
  endif
  let results = system("ag '" . search . "' --heading")
  call s:DisplaySearchResults(split(results, '\n'))
endfunction
command! -nargs=? Gsearch call <sid>Gsearch(<f-args>)
