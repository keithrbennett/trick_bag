module TrickBag
module Enumerables

# Takes an array as input.  On successive calls to next, it returns the next
# element in the array until the array has been exhausted, and then returns
# the last element every time it's called.
#
# You can use Ruby's array addition and multiplication features
# to provide rich functionality, e.g.:
#
#     array = [1] + [15]*3 + [60]*15 + [300]
#
# Values should only be nonzero positive integers.
  class EndlessLastEnumerable

    include Enumerable

    attr_reader :array

    def initialize(array_or_number)
      @array = case array_or_number
        when Array
         array_or_number
        when Numeric
         [array_or_number]
        else
         raise RuntimeError.new("Unsupported data type (#{array_or_number.class}.")
        end
      @pos = 0
    end


    def each
      return to_enum unless block_given?
      loop do
        if @pos >= @array.size
          value = @array.last
        else
          value = @array[@pos]
          @pos += 1
        end
        yield(value)
      end
    end


    def ==(other)   # mostly for testing
      other.is_a?(self.class) && other.array == array
    end
  end
end
end
