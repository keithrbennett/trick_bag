module TrickBag
module Numeric

# Supports multiple counts, each identified by a key.
# Like a hash, but does not allow []=; increment is the only way to modify a value.
class MultiCounter

  attr_accessor :name

  def initialize(name = '')
    @name = name
    @counts = Hash.new(0)
  end

  def add_keys(keys)
    keys.each { |key| @counts[key] = 0 }
  end

  def increment(key)
    @counts[key] += 1
  end

  def [](key)
    @counts[key]
  end

  def keys
    @counts.keys
  end

  def key_exists?(key)
    keys.include?(key)
  end

  def to_hash
    @counts.clone
  end

  def to_s
    "#{self.class} '#{name}': #{@counts.to_s}"
  end
end
end
end
