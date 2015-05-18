module TrickBag
module Timing


# Very simple class that enables you to specify an elapsed time in
# either seconds or by the time itself.
class Elapser

  attr_reader :seconds, :end_time
  attr_accessor :never_elapse

  def self.never_elapser
    @never_elapser ||= begin
       instance = new(0)
       instance.never_elapse = true
       instance
    end
  end


  # Can be used to create an instance or return the passed instance (see test for example).
  def self.from(object)
    case object
      when :never
        never_elapser
      when self
        object
      else
        new(object)
    end
  end


  # Create the instance with the passed parameter.  If it's a Time instance,
  # it is assumed to be the end time at which elapsed? should return true.
  # If it's a number, it's assumed to be a number of seconds after which
  # elapsed? should return true.
  def initialize(seconds_or_end_time)
    case seconds_or_end_time
      when Time
        @end_time = seconds_or_end_time
        @seconds = @end_time - Time.now
      when ::Numeric
        @seconds = seconds_or_end_time
        @end_time = Time.now + @seconds
      else
        raise ArgumentError.new("Invalid parameter class: #{seconds_or_end_time.class}, object: #{seconds_or_end_time}")
    end
  end

  def elapsed?
    never_elapse ? false : Time.now >= @end_time
  end


  def hash
    Integer(@seconds - @end_time)
  end


  def ==(other)
    other.class == self.class && other.seconds == self.seconds && other.end_time == self.end_time
  end
end

end
end
