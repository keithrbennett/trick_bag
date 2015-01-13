module TrickBag
module Numeric


# Provides class methods for converting between the various representations
# of a bitmap: number, binary encoded string, array, and sparse array.
#
# An instance can be created that will hold on to bitmap data and be used
# to test bits and convert to other formats.
class Bitmap

  # The constructor is made private because:
  #
  # 1) each type of initialization requires its own validation, and it
  #    would be wasteful to do the validation unnecessarily
  # 2) to enforce that the more descriptively
  #    named class methods should be used to create instances.
  private_class_method :new


  # Class methods for converting between representations:

  def self.binary_string_to_number(string)
    string = string.clone.force_encoding(Encoding::ASCII_8BIT)
    string.bytes.inject(0) do |number, byte|
      number * 256 + byte.ord
    end
  end


  def self.assert_nonnegative(number)
    raise ArgumentError.new("Number was #{number} but must >= 0") if number < 0
  end
  private_class_method :assert_nonnegative


  # Converts a number to an array of place values, e.g. 9 => [8, 0, 0, 1]
  def self.number_to_value_array(number)
    assert_nonnegative(number)
    array = []
    bit_value = 1
    while number > 0
      array << ((number & 1 == 1) ? bit_value : 0)
      number >>= 1
      bit_value <<= 1
    end
    array.reverse
  end

  # Converts a number to an array of bit values, e.g. 9 => [1, 0, 0, 1]
  def self.number_to_bit_array(number)
    assert_nonnegative(number)
    array = []
    while number > 0
      array << (number & 1)
      number >>= 1
    end
    array.reverse
  end


  # Converts a number to a sparse array containing bit positions that are set/true/1.
  # Note that these are bit positions, e.g. 76543210, and not bit column values
  # such as 128/64/32/16/8/4/2/1.
  def self.number_to_set_bit_positions_array(number)
    assert_nonnegative(number)
    array = []
    position = 0
    while number > 0
      array << position if number & 1 == 1
      position += 1
      number >>= 1
    end
    array
  end

  # Converts a number to a binary encoded string, e.g. 256 => "\x01\x00"
  def self.number_to_binary_string(number)
    assert_nonnegative(number)
    binary_string = ''.force_encoding(Encoding::ASCII_8BIT)

    while number > 0
      byte_value = number & 0xFF
      binary_string << byte_value
      number >>= 8
    end

    binary_string.reverse
  end


  def self.binary_string_to_bit_value_array(string)
    number = binary_string_to_number(string)
    number_to_bit_array(number)
  end

  # Class methods to create instances from the various representation types:

  # def self.from_binary_string(string)
  #   binary_string = string.clone.force_encoding('ASCII-8BIT')
  #   from_array(binary_string_to_array(binary_string))
  # end

  def self.from_array(array)
    new(array)
  end

  def self.from_number(number)
    assert_nonnegative(number)
    unless [Fixnum, Bignum].include?(number.class)
      raise ArgumentError("#{number} is a #{number.class}, not a Fixnum or Bignum")
    end
  end


  def self.from_sparse_array

  end

  def on?(n)

  end

  def off?(n)

  end

  # @return the number of bits in the string; assumes that the string's
  #         chars are all 1 byte in length, as in Encoding::ASCII_8BIT.
  def self.bit_count(string)
    string.size * 8
  end; private_class_method :new, :bit_count


  def initialize(number)
    @number = number
  end

  def &(bit)
    unless bit % 2 == 0
      raise ArgumentError.new("Bit was #{bit} but must be a multiple of 2.")
    end
    @number & bit
  end

end
end
end


