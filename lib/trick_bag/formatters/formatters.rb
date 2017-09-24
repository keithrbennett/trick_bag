require 'date'
require 'diffy'

module TrickBag
module Formatters

  module_function

  # Formats a number of seconds as a succinct string, with days, hours,
  # minutes, and seconds.  Examples:
  #
  # duration_to_s(1_000_000)  => "11 d, 13 h, 46 m, 40 s"
  # duration_to_s(1_000)      => "16 m, 40 s"
  # duration_to_s(-1_000)     => "-16 m, 40 s"
  # duration_to_s(1.234567)   => "1.234567 s"
  # duration_to_s(1000.234567) => "16 m, 40.23456699999997 s"
  def duration_to_s(seconds)

    unless seconds.is_a?(::Numeric)
      raise ArgumentError.new("#{seconds} must be a number but is a #{seconds.class}.")
    end

    seconds_in_minute = 60
    seconds_in_hour = 60 * seconds_in_minute
    seconds_in_day = 24 *seconds_in_hour

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


  # Reverse of String#chomp.
  # Convert to string if not already a string.
  # Append new line to string if the string is not empty and does not already end with one.
  # This is to disable the Diffy warning message "No newline at end of file"
  def end_with_nl(object)
    string = object.to_s
    needs_modifying = string.size > 0 && string[-1] != "\n"
    needs_modifying ? "#{string}\n" : string
  end


  # Returns a timestamp string suitable for use in filespecs,
  # whose string sort order will be the same as a chronological sort would be.
  # @param datetime the date to format, defaults to DateTime.now
  def timestamp(datetime = DateTime.now)
    datetime.strftime('%Y-%m-%d_%H-%M-%S')
  end


  # Replaces all occurrences of marker with the current date/time in
  # YYYYMMDD-HHMMSS format.
  #
  # Useful for creating filespecs with static content that will differ by date,
  # for example:
  #
  # replace_with_timestamp('my-app-result-{dt}.txt') => "my-app-result-2014-03-24_15-25-57.txt"
  def replace_with_timestamp(string, marker = '{dt}', datetime = DateTime.now)
    string.gsub(marker, timestamp(datetime))
  end


  # Like the Unix dos2unix command, but on strings rather than files,
  # strips CR ("\r", 13, 0xD) characters.
  #
  # WARNING:
  #
  # Currently, two strategies are supported, but they do not account for
  # character sets that might include characters that have "\r"'s numeric value,
  # 13, or 0xd, as part of their legitimate values, so we may need to
  # add strategies to accommodate this.
  #
  # An example of a more complex implementation is at:
  # http://dos2unix.sourcearchive.com/documentation/5.0-1/dos2unix_8c-source.html.
  #
  # Note: The 'os' gem can be used to determine os.
  #
  # @param string the string to convert
  # @param strategy the strategy to use for the conversion (note: the default
  #        may change over time, so if you're sure you want to use the current
  #        default even if the default changes, don't rely on the default; specify it)
  def dos2unix(string, strategy = :remove_all_cr)
    strategies = {
        remove_all_cr:     -> { string.gsub("\r", '') },
        remove_cr_in_crlf: -> { string.gsub("\r\n", "\n") }
    }

    unless strategies.keys.include?(strategy)
      message = "Unsupported strategy: #{strategy}. Must be one of [#{strategies.keys.sort.join(', ')}]."
      raise ArgumentError.new(message)
    end

    strategies[strategy].()
  end


  # Like the Unix dos2unix command, but on strings rather than files, strips CR characters.
  # Modifies the original string.
  # See warning in dos2unix header.
  # Note: The 'os' gem can be used to determine os.
  def dos2unix!(string, strategy = :remove_all_cr)
    string.replace(dos2unix(string, strategy))
  end


  # Shows a visual diff of 2 arrays by comparing the string representations
  # of the arrays with one element per line.
  # @param format can be any valid Diffy option, e.g. :color
  #     see https://github.com/samg/diffy/blob/master/lib/diffy/format.rb
  def array_diff(array1, array2, format = :text)
    string1 = array1.join("\n") + "\n"
    string2 = array2.join("\n") + "\n"
    Diffy::Diff.new(string1, string2).to_s(format)
  end


  # Outputs bytes verbosely one on a line for examination.
  # The characters printed are 1 byte in length, so multibyte
  # characters will not be output correctly.  Output will look like:
  #
  # Index     Decimal        Hex              Binary    Character
  # -----     -------        ---              ------    ---------
  #     0          97         61 x          110 0001 b       a
  #     1          49         31 x           11 0001 b       1
  #     2          46         2e x           10 1110 b       .
  #
  def string_to_verbose_char_list(a_string)

    header = [
        'Index     Decimal        Hex              Binary    Character',
        '-----     -------        ---              ------    ---------',
        ''  # 3rd string is just to force a 3rd \n when joined
    ].join("\n")

    sio = StringIO.new
    sio << header

    if a_string.empty?
      sio << '(String is empty)'
    else
      format = '%5d         %3d       %+6s    %+16s       %c'
      a_string.bytes.each_with_index do |byte, index|
        hex_str = "#{byte.to_s(16)} x"

        base2_str = "#{byte.to_s(2)} b"
        if base2_str.size > 6
          base2_str.insert(base2_str.size - 6, ' ')
        end

        sio << format % [index, byte, hex_str, base2_str,  byte.chr] << "\n"
      end
    end
    sio.string
  end


  # Returns a string representation of the Integer corresponding to the
  # input parameter, with a customizable thousands separator.
  # Does not (yet) support fractional values or decimal places.
  def thousands_separated(number, separator = ',')
    number = Integer(number)
    triplets = []
    source_chars = number.to_s.reverse.chars
    source_chars.each_slice(3) do |slice|
      triplets << slice.join
    end
    triplets.join(separator).reverse
  end
end
end

