require 'forwardable'
require_relative 'bit_mapping'

module TrickBag
module Numeric


# Provides class methods for converting between the various representations
# of a bitmap: number, binary encoded string, array, and sparse array.
#
# An instance can be created that will hold on to bitmap data and be used
# to test bits and convert to other formats.
#
# Where an array is used to represent bits, the first element (#0) will be the
# high bit and the last bit will be the 1's bit.
class Bitmap

  extend Forwardable


  # This is the internal representation of the bitmap value:
  attr_reader :number

  # Some instance methods can be delegated to this number:
  [:&, :|, :^, :hash].each do |method_name|
    def_delegator :@number, method_name
  end

  # Set a new value to number, validating first that it is nonnegative.
  def number=(new_number)
    self.assert_non_negative(new_number)
    @number = new_number
  end


  # The constructor is made private because:
  #
  # 1) each type of initialization requires its own validation, and it
  #    would be wasteful to do the validation unnecessarily
  # 2) to enforce that the more descriptively
  #    named class methods should be used to create instances.
  private_class_method :new


  # Class methods to create instances from the various representation types
  # handled in the BitMapping module's methods.

  # Creates an instance from a nonnegative number.
  def self.from_number(number)
    new(number)
  end

  # Creates an instance from a binary string (e.g. "\x0C").
  def self.from_binary_string(string)
    new(BitMapping.binary_string_to_number(string))
  end

  # Creates an instance from a value array (e.g.)
  def self.from_value_array(array)
    new(BitMapping.value_array_to_number(array))
  end

  def self.from_bit_array(array)
    new(BitMapping.bit_array_to_number(array))
  end

  def self.from_set_bit_position_array(array)
    new(BitMapping.set_bit_position_array_to_number(array))
  end

  def to_binary_string(min_length = 0)
    BitMapping.number_to_binary_string(number, min_length)
  end

  def to_value_array
    BitMapping.number_to_value_array(number)
  end

  def to_bit_array
    BitMapping.number_to_bit_array(number)
  end

  def to_set_bit_position_array
    BitMapping.number_to_set_bit_positions_array(number)
  end

  def initialize(number)
    BitMapping.assert_non_negative(number)
    @number = number
  end

  def ==(other)
    other.is_a?(self.class) && other.number == self.number
  end
end
end
end


