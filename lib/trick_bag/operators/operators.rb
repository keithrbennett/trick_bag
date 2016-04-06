module TrickBag
module Operators

  module_function

  # Returns whether or not all passed values are equal
  #
  # Ex: multi_eq(1, 1, 1, 2) => false; multi_eq(1, 1, 1, 1) => true
  def multi_eq(*values)
    # If there is only 1 arg, it must be an array of at least 2 elements.
    values = values.first if values.first.is_a?(Array) && values.size == 1
    raise ArgumentError.new("Must be called with at least 2 parameters; was: #{values.inspect}") if values.size < 2
    values[1..-1].all? { |value| value == values.first }
  end
end
end
