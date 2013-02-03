" A snippet contains the following properties:
"
"   - trigger: A single word that triggers this particular snippet. Must be
"     unique.
"   - body: The actual expanded contents of the snippet.
"
function! vsnips#snippet#New()
  return {
        \ 'trigger': '',
        \ 'body':    '',
        \
        \ 'Blank':   function('vsnips#snippet#Blank'),
        \ }
endfunction

" A snippet is blank when either its trigger or its body are blank.
function! vsnips#snippet#Blank() dict
  return self.trigger == '' && self.body == ''
endfunction
