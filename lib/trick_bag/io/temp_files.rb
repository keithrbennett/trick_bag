module TrickBag
module Io
module TempFiles

    module_function

    def self.file_containing(text, file_prefix = '')
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
