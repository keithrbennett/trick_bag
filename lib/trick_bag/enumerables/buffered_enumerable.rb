
require 'trick_bag/meta/classes'

module TrickBag
module Enumerables

# Provides the plumbing for an enumerator that, in order to serve objects in each(),
# fetches them in chunks.
#
# This class knows nothing about how to fetch anything; that behavior is provided
# by either subclassing this class, or calling .create_with_callables and passing
# a callable that knows how to do that.
#
# Also supported is an optional fetch notification, a method or callable that will
# be called whenever a fetch is done.  This can be useful to update counters,
# provide user feedback (e.g. a progress bar), etc.
#
# This is useful, for example, in network requests, when multiple requests can be sent
# one immediately after another, and the responses can be collected as a group,
# for improved performance.
#
# The fetch method and fetcher callable modify the instance's data array directly,
# to avoid the need to allow the callable to modify the data array reference,
# needlessly copying arrays, and to eliminate the need for garbage collecting
# many array objects (though the latter is rarely important).
class BufferedEnumerable

  include Enumerable

  extend ::TrickBag::Meta::Classes

  attr_accessor :fetcher, :fetch_notifier
  attr_reader :chunk_size

  attr_access :protected, :protected, :data
  attr_access :public,    :private,   :chunk_count, :fetch_count, :yield_count

  class NoFetcherError < RuntimeError; end


  # Creates an instance with callables for fetch and fetch notify behaviors.
  # Callables are usually lambdas but can be any object responding to the method name `call`.
  # @param chunk_size the maximum number of objects to be buffered
  # @param fetcher callable to be called to fetch to fill the buffer
  # @param fetch_notifier callable to be called to when a fetch is done
  #        in case the caller wants to receive notification, update counters, etc.
  #        It's passed the array of objects just fetched, whose size may be
  #        less than chunk size.
  def self.create_with_callables(chunk_size, fetcher, fetch_notifier = nil)
    instance = self.new(chunk_size)
    instance.fetcher = fetcher
    instance.fetch_notifier = fetch_notifier
    instance
  end


  class << self
    alias_method :create_with_lambdas, :create_with_callables
  end


  # @param chunk_size the maximum number of objects to be buffered
  def initialize(chunk_size)
    @chunk_size = chunk_size
    @data = []
    @chunk_count = 0
    @fetch_count = 0
    @yield_count = 0
  end


  # Unless you use self.create_with_callables to create your instance,
  # you'll need to override this method in your subclass.
  def fetch
    if fetcher
      fetcher.(data, chunk_size)
    else
      raise NoFetcherError.new
    end
  end


  # Unless you use self.create_with_callables to create your instance,
  # you'll need to override this method in your subclass.
  def fetch_notify
    fetch_notifier.(data) if fetch_notifier
  end


  # Enumerable.each method.
  # Note that, like all Enumerable.each methods, if you pass it without a block,
  # it will return an enumerator, and any cleanup that would normally be done
  # after each's loop has completed will not happen.
  def each
    return to_enum unless block_given?

    last_chunk = false
    loop do
      if data.empty?
        return if last_chunk
        fetch
        @chunk_count += 1
        return if data.empty?
        self.fetch_count = self.fetch_count + data.size
        last_chunk = true if data.size < chunk_size
        fetch_notify
      end

      self.yield_count = self.yield_count + 1
      object_to_yield = data.shift
      yield(object_to_yield)
    end
  end
end
end
end
