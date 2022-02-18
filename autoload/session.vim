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
