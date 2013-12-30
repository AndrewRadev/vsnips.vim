require 'spec_helper'

describe "Basic" do
  let(:filename) { 'test.txt' }

  specify "no placeholders" do
    add_snippet_file 'test.snippets', <<-EOF
      snippet test
      	One, two, three
    EOF

    set_file_contents <<-EOF
      test
    EOF

    vim.feedkeys 'A\<c-t>'
    vim.write

    assert_file_contents <<-EOF
      One, two, three
    EOF
  end

  specify "a single placeholder" do
    add_snippet_file 'test.snippets', <<-EOF
      snippet test
      	One, ${1}, three
    EOF

    set_file_contents <<-EOF
      test
    EOF

    vim.normal
    vim.feedkeys 'A\<c-t>'
    vim.feedkeys 'two'
    vim.write

    assert_file_contents <<-EOF
      One, two, three
    EOF
  end
end
