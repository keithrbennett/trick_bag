module TrickBag
module Numeric
module Totals

  module_function

  # @inputs an enumerable of numbers
  # @return a collection containing the corresponding fractions of total of those numbers
  def map_fraction_of_total(inputs)
    return [] if inputs.size == 0
    sum = Float(inputs.inject(:+))
    inputs.map { |n| n / sum }
  end


  # @inputs an enumerable of numbers
  # @return a collection containing the corresponding percents of total of those numbers
  def map_percent_of_total(inputs)
    map_fraction_of_total(inputs).map { |n| n * 100 }
  end


  # Given a hash whose values are numbers, produces a new hash with the same keys
  # as the original hash, but whose values are the % of total.
  # Ex: for input  { foo: 100, bar: 200, baz: 300, razz: 400 }, value returned would be
  # { foo: 10.0, bar: 20.0, baz: 30.0, razz: 40.0 }.
  def fraction_of_total_hash(the_hash)
    new_hash = percent_of_total_hash(the_hash)
    new_hash.keys.each do |key|
      new_hash[key] = new_hash[key] / 100.0
    end
    new_hash
  end


  # Given a hash whose values are numbers, produces a new hash with the same keys
  # as the original hash, but whose values are the % of total.
  # Ex: for input  { foo: 100, bar: 200, baz: 300, razz: 400 }, value returned would be
  # { foo: 10.0, bar: 20.0, baz: 30.0, razz: 40.0 }.
  def percent_of_total_hash(the_hash)
    sum = Float(the_hash.values.inject(:+))
    keys = the_hash.keys
    keys.each_with_object({}) do |key, percent_total_hash|
      percent_total_hash[key] = 100 * the_hash[key] / sum
    end
  end
end
end
end
