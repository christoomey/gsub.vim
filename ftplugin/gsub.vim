function! s:cleaned_line(raw_line)
  let dub_quote_escaped = escape(a:raw_line, '"')
  let fully_quote_escaped = substitute(dub_quote_escaped, "'", "'\"'\"'", 'g')
  return fully_quote_escaped
endfunction

function! s:UpdateLine(file, line_number, line_text)
  " awk 'NR=={print"HELLLLO"};NR!=5'
  let mv_cmd = a:file . " > /tmp/gsub && mv /tmp/gsub " . a:file
  let g:substitute_cmd = "awk 'NR==" . a:line_number . "{print \"" .
        \ s:cleaned_line(a:line_text) .
        \ "\" };NR!=" . a:line_number . "' " . mv_cmd
  call system(g:substitute_cmd)
endfunction

function! s:LineAndText(raw_line)
  let parts = split(a:raw_line, ':')
  if len(parts) > 1
    let line = parts[0]
    let text = join(parts[1:-1], ':')
    return { 'line': line, 'text': text }
  else
    return { 'file': a:raw_line }
  end
endfunction

function! s:Gsub()
  let changes = []
  let file = ''

  for line in range(0, line('$'))
    let line_text = getline(line)
    if line_text != ''
      let parsed = s:LineAndText(line_text)
      if has_key(parsed, 'file')
        let file = parsed.file
      else
        call add(changes, extend(parsed, { 'file': file }))
      endif
    endif
  endfor

  for change in changes
    call s:UpdateLine(change.file, change.line, change.text)
  endfor

  let old_autoread = &autoread
  set autoread
  silent checktime
  let &autoread = old_autoread

  bdelete

  echohl String | echom "Gsub executed succesfully" | echohl None
endfunction
command! -buffer Gsub call <sid>Gsub()
