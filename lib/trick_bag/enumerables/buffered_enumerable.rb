# Provides the plumbing for an enumerator that, in order to serve objects in each(),
# fetches them in chunks.
#
# This is useful, for example, in network requests, when multiple requests can be sent
# one immediately after another, and the responses can be collected as a group,
# for improved performance.
#
# The fetch method and fetcher lambda modify the instance's data array directly,
# to avoid the need to allow the lambda to modify the data array reference,
# needlessly copying arrays,
# and to eliminate the need for garbage collecting many array objects
# (though the latter is not that important).

require 'trick_bag/meta/classes'

module TrickBag
module Enumerables

class BufferedEnumerable

  include Enumerable
  extend ::TrickBag::Meta::Classes

  attr_accessor :fetcher, :fetch_notifier
  attr_reader :chunk_size

  attr_access :protected, :protected, :data
  attr_access :public,    :private,   :chunk_count, :fetch_count, :yield_count


  def self.create_with_lambdas(chunk_size, fetcher, fetch_notifier)
    instance = self.new(chunk_size)
    instance.fetcher = fetcher
    instance.fetch_notifier = fetch_notifier
    instance
  end

  # @param fetcher a lambda/proc taking the chunk size as its parameter
  # @param chunk_size how many objects to fetch at a time
  # @param fetch_notifier a lambda/proc to be called when a fetch is done;
  #        in case the caller wants to receive notification, update counters, etc.
  #        It's passed the array of objects just fetched, whose size may be
  #        less than chunk size.
  def initialize(chunk_size)
    @chunk_size = chunk_size
    @data = []
    @chunk_count = 0
    @fetch_count = 0
    @yield_count = 0
  end


  # Unless you use self.create_with_lambdas to create your instance,
  # you'll need to override this method in your subclass.
  def fetch
    fetcher.(data, chunk_size) if fetcher
  end


  # Unless you use self.create_with_lambdas to create your instance,
  # you'll need to override this method in your subclass.
  def fetch_notify
    fetch_notifier.(data) if fetch_notifier
  end


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
