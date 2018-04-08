module TrickBag
module Filesystem

  module_function

  # @return true if the passed file is being run as a script, else false
  # @param __file__ - !!! __FILE__ must be passed as the __file__ argument for this to work correctly !!!
  #
  # When the file's behavior needs to differ when running as a script and _not_ running as a script,
  # this method can be called to report which of the two states it is.
  #
  # Sometimes we want to see if a given file is being run as a script, as opposed to loaded
  # by other Ruby code. For example, the script at https://github.com/keithrbennett/macwifi/blob/master/bin/mac-wifi
  # is normally run as a script (either by running the file directly, or by running the executable's
  # binstub installed by the gem), but it can also be loaded so that the model can be used by custom code.
  # When run as a script, it parses the command line and executes a task, sending text to stdout.
  def running_as_script?(__file__)

    # Here is some sample state, when running a file as a gem executable:
    # __FILE__ = /Users/kbennett/.rvm/gems/ruby-2.4.0/gems/mac-wifi-1.0.0/bin/mac-wifi
    # $0 =       /Users/kbennett/.rvm/gems/ruby-2.4.0/bin/mac-wifi
    # GEM_PATH = /Users/kbennett/.rvm/gems/ruby-2.4.0:/Users/kbennett/.rvm/gems/ruby-2.4.0@global

    # Please enable this code and report its output if you report any issues with this method:
    # puts "__file__ = #{__file__}"
    # puts "$0 =       #{$0}"
    # puts "GEM_PATH = #{ENV['GEM_PATH']}"

    return true if __file__ == $0
    return false if File.basename(__file__) != File.basename($0)

    # If here, then filespecs are different but have the same basename.
    gem_paths = ENV['GEM_PATH'].split(File::PATH_SEPARATOR)
    basename = File.basename($0)
    gem_paths.any? do |path|
      ($0 == File.join(path, 'bin', basename)) \
          && \
          (path == File.expand_path(File.join(__file__, '..', '..', '..', '..')))
    end
  end
end
end
