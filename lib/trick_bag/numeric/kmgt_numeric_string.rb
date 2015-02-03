module TrickBag
module Numeric


# Converts number strings with optional suffixes of [kKmMgGtT] to integers.
# Upper case letters represent powers of 1024, and lower case letters represent powers of 1000
# (see MULTIPLIERS below).
#
# Also supports ranges, e.g. '1k..5k' will be converted by to_range to (1000..5000).
#
# Methods are to_number, to_range, and to_number_or_range.  See tests for usage examples.
module KmgtNumericString

  MULTIPLIERS = {
      'k' => 1_000,
      'K' => 1_024,
      'm' => 1_000 ** 2,
      'M' => 1_024 ** 2,
      'g' => 1_000 ** 3,
      'G' => 1_024 ** 3,
      't' => 1_000 ** 4,
      'T' => 1_024 ** 4,
  }

  VALID_STRING_SUFFIXES = MULTIPLIERS.keys

  VALID_STRING_REGEX = /^-?\d+/  # only digits with optional minus sign prefix

  module_function

  # Converts a numeric string (e.g. '3', '2k') to a number.
  # If the passed parameter is not a string, it is returned unchanged.
  # This eliminates the need for the caller to do their own type test.
  def to_number(object)
    object.is_a?(String) ? ToNumberConverter.new(object).to_number : object
  end

  # Returns whether or not this is a number range string.  Specifically, tests that
  # the string contains only 2 numeric strings separated by '..'.
  def range_string?(string)
    return false unless string.is_a?(String)
    number_strings = string.split('..')
    number_strings.size == 2 && number_strings.all? { |str| VALID_STRING_REGEX.match(str) }
  end

  # Converts the passed string to a range (see range_string? above for the string's format).
  # If the passed parameter is nil or is a Range already, returns it unchanged.
  # This eliminates the need for the caller to do their own type test.
  def to_range(object)
    return object if object.is_a?(Range) || object.nil?
    unless range_string?(object)
        raise ArgumentError.new("Invalid argument (#{object}); Range must be 2 numbers separated by '..', e.g. 10..20 or 900K..1M")
    end
    numbers = object.split('..').map { |s| to_number(s) }
    (numbers.first..numbers.last)
  end

  # Converts a string such as '3' or '1k..2k' into a number or range.
  # If nil or an Integer or Range is passed, it is returned unchanged.
  # This eliminates the need for the caller to do their own type test.
  def to_number_or_range(object)
    case object
      when Integer, Range, NilClass
        object
      when String
        range_string?(object) ? to_range(object) : to_number(object)
      else
        raise ArgumentError.new("Invalid argument, class is #{object.class}, object is (#{object}).")
      end
  end


# This class is here to simplify implementation and is not intended
# to be instantiated by users of this module.
  class ToNumberConverter

    def initialize(string)
      @string = string.dup.gsub('_', '')
      assert_valid_input(@string)
    end

    def assert_valid_input(string)
      unless VALID_STRING_REGEX.match(string)
        raise ArgumentError.new(
            "Bad arg (#{string}); must be an integer, optionally followed by one of [" +
            MULTIPLIERS.keys.join + '], optionally with underscores.')
      end
    end

    def to_number
      last_char = @string[-1]
      if VALID_STRING_SUFFIXES.include?(last_char)
        multiplier = MULTIPLIERS[last_char]
        Integer(@string.chop) * multiplier
      else
        Integer(@string)
      end
    end
  end
end
end
end
