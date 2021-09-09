let s:sign_prefix = 'showjump_'

func! showjump#refresh()
  let bottom = line('w$')
  if bottom <= 10
    return
  endif

  let bottom = line('w$')
  let top = line('w0')

  call showjump#save_sign(1, 'H', top)
  call showjump#save_sign(2, 'L', bottom)

  let current = line('.')

  if get(g:, 'ryicoh#vim_showjump#5jk_enabled', 0)
    let up5 = current - 5
    if up5 > top
      call showjump#save_sign(4, '5k', up5)
    else
      call showjump#remove_sign(4)
    endif
    let down5 = current + 5
    if down5 < bottom
      call showjump#save_sign(5, '5j', down5)
    else
      call showjump#remove_sign(5)
    endif
  endif

  if get(g:, 'ryicoh#vim_showjump#9jk_enabled', 0)
    let up9 = current - 9
    if up9 > top
      call showjump#save_sign(6, '9k', up9)
    else
      call showjump#remove_sign(6)
    endif
    let down9 = current + 9
    if down9 < bottom
      call showjump#save_sign(7, '9j', down9)
    else
      call showjump#remove_sign(7)
    endif
  endif

  let saveview = winsaveview()

  if get(g:, 'ryicoh#vim_showjump#middle_enabled', 0)
    exec 'normal M'
    let middle = line(".")
    call winrestview(saveview)
    call showjump#save_sign(3, 'M', middle)
  endif

  if get(g:, 'ryicoh#vim_showjump#right_curly_enabled', 0)
    exec 'normal }'
    let right_curly = line(".")
    call winrestview(saveview)
    call showjump#save_sign(8, '}', right_curly)
  endif

  if get(g:, 'ryicoh#vim_showjump#left_curly_enabled', 0)
    exec 'normal {'
    let left_curly = line(".")
    call winrestview(saveview)
    call showjump#save_sign(9, '{', left_curly)
  endif

  if get(g:, 'ryicoh#vim_showjump#right_round_enabled', 0)
    exec 'normal ('
    let left_round = line(".")
    call winrestview(saveview)
    call showjump#save_sign(10, '(', left_round)
  endif

  if get(g:, 'ryicoh#vim_showjump#left_round_enabled', 0)
    exec 'normal )'
    let right_round = line(".")
    call winrestview(saveview)
    call showjump#save_sign(11, ')', right_round)
  endif

  let jump_list = getjumplist()
  let jumps = jump_list[0]
  let curr = jump_list[1]
  if len(jumps) > 0
    let prev = curr - 1
    let next = curr + 1
    if len(jumps) > prev && jumps[prev].lnum != current
      call showjump#save_sign(16, '<o', jumps[prev].lnum)
    else
      call showjump#remove_sign(16)
    endif
    if len(jumps) > next && jumps[next].lnum != current
      call showjump#save_sign(17, '<i', jumps[next].lnum)
    else
      call showjump#remove_sign(17)
    endif
  endif

  let change_list = getchangelist('%')
  let changes = change_list[0]
  let curr = change_list[1]
  if len(changes) > 0
    let prev = curr - 1
    let prev2 = curr - 2
    let next = curr + 1
    if len(changes) > prev && changes[prev].lnum != current
      call showjump#save_sign(18, 'g;', changes[prev].lnum)
    else
      call showjump#remove_sign(18)
    endif
    if len(changes) > next && changes[next].lnum != current
      call showjump#save_sign(20, 'g,', changes[next].lnum)
    else
      call showjump#remove_sign(20)
    endif
  endif

endf

func! showjump#save_sign(id, text, line)
	silent exec 'sign define '.s:sign_prefix.a:text.' text='.a:text.' texthl=Question'
  call showjump#remove_sign(a:id)
	silent exec 'sign place '.a:id.' line='.a:line.' name='.s:sign_prefix.a:text.' priority='.(100-a:id).' buffer='.bufnr('%')
endf

func! showjump#remove_sign(id)
	silent exec 'sign unplace '.a:id.' buffer='.bufnr('%')
endf
