function! gsub#preview#display_results(results) abort
  let g:_gsub_results = gsub#parser#parse(a:results)
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
