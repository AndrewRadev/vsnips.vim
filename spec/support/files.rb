require 'tempfile'

module Support
  module Files
    def set_file_contents(string)
      write_file(filename, string)
      @vim.edit!(filename)
    end

    def file_contents
      IO.read(filename).chop # remove trailing newline
    end

    def assert_file_contents(string)
      file_contents.should eq normalize_string_indent(string)
    end

    def add_snippet_file(filename, string)
      write_file(filename, string)
      @vim.command("call add(g:vsnips_snippet_files, '#{filename}')")
    end
  end
end
