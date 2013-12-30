" A placeholder is a modifiable part of a snippet.
"
" TODO (2013-11-03) Length, end coordinates?
" TODO (2013-11-03) "position" or "x" + "y"?
function! vsnips#placeholder#New(position)
  return {
        \ 'position': a:position,
        \ }
endfunction
