require 'forwardable'

module TrickBag
module Numeric


# Provides class methods for converting between the various representations
# of a bitmap: number, binary encoded string, array, and sparse array.
#
# An instance can be created that will hold on to bitmap data and be used
# to test bits and convert to other formats.
class Bitmap

  extend Forwardable

  # This is the internal representation of the bitmap value:
  attr_reader :number

  [:&, :|, :^, :hash].each do |method_name|
    def_delegator :@number, method_name
  end

  def number=(new_number)
    self.assert_nonnegative(new_number)
    @number = new_number
  end


  # The constructor is made private because:
  #
  # 1) each type of initialization requires its own validation, and it
  #    would be wasteful to do the validation unnecessarily
  # 2) to enforce that the more descriptively
  #    named class methods should be used to create instances.
  private_class_method :new


  # Class methods for converting between representations:

  # Converts from a binary string to a number, e.g. "\x01\x00" => 256
  def self.binary_string_to_number(string)
    string = string.clone.force_encoding(Encoding::ASCII_8BIT)
    string.bytes.inject(0) do |number, byte|
      number * 256 + byte.ord
    end
  end


  # Converts a number to a binary encoded string, e.g. 256 => "\x01\x00"
  def self.number_to_binary_string(number, min_length = 0)
    assert_nonnegative(number)
    binary_string = ''.force_encoding(Encoding::ASCII_8BIT)

    while number > 0
      byte_value = number & 0xFF
      binary_string << byte_value
      number >>= 8
    end

    binary_string.reverse.rjust(min_length, "\x00")
  end


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


  # Converts from a value array to a number, e.g. [8, 0, 0, 1] => 9
  def self.value_array_to_number(value_array)
    value_array.inject(&:+)
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


  # Converts an array of bit values, e.g. [1, 0, 0, 1], to a number, e.g. 9
  def self.bit_array_to_number(bit_array)
    return nil if bit_array.empty?
    multiplier = 1
    bit_array.inject(0) do |result, n|
      result += n * multiplier
      multiplier *= 2
      result
    end
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


  # Converts an array of bit position numbers to a numeric value, e.g. [0, 2] => 5
  def self.set_bit_position_array_to_number(position_array)
    return nil if position_array.empty?
    position_array.inject(0) do |result, n|
      result += 2 ** n
    end
  end


  def self.binary_string_to_bit_value_array(string)
    number = binary_string_to_number(string)
    number_to_bit_array(number)
  end

  # Class methods to create instances from the various representation types
  # handled in the class methods above:

  def self.from_number(number)
    new(number)
  end

  def self.from_binary_string(string)
    new(binary_string_to_number(string))
  end

  def self.from_value_array(array)
    new(value_array_to_number(array))
  end

  def self.from_bit_array(array)
    new(bit_array_to_number(array))
  end

  def self.from_set_bit_position_array(array)
    new(set_bit_position_array_to_number(array))
  end

  def self.from_number(number)
    new(number)
  end


  def self.assert_nonnegative(number)
    unless number.is_a?(Integer) && number >= 0
      raise ArgumentError.new(
          "Parameter must be a nonnegative Integer (Fixnum, Bignum) " +
          "but is #{number.inspect} (a #{number.class})")
    end
  end


  def to_binary_string(min_length = 0)
    self.class.number_to_binary_string(number, min_length)
  end

  def to_value_array
    self.class.number_to_value_array(number)
  end

  def to_bit_array
    self.class.number_to_bit_array(number)
  end

  def to_set_bit_position_array
    self.class.number_to_set_bit_positions_array(number)
  end


  def initialize(number)
    self.class.assert_nonnegative(number)
    @number = number
  end

  def ==(other)
    other.is_a?(self.class) && other.number == self.number
  end
end
end
end


