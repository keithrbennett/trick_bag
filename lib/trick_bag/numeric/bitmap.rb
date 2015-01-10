module TrickBag
module Numeric

  class Bitmap

    # This method is made private to enforce that the more descriptively
    # named class methods should be used to create instances!
    private_class_method :new


    # def f(string)
    #   string = string.clone.force_encoding(Encoding::ASCII_8BIT) unless string.encoding == Encoding::ASCII_8BIT
    #   string.bytes.inject(0) { |number, byte| puts "\nbyte: #{byte.ord}, number = #{number}\n"; number * 256 + byte.ord }
    # end
    def self.binary_string_to_number(string)
      string = string.clone.force_encoding(Encoding::ASCII_8BIT) unless string.encoding == Encoding::ASCII_8BIT
      string.bytes.inject(0) { |number, byte| puts "\nbyte: #{byte.ord}, number = #{number}\n"; number * 256 + byte.ord }
    end

    def self.number_to_bit_array(number)
      array = []
      while number > 0
        array << (number & 1)
        number >>= 1
      end
      array.reverse
    end
    # def g(number)
    #   array = []
    #   while number > 0
    #     array << (number & 1)
    #     number >>= 1
    #   end
    #   array.reverse
    # end

    def self.binary_string_to_array(string)
      number = binary_string_to_number(string)
      number_to_bit_array(number)
    end

    def self.from_binary_string(string)
      binary_string = string.clone.force_encoding('ASCII-8BIT')
      from_array(binary_string_to_array(binary_string))
    end

    def self.from_array(array)
      new(array)
    end

    def self.from_sparse_array

    end

    def to_binary_string

    end

    def to_array

    end

    def to_sparse_array

    end

    def on?(n)

    end

    def off?(n)

    end

    def self.bit_count(string)

    end; private :bit_count

    def initialize(array)
      @array = array
    end
  end

end
end
