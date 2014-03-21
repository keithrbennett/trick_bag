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

  attr_reader :wrapped_enumerator
  attr_accessor :filter

  def initialize(wrapped_enumerator, filter = ->(_) { true })
    @wrapped_enumerator = wrapped_enumerator
    @filter = filter
  end

  def each
    return to_enum unless block_given?

    wrapped_enumerator.each do |thing|
      yield thing if filter.(thing)
    end
  end
end
end
end
