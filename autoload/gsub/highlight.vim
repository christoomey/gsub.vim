function! gsub#highlight#highlight_preview_edits() abort
  call clearmatches()
  for [change_key, change] in items(gsub#parser#current_changes())
    let base_version = get(g:_gsub_results, change_key)
    call s:MaybeHighlight(change.preview_line, base_version.raw_text, change.raw_text)
  endfor
endfunction

function! s:MaybeHighlight(preview_line, base_text, change_text) abort
  if a:base_text != a:change_text
    let change_start = s:DifferenceStart(a:base_text, a:change_text)
    let change_end = s:DifferenceEnd(a:base_text, a:change_text)
    call s:Highlight(a:preview_line, change_start, change_end)
  endif
endfunction

function! s:DifferenceStart(base_text, change_text) abort
  for char_index in range(0, len(a:change_text) - 1)
    if a:base_text[char_index] != a:change_text[char_index]
      return char_index
    endif
  endfor
endfunction

function! s:DifferenceEnd(base_text, change_text) abort
  let rev_base = gsub#utils#reverse_string(a:base_text)
  let rev_change = gsub#utils#reverse_string(a:change_text)
  for char_index in range(0, len(a:change_text) - 1)
    if rev_base[char_index] != rev_change[char_index]
      return len(a:change_text) - char_index + 1
    endif
  endfor
endfunction

function! s:Highlight(line, start, end) abort
  let match_pattern = '\%' . a:line . 'l\%>' . a:start . 'v.*\%<' . a:end . 'v'
  call matchadd("Type", match_pattern)
endfunction
