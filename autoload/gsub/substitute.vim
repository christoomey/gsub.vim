function! gsub#substitute#Gsub() abort
  if s:NotAllSaved()
    echohl Error | echom s:GSUB_UNSAVED_ERROR_MESSAGE | echohl None | return
  endif
  call s:WriteChanges()
  call s:FlushBuffers()
  bdelete
  echohl String | echom "Gsub executed succesfully" | echohl None
endfunction

let s:MODIFIED_FILTER = 'bufexists(v:val) && getbufvar(v:val, "&mod") == 1'
let s:GSUB_UNSAVED_ERROR_MESSAGE = 'Gsub: cannot run with unsaved buffers'

function! s:WriteChanges()
  for [_change_key, change] in items(gsub#parser#current_changes())
    call s:UpdateLine(change.file, change.line, change.text)
  endfor
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

function! s:NotAllSaved()
  let buffer_list = range(1, bufnr('$'))
  let unsaved_buffers = filter(buffer_list, s:MODIFIED_FILTER)
  return len(unsaved_buffers) > 0
endfunction
