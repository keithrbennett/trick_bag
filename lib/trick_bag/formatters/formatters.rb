require 'date'

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


  def timestamp(datetime = DateTime.now)
    datetime.strftime('%Y-%m-%d_%H-%M-%S')
  end


  # Replaces all occurrences of marker with the current date/time in
  # YYYYMMDD-HHMMSS format.
  def replace_with_timestamp(string, marker = '{dt}', datetime = DateTime.now)
    string.gsub(marker, timestamp(datetime))
  end


  # Like the Unix dos2unix command, but on strings rather than files, strips CR characters.
  #
  # WARNING:
  #
  # Currently the code's implementation is very simple; it unconditionally
  # removes all occurrences of "\r".  However, what if we want to ensure that
  # only "\r" followed by "\n" should be removed?  Or if we want to account for
  # character sets that might include characters that have "\r"'s numeric value,
  # 13, or 0xd, as part of their legitimate values?
  # This method may need to be modified.  An example of a more complex
  # implementation is at:
  # http://dos2unix.sourcearchive.com/documentation/5.0-1/dos2unix_8c-source.html.
  #
  # Note: The 'os' gem can be used to determine os.
  def dos2unix(string)
    string ? string.gsub("\r", '') : string
  end


  # Like the Unix dos2unix command, but on strings rather than files, strips CR characters.
  # Modifies the original string.
  # See warning in dos2unix header.
  # Note: The 'os' gem can be used to determine os.
  def dos2unix!(string)
    string ? string.gsub!("\r", '') : string
  end

end
end

