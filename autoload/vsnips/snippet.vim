" A snippet contains the following properties:
"
"   - trigger: A single word that triggers this particular snippet. Must be
"     unique.
"   - body: The actual expanded contents of the snippet.
"
function! vsnips#snippet#New()
  return {
        \ 'trigger':      '',
        \ 'body':         '',
        \ 'placeholders': [],
        \
        \ 'Blank':   function('vsnips#snippet#Blank'),
        \ 'Process': function('vsnips#snippet#Process'),
        \ }
endfunction

" A snippet is blank when either its trigger or its body are blank.
function! vsnips#snippet#Blank() dict
  return self.trigger == '' && self.body == ''
endfunction

" Go through the snippet body and set up placeholders.
function! vsnips#snippet#Process() dict
  let lineno = 0

  for line in split(self.body, "\n")
    for index in s:Matches(line, '${\(\d\+\)}')
      call add(self.placeholders, vsnips#placeholder#New([lineno, index]))
    endfor

    let lineno += 1
  endfor
endfunction

function! s:Matches(string, pattern)
  let matches = []
  let index = match(a:string, a:pattern)

  while index >= 0
    call add(matches, index)
    let index = match(a:string, a:pattern, index + 1)
  endwhile

  return matches
endfunction
