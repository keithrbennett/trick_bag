module TrickBag
module Numeric

# Simplifies accumulating counts of multiple objects.
# Like a hash, but does not allow []=; increment is the only way to modify a value.
class MultiCounter

  attr_accessor :name

  # Creates a multicounter.
  #
  # @param name optional name for printing in to_s
  def initialize(name = '')
    @name = name
    @counts = Hash.new(0)
  end

  # Creates an instance and iterates over the enumberable, processing all its items.
  def self.from_enumerable(values, name = '')
    m_counter = MultiCounter.new(name)
    values.each { |value| m_counter.increment(value) }
    m_counter
  end

  # Adds keys in the passed enumerable to this counter.
  def add_keys(keys)
    keys.each { |key| @counts[key] = 0 }
  end

  # Increments the value corresponding to the specified key.
  def increment(key)
    @counts[key] += 1
  end

  # Returns the count for the specified key.
  def [](key)
    @counts[key]
  end

  # Returns this counter's keys.
  def keys
    @counts.keys
  end

  # Returns whether or not the specified key exists in this counter.
  def key_exists?(key)
    keys.include?(key)
  end

  # Returns the total of all counts.
  def total_count
    @counts.values.inject(0, &:+)
  end

  # Private internal method for use by percent_of_total_hash
  # and fraction_of_total_hash.
  # @param mode :percent or :fraction
  def of_total_hash(mode = :percent)
    raise "bad mode: #{mode}" unless [:percent, :fraction].include?(mode)
    total = total_count
    keys.each_with_object({}) do |key, ptotal_hash|
      value = Float(self[key]) / total
      value *= 100 if mode == :percent
      ptotal_hash[key] = value
    end
  end; private :of_total_hash

  # Returns a hash whose keys are the multicounter's keys and whose values
  # are the percent of total of the values corresponding to those keys.
  def percent_of_total_hash
    of_total_hash(:percent)
  end
  # Returns a hash whose keys are the multicounter's keys and whose values
  # are the fraction of total of the values corresponding to those keys.
  def fraction_of_total_hash
    of_total_hash(:fraction)
  end

  # Creates a hash whose keys are this counter's keys, and whose values are
  # their corresponding values.
  def to_hash
    @counts.clone
  end

  # Returns a string representing this counter, including its values,
  # and, if specified, its optional name.
  def to_s
    "#{self.class} '#{name}': #{@counts.to_s}"
  end
end
end
end


=begin

Here is a sample script that exercises some of this class' features:

#!/usr/bin/env ruby

require 'trick_bag'
require 'awesome_print'

data = %w(Open New Open Closed Open New Closed Open Open Open)
m_counter = TrickBag::Numeric::MultiCounter.from_enumerable(data, 'Status for Issue #123')
puts "\nMultiCounter hash:"
ap m_counter.to_hash

puts "\nNumber Open:"
puts m_counter['Open']

pc_totals = m_counter.percent_of_total_hash
puts "\nPercents of Total:"
ap pc_totals


# Output is:
#
# MultiCounter hash:
# {
#       "Open" => 6,
#        "New" => 2,
#     "Closed" => 2
# }
#
# Number Open:
# 6
#
# Percents of Total:
# {
#       "Open" => 0.6,
#        "New" => 0.2,
#     "Closed" => 0.2
# }

=end

