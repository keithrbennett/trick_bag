#!/usr/bin/env ruby
#
# Runs a system executable continuously n times, capturing the stdout.
# Takes as parameters callables that will be passed the stdout.

class SystemRunner
  attr_reader :max_run_count, :run_count, :stdout_text, :system_command
  attr_reader :success_action, :failure_action

  def initialize(system_command, max_run_count, success_action, failure_action)
    @system_command = system_command
    @max_run_count = max_run_count
    @success_action = success_action || ->(*) { nil }
    @failure_action = failure_action || ->(*) { nil }
    @run_count = 0
    @stdout_text = ''
  end

  def run
    @max_run_count.times do
      @run_count += 1
      puts "\nRunning command, iteration ##{run_count}"
      @stdout_text = `#{system_command}`
      if Process.last_status.exitstatus == 0
        success_action.(stdout_text)
      else
        failure_action.(stdout_text)
      end
    end
  end
end

class SampleRunner
  SYSTEM_COMMAND = %q(X=$(shuf -i 0-1 -n 1); echo $X; test $X -eq '0')

  def on_success
    ->(output_text) do
      puts "Command succeeded: #{SYSTEM_COMMAND}"
      puts "Output: #{output_text}"
    end
  end

  def on_failure
    ->(output_text) do
      puts "Command failed: #{SYSTEM_COMMAND}"
      puts "Output: #{output_text}"
    end
  end

  def call
    SystemRunner.new(SYSTEM_COMMAND, 10, on_success, on_failure).run
  end
end

SampleRunner.new.call
