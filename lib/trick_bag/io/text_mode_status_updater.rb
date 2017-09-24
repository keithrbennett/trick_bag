module TrickBag
module Io

# Provides an updatable and customizable status/information line in a terminal,
# typically used to display progress.
# Updates the terminal line with text, erasing the original content and displaying at the same place.
# Uses ANSI escape sequences for cursor positioning and clearing
# (see http://www.oldlinux.org/Linux.old/Ref-docs/ASCII/ANSI%20Escape%20Sequences.htm).
#
# Example:
#
# updater = TrickBag::Io::TextModeStatusUpdater.new(->{ Time.now })
# 5.times { updater.print; sleep(1) }
class TextModeStatusUpdater


  def initialize(text_generator, outstream = $stdout, force_output_non_tty = false)
    @text_generator = text_generator
    @outstream = outstream
    @force_output_non_tty = force_output_non_tty
    @first_time = true
  end


  # Causes the text generator lambda to be called, calls to_s on its result,
  # and outputs the resulting text to the output stream, moving the cursor
  # left to the beginning of the previous call's output if not the first call to print.
  #
  # Since this method uses ASCII escape sequences that would look messy in a file,
  # this method will silently return if the output stream is not a TTY, unless
  # @force_output_non_tty has been set to true.
  #
  # @param args Optional arguments to be passed to the text generator
  def print(*args)

    # If output is being redirected, don't print anything; it will look like garbage;
    # But if output was forced (e.g. to write to a string), then allow it.
    return unless @outstream.tty? || @force_output_non_tty

    if @first_time
      @first_time = false
    else
      @outstream.print(move_cursor_left_text(@prev_text_length))
    end
    text = @text_generator.(*args).to_s
    @prev_text_length = text.length
    @outstream.print(clear_to_end_of_line_text + text)
  end

  # The following methods are for cursor placement and text clearing:
  private

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

end
end
end
