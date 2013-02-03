" Called when the user presses the snippet keybinding. Locates the snippet
" trigger before the cursor and expands it into its full text.
function! vsnips#ExpandSnippet()
  " Information on the current cursor position
  let position = getpos('.')

  " The current line as a string
  let line = getline(position[1])

  " The current column as a number
  let col = position[2]

  " The beginning of the line up to the cursor position
  let beginning_of_line = line[0:col - 2]

  for snippet in vsnips#SnippetsForFiletype(&filetype)
    " If the line up to the cursor ends with the snippet trigger, then this is
    " what we're looking for.
    if beginning_of_line =~ snippet.trigger.'$'
      " The actual match, in case the trigger is a regular expression (should
      " this be disallowed?)
      let trigger   = beginning_of_line[len(beginning_of_line) - len(snippet.trigger):]
      let expansion = snippet.body

      " Replace the trigger with the expansion
      exe 's/'.escape(trigger, '/').'$/'.escape(expansion, '/').'/'

      " Update the cursor position
      let position[2] += len(expansion) - len(trigger)

      break
    endif
  endfor

  " Set the modified cursor position
  call setpos('.', position)

  return ''
endfunction

" Parses all snippet files and generates snippet objects. Currently ignores
" requested filetype.
"
" TODO (2013-02-02) Needs to cache results somehow.
function! vsnips#SnippetsForFiletype(filetype)
  " TODO (2011-12-18) a:filetype ignored for now

  let snippets = []

  for file in g:vsnips_snippet_files
    call extend(snippets, vsnips#ParseSnippetFile(file))
  endfor

  return snippets
endfunction

" Parses the given snippet file and returns a list of snippets defined in it.
"
" TODO (2013-02-03) Handle empty lines
" TODO (2013-02-03) Handle syntax errors
function! vsnips#ParseSnippetFile(filename)
  let snippets = []

  " Prepare a new snippet to build up
  let current_snippet       = vsnips#snippet#New()
  let current_snippet_lines = []

  " Iterate through every line in the file
  for line in readfile(a:filename)
    if line =~ '^snippet'
      " then we need to start a new snippet

      if !current_snippet.Blank()
        " then we need to finish the current one and initialize a new one
        let current_snippet.body = join(current_snippet_lines, "\n")
        call add(snippets, current_snippet)

        let current_snippet       = vsnips#snippet#New()
        let current_snippet_lines = []
      endif

      " Extract and set the trigger
      let current_snippet.trigger = substitute(line, 'snippet \(.*\)$', '\1', '')
    elseif line =~ '^\t'
      " then the line is part of the body, store it for later, sans the tab
      call add(current_snippet_lines, substitute(line, '^\t\(.*\)$', '\1', ''))
    endif
  endfor

  " Add final snippet
  if !current_snippet.Blank()
    let current_snippet.body = join(current_snippet_lines, "\n")
    call add(snippets, current_snippet)
  endif

  return snippets
endfunction
