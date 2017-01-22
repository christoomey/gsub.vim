function! gsub#substitute#Gsub() abort
  for [_change_key, change] in items(gsub#parser#current_changes())
    call s:UpdateLine(change.file, change.line, change.text)
  endfor
  call s:FlushBuffers()
  bdelete
  echohl String | echom "Gsub executed succesfully" | echohl None
endfunction

function! s:cleaned_line(raw_line) abort
  let dub_quote_escaped = escape(a:raw_line, '"')
  let fully_quote_escaped = substitute(dub_quote_escaped, "'", "'\"'\"'", 'g')
  return fully_quote_escaped
endfunction

function! s:UpdateLine(file, line_number, line_text) abort
  " awk 'NR=={print"HELLLLO"};NR!=5'
  let mv_cmd = a:file . " > /tmp/gsub && mv /tmp/gsub " . a:file
  let g:substitute_cmd = "awk 'NR==" . a:line_number . "{print \"" .
        \ s:cleaned_line(a:line_text) .
        \ "\" };NR!=" . a:line_number . "' " . mv_cmd
  call system(g:substitute_cmd)
endfunction

function! s:FlushBuffers() abort
  let old_autoread = &autoread
  set autoread
  silent checktime
  let &autoread = old_autoread
endfunction
