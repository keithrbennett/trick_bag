require 'trick_bag/numeric/start_and_max'

module TrickBag
module Enumerables

# Reads a file containing strings, one on each line, and feeds them
# in its each() method.  Strips all lines leading and trailing whitespace,
# and ignores all empty lines and lines beginning with the comment character '#'.
#
# If calling each without a block to get an enumerator, call enumerator.close when done
# if not all values have been exhausted, so that the input file will be closed.
class FileLineReader

  include Enumerable

  attr_reader :filespec, :start_and_max

  # @param filespec - the file from which to read domain names; blank/empty lines and lines
  #                   with the first nonblank character == '#' will be ignored.
  # @param start_pos - the record number, zero offset, at which to begin each() processing
  # @param max_count - the maximum number of records to be served by each()
  def initialize(filespec, start_pos = :first, max_count = :infinite)
    @filespec = filespec
    @start_and_max = TrickBag::Numeric::StartAndMax.new(start_pos, max_count)
  end


  def line_valid?(line)
    ! (line.empty? || /^#/ === line)
  end


  def close_file(file)
    if file && (! file.closed?)
      file.close
    end
  end


  # Any enum returned should have a close method to close the file from which lines are read.
  # Get the enumerator from the superclass, and add a close method to it.
  def to_enum(file)
    enumerator = super()
    enumerator.instance_variable_set(:@file, file)

    def enumerator.close
      if @file && (! @file.closed?)
        @file.close
        @file = nil
      end
    end

    enumerator
  end


  # Returns an Enumerator if called without a block; in that case, remember
  # to close the file explicitly by calling the enumerator's close method
  # if you finish using it before all values have been exhausted.
  def each

    file = File.open(filespec, 'r')
    return to_enum(file) unless block_given?

    valid_record_num = 0
    yield_count = 0

    begin

      file.each do |line|
        line.strip!
        if line_valid?(line)
          if start_and_max.start_position_reached?(valid_record_num)
            yield(line)
            yield_count += 1
            if start_and_max.max_count_reached?(yield_count)
              return
            end
          end

          valid_record_num += 1
        end
      end

    ensure
      close_file(file)
    end
  end
end
end
end
