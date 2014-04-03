module TrickBag
module Validations

  module_function

  def raise_on_invalid_value(value, valid_values, label = 'value', output_with_inspect = true)
    missing = ! valid_values.include?(value)

    if missing
      values_display_array = output_with_inspect ? valid_values.map(&:inspect) : valid_values.map(&:to_s)
      message = "Invalid #{label}; must be one of: [#{values_display_array.join(', ')}]."
      raise message
    end
  end

end
end

