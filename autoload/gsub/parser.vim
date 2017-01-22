function! gsub#parser#parse(lines) abort
  let changes = {}
  let file = ''

  for [line_index, line_text] in gsub#utils#each_with_index(a:lines)
    if line_text != ''
      let parsed = s:ParseLine(line_text)
      if has_key(parsed, 'file')
        let file = parsed.file
      else
        let change = extend(parsed, {
              \ 'file': file,
              \ 'preview_line': line_index + 1,
              \ 'raw_text': line_text
              \ })
        let change_key = change.line . ':' . change.file
        call extend(changes, { change_key: change })
      endif
    endif
  endfor

  return changes
endfunction

function! gsub#parser#current_changes() abort
  let lines = []
  for line in range(1, line('$'))
    call add(lines, getline(line))
  endfor
  return gsub#parser#parse(lines)
endfunction

function! s:ParseLine(raw_line)
  let parts = split(a:raw_line, ':')
  if len(parts) > 1
    let line = parts[0]
    let text = join(parts[1:-1], ':')
    return { 'line': line, 'text': text }
  else
    return { 'file': a:raw_line }
  end
endfunction
