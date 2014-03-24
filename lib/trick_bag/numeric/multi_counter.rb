module TrickBag
module Numeric

# Supports multiple counts, each identified by a key.
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
