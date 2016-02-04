module TrickBag

# Takes a string as input and formats it to a string containing offset,
# hex values, and ASCII values, with unprintable chars printed as '.'.
# Call as TrickBag::BinaryToHexAndAscii.format(byte_array_or_string)
#
# Sample Output:

# require 'trick_bag'
# array = Array.new(32) { |i| i * 7 }
# puts TrickBag::BinaryToHexAndAscii.format(array)

# 0x   0  00 07 0E 15 | 1C 23 2A 31 | 38 3F 46 4D | 54 5B 62 69  .....#*18?FMT[bi
# 0x  10  70 77 7E 85 | 8C 93 9A A1 | A8 AF B6 BD | C4 CB D2 D9  pw~.............

module BinaryToHexAndAscii

  module_function

  def format(byte_array_or_string)
    byte_array = if byte_array_or_string.is_a?(String)
      byte_array_or_string.bytes
    else
      byte_array_or_string
    end

    result = ''
    offset = 0
    byte_array.each_slice(16) do |bytes|
      result << format_line(offset, bytes) << "\n"
      offset += 16
    end
    result
  end


  def bytes_as_hex(bytes)
    bytes.map { |b| "%02X" % b }.join(' ')
  end


  def offset_string(offset)
    "0x%4X" % [offset] # Offset, e.g. "0x   0" or "0x  10"
  end


  def join_hex_sections(sections)
    sections.join(' | ')
  end


  def ascii_char(byte)
    (32..126).include?(byte) ? byte.chr : '.'
  end


  def ascii_string(bytes)
    bytes.map { |b| ascii_char(b) }.join
  end


  def format_line(offset, bytes)
    sections = bytes.each_slice(4).to_a.map { |slice| bytes_as_hex(slice) }

    offset_string(offset) \
        << '  ' \
        << join_hex_sections(sections).ljust(53) \
        << '  ' \
        << ascii_string(bytes)
  end
end

end
