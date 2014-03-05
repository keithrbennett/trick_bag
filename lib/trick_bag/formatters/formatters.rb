module TrickBag
module Formatters

  module_function

  def duration_to_s(seconds)

    seconds_in_minute = 60
    seconds_in_hour = 60 * seconds_in_minute
    seconds_in_day = 24 *seconds_in_hour

    seconds = seconds.to_i
    str = ''

    if seconds < 0
      str << '-'
      seconds = -seconds
    end

    fractional_second = seconds - Integer(seconds)
    seconds = Integer(seconds)



    days = seconds / seconds_in_day
    print_days = days > 0
    seconds %= seconds_in_day

    hours = seconds / seconds_in_hour
    print_hours = hours > 0 || days > 0
    seconds %= seconds_in_hour

    minutes = seconds / seconds_in_minute
    print_minutes = minutes > 0 || hours > 0 || days > 0
    seconds %= seconds_in_minute

    str << "#{days} d, "     if print_days
    str << "#{hours} h, "    if print_hours
    str << "#{minutes} m, "  if print_minutes
    str << "#{seconds + fractional_second} s"

    str
  end


  # Convert to string if not already a string.
  # Append new line to string if the string is not empty and does not already end with one.
  # This is to disable the Diffy warning message "No newline at end of file"
  def end_with_nl(object)
    string = object.to_s
    needs_modifying = string && string.size > 0 && string[-1] != "\n"
    needs_modifying ? "#{string}\n" : string
  end
end
end

