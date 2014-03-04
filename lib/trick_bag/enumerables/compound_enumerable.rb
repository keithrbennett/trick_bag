require 'trick_bag/collections/linked_list'
require 'trick_bag/meta/classes'

module TrickBag
module Enumerables

# An enumerator Used to provide all combinations of a set of Enumerables.

# For example, for blood types [:a, :b, :ab, :o] and rh [:+, :-],
# provides an enumerator whose 'each' method gives:
#
# [:a, :+]
# [:a, :-]
# [:b, :+]
# [:b, :-]
# [:ab, :+]
# [:ab, :-]
# [:o, :+]
# [:o, :-]
#
# Initialized with enumerables whose 'each' method returns an Enumerator
# when no block is provided.
#
# Guaranteed to follow the order as shown above, that is, each value of
# the first enumerable will be processed in its entirety before advancing
# to the next value.
#
# Can be used with an arbitrary number of enumerables.
class CompoundEnumerable

  include Enumerable
  extend ::TrickBag::Meta::Classes

  attr_reader :enum_count, :keys
  private_attr_reader :enumerables
  attr_reader :mode

  # Creates a compound enumerable that returns a hash whenever 'each' is called
  def self.hash_enumerable(keys, *enumerables)
    self.new(:yields_hashes, keys, *enumerables)
  end


  # Creates a compound enumerable that returns an array whenever 'each' is called
  def self.array_enumerable(*enumerables)
    self.new(:yields_arrays, nil, *enumerables)
  end



  def initialize(mode, keys, *enumerables)

    validate_inputs = ->do
      raise "Mode must be either :yields_arrays or :yields_hashes" unless [:yields_arrays, :yields_hashes].include?(mode)
      raise "Keys not provided" if mode == :yields_hashes && (! keys.is_a?(Array))
      raise "No enumerables provided" if enumerables.empty?

      if mode == :yields_hashes && (keys.size != enumerables.size)
        raise "Key array size (#{keys.size}) is different from enumerables size (#{enumerables.size})."
      end

    end

    validate_inputs.()
    @enumerables = enumerables
    @enum_count = enumerables.size
    @mode = mode
    @keys = keys
  end


  def each(&block)
    return to_enum unless block_given?
    return if enum_count == 0
    initial_value = mode == :yields_arrays ? [] : {}
    each_multi_enumerable(0, ::TrickBag::Collections::LinkedList.new(*@enumerables).first, initial_value, &block)
  end


  # This method will be called recursively down the list of enumerables.
  # @param node will advance to the next node for each recursive call
  # @param values will be a list of values collected on the stack
  def each_multi_enumerable(depth, node, values, &block)
    enumerable = node.value
    is_deepest_enumerable = node.next.nil?

    as_array = ->(thing) do
      new_value_array = values + [thing]
      if is_deepest_enumerable
        yield *new_value_array
      else
        each_multi_enumerable(depth + 1, node.next, new_value_array, &block)
      end
    end

    as_hash = ->(thing) do
      key = keys[depth]
      new_values = values.clone
      new_values[key] = thing
      if is_deepest_enumerable
        yield new_values
      else
        each_multi_enumerable(depth + 1, node.next, new_values, &block)
      end
      new_values
    end

    enumerable.each do |thing|
      mode == :yields_arrays ? as_array.(thing) : as_hash.(thing)
    end
  end
end
end
end
