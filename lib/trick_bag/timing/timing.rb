require 'trick_bag/io/text_mode_status_updater'

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
  def retry_until_true_or_timeout(
      predicate, sleep_interval, timeout_secs, output_stream = $stdout)

    success = false
    start_time = Time.now
    end_time = start_time + timeout_secs
    time_elapsed = nil
    time_to_go = nil
    text_generator = ->() { "%9.3f   %9.3f" % [time_elapsed, time_to_go] }
    status_updater = ::TrickBag::Io::TextModeStatusUpdater.new(text_generator, output_stream)

    loop do
      now = Time.now
      time_elapsed = now - start_time
      time_to_go = end_time - now
      time_up = now >= end_time

      break if time_up

      success = !! predicate.()
      break if success

      status_updater.print
      sleep(sleep_interval)
    end
    print "\n"
    success
  end

end
end
