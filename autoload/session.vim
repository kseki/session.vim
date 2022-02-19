let s:sep = fnamemodify('.', ':p')[-1:]

if !exists('g:session_path')
  let g:session_path = '~/.vim/tmp'
endif

function! session#create_session(file) abort
  execute 'mksession!' join([g:session_path, a:file], s:sep)

  redraw
  echo 'session.vim: created'
endfunction

function! session#load_session(file) abort
  execute 'source' join([g:session_path, a:file], s:sep)
endfunction

function! s:echo_err(msg) abort
  echohl ErrorMsg
  echomsg 'session.vim' a:msg
  echohl None
endfunction

function! s:files() abort
  let session_path = get(g:, 'session_path', '')

  if session_path is# ''
    call s:echo_err('g:session_path is empty')
    return []
  endif

  let Filter = { file -> !isdirectory(session_path . s:sep . file) }

  return readdir(session_path, Filter)
endfunction

let s:session_list_buffer = 'SESSIONS'

function! session#sessions() abort
  let files = s:files()
  if empty(files)
    return
  end

  if bufexists(s:session_list_buffer)
    let winid = bufwinid(s:session_list_buffer)
    if winid isnot# -1
      call win_gotoid(winid)
    else
      execute 'sbuffer' s:session_list_buffer
    endif

  else
    execute 'new' s:session_list_buffer

    set buftype=nofile

    nnoremap <silent> <buffer>
      \ <Plug>(session-open)
      \ :<C-u>bufwinid!<CR>

    nnoremap <silent> <buffer>
      \ <Plug>(session-open)
      \ :<C-u>call session#load_session(trim(getline('.')))<CR>

    nmpa <buffer> q <Plug>(session-close)
    nmpa <buffer> <CR> <Plug>(session-open)
  endif

  %delete _
  call setline(1, files)
endfunction
