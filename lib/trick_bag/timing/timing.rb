require 'trick_bag/io/text_mode_status_updater'
require 'benchmark'

module TrickBag
module Timing


  module_function


  # Calls a predicate proc repeatedly, sleeping the specified interval
  # between calls, and giving up after the specified number of seconds.
  # Displays elapsed and remaining times on the terminal.
  #
  # @param predicate something that can be called with .() or .call
  #   that returns a truthy value that indicates no further retries are necessary
  # @param sleep_interval  number of seconds (fractions ok) to wait between tries
  # @param timeout_secs maximum number of seconds (fractions ok) during which to retry
  # @return true if/when the predicate returns true, false if it times out
  #
  # Ex: TrickBag::Timing.retry_until_true_or_timeout(->{false}, 1.0, 5)
  #
  # Example Code:
  #
  # require 'trick_bag'
  # predicate = -> { false }
  # print "Waiting 10 seconds for true to be returned (but it won't):\n"
  # TrickBag::Timing.retry_until_true_or_timeout(predicate, 1, 10)
  def retry_until_true_or_timeout(
      sleep_interval, timeout_secs, output_stream = $stdout, predicate = nil)


    # Method signature has changed from:
    # (predicate, sleep_interval, timeout_secs, output_stream = $stdout)
    # to:
    # (sleep_interval, timeout_secs, output_stream = $stdout, predicate = nil)
    #
    # Test to see that when old signature is used, a descriptive error is raised.
    #
    # This test should be removed when we go to version 1.0.
    if sleep_interval.respond_to?(:call)
      raise ArgumentError.new('Sorry, method signature has changed to: ' \
            '(sleep_interval, timeout_secs, output_stream = $stdout, predicate = nil).' \
            '  Also a code block can now be provided instead of a lambda.')
    end

    if block_given? && predicate
      raise ArgumentError.new('Both a predicate lambda and a code block were specified.' \
          '  Please specify one or the other but not both.')
    end

    success = false
    end_time = Time.now + timeout_secs
    time_to_go = nil
    text_generator = ->() { '%9.3f   %9.3f' % [time_elapsed, time_to_go] }
    status_updater = ::TrickBag::Io::TextModeStatusUpdater.new(text_generator, output_stream)

    loop do

      break if Time.now >= end_time

      success = !! (block_given? ? yield : predicate.())
      break if success

      status_updater.print
      sleep(sleep_interval)
    end
    output_stream.print "\n"
    success
  end


  # Executes the passed block with the Ruby Benchmark standard library.
  # Prints the benchmark string to the specified output stream.
  # Returns the passed block's return value.
  #
  # e.g.   benchmark('time to loop 1,000,000 times') { 1_000_000.times { 42 }; 'hi' }
  # outputs the following string:
  #   0.050000   0.000000   0.050000 (  0.042376): time to loop 1,000,000 times
  #  and returns: 'hi'
  #
  # @param caption the text fragment to print after the timing data
  # @param out_stream object responding to << that will get the output string
  #   defaults to $stdout
  # @block the block to execute and benchmark
  def benchmark(caption, out_stream = $stdout, &block)
    return_value = nil
    bm = Benchmark.measure { return_value = block.call }
    out_stream << bm.to_s.chomp << ": #{caption}\n"
    return_value
  end


  # Runs the passed block in a new thread, ensuring that its execution time
  # does not exceed the specified duration.
  #
  # @param max_seconds maximum number of seconds to wait for completion
  # @param check_interval_in_secs interval in seconds at which to check for completion
  # @block block of code to execute in the secondary thread
  #
  # @return [true, block return value] if the block completes before timeout
  #      or [false, nil] if the block is still active (i.e. the thread is still alive)
  #      when max_seconds is reached
  def try_with_timeout(max_seconds, check_interval_in_secs, &block)
    raise "Must pass block to this method" unless block_given?
    end_time = Time.now + max_seconds
    block_return_value = nil
    thread = Thread.new { block_return_value = block.call }
    while Time.now < end_time
      unless thread.alive?
        return [true, block_return_value]
      end
      sleep(check_interval_in_secs)
    end
    # thread.kill
    [false, nil]
  end

end
end
