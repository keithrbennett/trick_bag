module TrickBag
module Enumerables


# Decorator that wraps an Enumerable and takes a filter predicate
# to determine whether or not objects from the wrapped enumerator
# should be processed.
#
# The filter is an optional parameter on the constructor, but can
# also be set after creation with a mutator.
#
# If you do not intend to change the filter after it is created,
# you should probably just use Ruby's built in lazy enumerators, as in:
# e = (1..10000000000000000000000000000).lazy.select { |n| n.even? }.lazy
#
# This class really comes in handy when the filter needs to be changed during
# the enumerator's lifetime.

class FilteredEnumerable

  include Enumerable

  attr_reader :wrapped_enumerator
  attr_accessor :filter

  # @param wrapped_enumerator the enumerator to filter
  # @param filter a lambda that returns whether or not to yield a given object,
  #         defaults to lambda always returning true
  def initialize(wrapped_enumerator, filter = ->(_) { true })
    @wrapped_enumerator = wrapped_enumerator
    @filter = filter
  end

  # Standard Enumerable.each; returns an Enumerator if called without a block
  def each
    return to_enum unless block_given?

    wrapped_enumerator.each do |thing|
      yield thing if filter.(thing)
    end
  end
end
end
end
