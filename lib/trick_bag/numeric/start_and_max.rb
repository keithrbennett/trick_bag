module TrickBag
module Numeric

  # Like a Range, but includes useful functions with understandable names
  # that account for the absence of limits.
  class StartAndMax

  attr_reader :start_pos, :max_count

  # @param start_pos - the record number, zero offset, at which to begin each() processing; or :first
  # @param max_count - the maximum number of records to be served by each(); or :infinite
  def initialize(start_pos = :first, max_count = :infinite)
    @start_pos = ([nil, :first].include?(start_pos) || start_pos <= 0) ? :first : start_pos
    @max_count = ([nil, :infinite].include?(max_count)     || max_count <= 0) ? :infinite : max_count
  end


  def start_position_reached?(num)
    @start_pos == :first || num >= @start_pos
  end


  def max_count_reached?(count)
    @max_count != :infinite && (count >= @max_count)
  end


  def to_s
    "#{self.class}: start position=#{start_pos}, max count=#{max_count}"
  end

end
end
end

