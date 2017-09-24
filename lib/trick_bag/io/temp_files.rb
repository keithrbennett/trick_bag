require 'tempfile'

module TrickBag
module Io
module TempFiles

    module_function

    # For the easy creation and deletion of a temp file populated with text,
    # wrapped around the code block you provide.
    #
    # @param text the text to write to the temporary file
    # @param file_prefix optional prefix for the temporary file's name
    # @yield filespec of the temporary file
    def file_containing(text, file_prefix = '')
      raise "This method must be called with a code block." unless block_given?

      filespec = nil
      begin
        Tempfile.open(file_prefix) do |file|
          file << text
          filespec = file.path
        end
        yield(filespec)
      ensure
        File.delete filespec if filespec && File.exist?(filespec)
      end
    end
  end
end
end
