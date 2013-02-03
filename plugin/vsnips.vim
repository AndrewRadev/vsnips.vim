if exists('g:loaded_vsnips') || &cp
  finish
endif

let g:loaded_vsnips = '0.0.1' " version number
let s:keepcpo = &cpo
set cpo&vim

" TODO (2013-02-02) Hardcoded to examples/*.snippets for easy experimentation
let s:root_dir             = expand('<sfile>:p:h:h')
let g:vsnips_snippet_files = split(globpath(s:root_dir, 'examples/*.snippets'), "\n")

" TODO (2013-02-02) Temporary mapping in order to avoid conflicts with
" snipMate
inoremap <c-t> <c-r>=vsnips#ExpandSnippet()<cr>

let &cpo = s:keepcpo
unlet s:keepcpo
