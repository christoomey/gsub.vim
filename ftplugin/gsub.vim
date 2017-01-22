command! -buffer Gsub call gsub#substitute#Gsub()

setlocal updatetime=50

augroup gsub
  autocmd! * <buffer>
  autocmd TextChanged  <buffer> call gsub#highlight#highlight_preview_edits()
  autocmd TextChangedI <buffer> call gsub#highlight#highlight_preview_edits()
  autocmd CursorHold   <buffer> call gsub#highlight#highlight_preview_edits()
augroup END
