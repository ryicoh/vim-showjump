let s:sign_prefix = 'showjump_'

func! showjump#refresh()
  let bottom = line('w$')
  if bottom <= 10
    return
  endif

  let top = line('w0')
  let center = ((bottom - top) / 2) + top

  call showjump#save_sign(1, 'H', top)
  call showjump#save_sign(2, 'L', bottom)
  call showjump#save_sign(3, 'M', center)

  let current = line('.')

  let up5 = current - 5
  if up5 > top && up5 != center
    call showjump#save_sign(4, '5k', up5)
  else
    call showjump#remove_sign(4)
  endif

  let down5 = current + 5
  if down5 < bottom && down5 != center
    call showjump#save_sign(5, '5j', down5)
  else
    call showjump#remove_sign(5)
  endif

  let up9 = current - 9
  if up9 > top && up9 != center
    call showjump#save_sign(6, '9k', up9)
  else
    call showjump#remove_sign(6)
  endif

  let down9 = current + 9
  if down9 < bottom && down9 != center
    call showjump#save_sign(7, '9j', down9)
  else
    call showjump#remove_sign(7)
  endif
endf

func! showjump#save_sign(id, text, line)
	silent exec 'sign define '.s:sign_prefix.a:text.' text='.a:text.' texthl=Question'
  call showjump#remove_sign(a:id)
	silent exec 'sign place '.a:id.' line='.a:line.' name='.s:sign_prefix.a:text.' buffer='.bufnr('%')
endf

func! showjump#remove_sign(id)
	silent exec 'sign unplace '.a:id.' buffer='.bufnr('%')
endf
