module TrickBag
module Enumerables


# Decorator that wraps an Enumerable and takes a filter predicate
# to determine whether or not objects from the wrapped enumerator
# should be processed.
#
# The filter is an optional parameter on the constructor, but can
# also be set after creation with a mutator.
class FilteredEnumerable

  include Enumerable

  attr_reader :inner_enum
  attr_accessor :filter

  def initialize(inner_enum, filter = nil)
    @inner_enum = inner_enum
    @filter = filter
  end

  def each
    return to_enum unless block_given?

    inner_enum.each do |thing|
      yield thing if filter.nil? || filter.(thing)
    end
  end
end
end
end
