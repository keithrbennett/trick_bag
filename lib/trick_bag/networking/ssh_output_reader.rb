require 'net/ssh'

# Runs an ssh command, collecting the stdout and stderr produced by it.
# Optionally a predicate can be specified that, when called with the
# accumulated content of stdout and stderr, returns true to close
# the channel or false to continue.
class SshOutputReader

  attr_reader :host, :command, :user, :password, :exit_predicate

  def initialize(host, command, user = ENV['USER'], password = nil)
    @host = host
    @user = user
    @password = password
    @command = command
    @exit_predicate = ->(stdout, stderr) { false }
  end


  # Sets a predicate that, when called with stdout, stderr, returns true
  # to close the channel and return, or returns false to permit the
  # channel to continue operating.
  #
  # For example, to exit when the string "exit" is sent to stdout:
  # reader.set_exit_predicate(->(stdout, stderr) { /exit/ === stdout })
  #
  # Returns self to facilitate chaining, e.g.:
  # stdout, stderr = SshOutputReader.new(...).set_exit_predicate(...).run
  def set_exit_predicate(exit_predicate)
    @exit_predicate = exit_predicate
    self
  end


  # Runs the specified command.
  # If an exit predicate has been specified via set_exit_predicate,
  # then it will be called whenever anything is output to stdout or stderr,
  # and the channel will be called if the predicate returns true.
  #
  # @return [stdout, stderr] = the accumulated content of those streams
  def run
    Net::SSH.start(host, user, password: password) do |ssh|

      stdout = ''
      stderr = ''

      # Open a new channel and configure a minimal set of callbacks, then run
      # the event loop until the channel finishes (closes).
      channel = ssh.open_channel do |ch|
        ch.exec(command) do |ch, success|
          raise "could not execute command" unless success

          # "on_data" is called when the process writes something to stdout
          ch.on_data do |c, data|
            stdout << data
            $stdout.print data
            ch.close if exit_predicate.(stdout, stderr)
          end

          # "on_extended_data" is called when the process writes something to stderr
          ch.on_extended_data do |c, type, data|
            stderr << data
            $stderr.print data
            ch.close if exit_predicate.(stdout, stderr)
          end

          ch.on_close { return [stdout, stderr] }
        end
      end

      channel.wait
      [stdout, stderr]
    end
  end


  def to_s
    "host = #{host}, command = #{command}, user = #{user}" # password intentionally omitted
  end
end



if $0 == __FILE__
  def run_reader(reader)
    puts "Starting reader: #{reader}"
    stdout, stderr = reader.run
    puts; puts "Stdout:\n" + (stdout.empty? ? '[Empty]' : stdout)
    puts; puts "Stderr:\n" + (stderr.empty? ? '[Empty]' : stderr)
    puts "Done\n#{'-' * 79}\n"
  end

  command = 'echo 1; sleep 1; echo 2; sleep 1; echo 3; sleep 1; echo 4'

  run_reader(SshOutputReader.new('localhost', command)\
      .set_exit_predicate(->(stdout, stderr) { /2/ === stdout }))

  run_reader(SshOutputReader.new('localhost', command))
end