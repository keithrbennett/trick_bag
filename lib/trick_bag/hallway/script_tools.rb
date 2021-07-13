# !!! These methods will work only on Posix OS's.
module TrickBag; module System

  module_function

  def open_file_count
    open_files_ps_lines.size
  end

  def open_files_ps_lines
    `lsof -p #{Process.pid}`.split("\n")[1..-1]
  end

  def report_open_files_thread(sleep_interval_secs = 30, count_only = true)
    Thread.start do
      start = Time.now
      loop do
        time = (Time.now - start).round(0).to_s.rjust(6)
        if count_only
          $stderr.puts "[#{time}] Open file count for process #{Process.pid} is #{open_file_count}"
        else
          $stderr.puts "[#{time}] Open files for process #{Process.pid} are:\n#{open_files_ps_lines}"
        end
        sleep sleep_interval_secs
      end
    end
  end

  def memory_used
    ((`ps -o rss #{Process.pid}`.lines.last.to_i) / 1024.0).round(0)
  end

  def instance_count(klass = BasicObject)
    ObjectSpace.each_object(klass) \
        .map(&:class) \
        .map(&:name) \
        .tally \
        .sort_by { |_class_name, count| -count } \
        .to_h
  end

  private def report_object_count_thread(sleep_interval_secs, klass = BasicObject)
    require 'pp'
    Thread.start do
      loop do
        puts "Memory used in MB: #{memory_used}"
        puts "Instance counts for class #{klass}:"
        pp instance_count(klass)
        puts
        sleep sleep_interval_secs
      end
    end
  end
end; end
