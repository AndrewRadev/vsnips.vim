require 'spec_helper'

describe "Basic" do
  let(:vim)      { VIM }
  let(:filename) { 'test.txt' }

  specify "simple snippets are just expanded to their text" do
    add_snippet_file 'test.snippets', <<-EOF
      snippet test
      	One, two, three
    EOF

    set_file_contents <<-EOF
      test
    EOF

    # TODO (2013-02-03) Make this simpler
    vim.command 'exe "normal A\\<c-t>"'
    vim.write

    assert_file_contents <<-EOF
      One, two, three
    EOF
  end
end
