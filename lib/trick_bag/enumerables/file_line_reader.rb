require 'trick_bag/numeric/start_and_max'

module TrickBag
module Enumerables

# Reads a file containing strings, one on each line, and feeds them
# in its each() method.  Strips all lines leading and trailing whitespace,
# and ignores all empty lines and lines beginning with the comment character '#'.
#
# If calling each without a block to get an enumerator, call enumerator.close when done
# if not all values have been exhausted, so that the input file will be closed.
#
# Supports specifying a starting position and maximum count.  For example
# if the starting position is 2, then the first 2 valid lines will be
# discarded, and yielding will begin with the next valid line.
#
# Similarly, specifying a maximum count will cause yielding to end after
# max_count objects have been yielded.
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

  # @return the position of the first valid object to be yielded.
  def start_pos
    start_and_max.start_pos
  end


  # @return the maximum number of objects to be yielded
  def max_count
    start_and_max.max_count
  end


  # @param line the line to test
  # @return whether or not this line is valid (eligible for yielding),
  #        specifically not empty and not a comment
  def line_valid?(line)
    ! (line.empty? || /^#/ === line)
  end


  # Closes the file if it is not null and has not already been closed
  def close_file(file)
    if file && (! file.closed?)
      file.close
    end
  end


  # Any enumerator returned should have a close method to close the file
  # from which lines are read.  This method gets an enumerator from the superclass,
  # and adds a 'file' attribute and a close method to it.
  def to_enum(file)
    enumerator = super()
    enumerator.instance_variable_set(:@file, file)

    # This method is defined on the instance of the new enumerator.
    # It closes the input file.
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


  def to_s
    "#{self.class}: filespec: #{filespec}, start_pos: #{start_pos.inspect}, max_count: #{max_count.inspect}"
  end
end
end
end
