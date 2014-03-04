module TrickBag
module Io

# Updates the terminal line with text, erasing the original content and displaying at the same place.
# Uses ANSI escape sequences for cursor positioning and clearing
# (see http://www.oldlinux.org/Linux.old/Ref-docs/ASCII/ANSI%20Escape%20Sequences.htm).
class TextModeStatusUpdater


  def initialize(text_generator, outstream = $stdout, force_output_non_tty = false)
    @text_generator = text_generator
    @outstream = outstream
    @force_output_non_tty = force_output_non_tty
    @first_time = true
  end

  def clear_to_end_of_line_text
    "\x1b[2K"
  end

  def save_cursor_position_text
    "\x1b[s"
  end

  def go_to_start_of_line_text
    "\x1b0`"
  end

  def move_cursor_left_text(num_chars)
    "\x1b[#{num_chars}D"
  end

  def restore_cursor_position_text
    "\x1b[u"
  end

  def insert_blank_chars_text(num_chars)
    "\x1b[#{num_chars}@"
  end

  def print

    # If output is being redirected, don't print anything; it will look like garbage;
    # But if output was forced (e.g. to write to a string), then allow it.
    return unless @outstream.tty? || @force_output_non_tty

    if @first_time
      @first_time = false
    else
      @outstream.print(move_cursor_left_text(@prev_text_length))
    end
    text = @text_generator.()
    @prev_text_length = text.length
    @outstream.print(clear_to_end_of_line_text + text)
  end

end
end
end
