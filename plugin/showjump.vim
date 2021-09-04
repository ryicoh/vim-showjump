" set updatetime=100

augroup Automark
  au CursorHold * :call showjump#refresh()
augroup end
