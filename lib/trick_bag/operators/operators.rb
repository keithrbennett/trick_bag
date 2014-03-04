module TrickBag
module Operators

  module_function

  # Returns whether or not all passed values are equal
  def multi_eq(*values)
    values = values.first if values.is_a?(Array) && values.size == 1
    raise "Must be called with at least 2 parameters" if values.size < 2
    values[1..-1].all? { |value| value == values.first }
  end
end
end
