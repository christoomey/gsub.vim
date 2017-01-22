function! gsub#search#run(...) abort
  if a:0 == 0
    let search = s:AgReadyPatternFromMostRecentSearch()
  else
    let search = a:1
  endif

  let results = split(system("ag '" . search . "' --heading"), '\n')
  call gsub#preview#display_results(results)
endfunction

function! s:AgReadyPatternFromMostRecentSearch()
  let most_recent_search = getreg("/")
  return substitute(
        \ substitute(most_recent_search, '^\\<', '\\b', "g"),
        \ '\\>$', '\\b', "g")
endfunction
