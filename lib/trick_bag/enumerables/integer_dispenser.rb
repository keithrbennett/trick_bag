module TrickBag
module Enumerables

# Provides a 'next' method with which sequential numbers can be gotten,
# with a required first value and optional minimum and maximum values as parameters.
class IntegerDispenser

  attr_accessor :first_value, :min_value, :max_value

  # @param first_value  first value to be returned by #next
  # @param min_value  minimum value to be returned by next
  # @param max_value  maximum value to be returned by next
  def initialize(first_value, min_value = 1, max_value = 2 ** 31 - 1)
    if min_value > max_value
      raise "Min value (#{min_value}) > max value (#{max_value})."
    end

    unless (min_value..max_value).include?(first_value)
      raise "First value (#{first_value}) is not between #{min_value} and #{max_value}."
    end

    @first_value = first_value
    @min_value = min_value
    @max_value = max_value
    @value = nil
  end

  def next
    @value = @value ? @value.next : @first_value
    if @value > @max_value
      @value = @min_value
    end
    @value
  end
end
end
end
