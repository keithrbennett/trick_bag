module TrickBag
module Numeric

  # Provides an object that will tell you if the number exceeds the starting point
  # and if the number is >= the maximum (or if no maximum has been specified).
  # While this functionality can easily be duplicated with more primitive
  # code, this class provides an object whose use will be simpler and more readable.
  class StartAndMax

  attr_reader :start_pos, :max_count

  # @param start_pos - the record number, zero offset, at which to begin each() processing; or :first
  # @param max_count - the maximum number of records to be served by each(); or :infinite
  def initialize(start_pos = :first, max_count = :infinite)
    @start_pos = ([nil, :first].include?(start_pos) || start_pos <= 0) ? :first : start_pos
    @max_count = ([nil, :infinite].include?(max_count) || max_count <= 0) ? :infinite : max_count
  end


  # If a starting position has been specified, returns whether or not the specified number
  # >= that position.  Else, returns true unconditionally.
  def start_position_reached?(num)
    @start_pos == :first || num >= @start_pos
  end


  # If a maximum count has been specified, returns whether or not the specified number
  # >= that count.  Else, returns false unconditionally.
  def max_count_reached?(count)
    @max_count != :infinite && (count >= @max_count)
  end


  # Returns string representation including starting position and maximum count.
  def to_s
    "#{self.class}: start position=#{start_pos.inspect}, max count=#{max_count.inspect}"
  end

end
end
end

