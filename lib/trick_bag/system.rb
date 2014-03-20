require 'os'

module TrickBag

# Convenience methods for dealing with Posix-compliant systems.
module System

  module_function

  # Calls lsof to return information about all files *open by this process*.
  # Output returned is lsof's output, but after calling split("\n") to create
  # an array of the result strings.
  #@param options additional options to the lsof command line, if any, defaults to ''
  def lsof(options = '')
    raise "Cannot be called on a non-Posix operating system." unless OS.posix?
    raise "lsof command not found" unless command_available?('lsof')
    `lsof #{options} -p #{Process.pid}`.split("\n")
  end


  def command_available?(command)
    raise "Cannot be called on a non-Posix operating system." unless OS.posix?
    system("which #{command} > /dev/null")
   end

end
end
