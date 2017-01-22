function! gsub#utils#each_with_index(list) abort
  let current_index = 0
  let results = []

  for item in a:list
    call add(results, [current_index, item])
    let current_index += 1
  endfor

  return results
endfunction

function! gsub#utils#reverse_string(string) abort
  return join(reverse(split(a:string, '.\zs')), '')
endfunction
