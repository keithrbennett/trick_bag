require 'net/ssh'

module TrickBag
module Networking


# Runs an ssh command, collecting the stdout and stderr produced by it.
# Optionally a predicate can be specified that, when called with the
# instance of this class, returns true to close
# the channel or false to continue.
#
# There are instance methods to return the most recent and all accumulated text
# for both stdout and stderr, so the predicate can easily inspect the text.
#
# While the predicate will most likely be a lambda, it can be any
# object that responds to call().
class SshOutputReader

  attr_reader :host, :command, :user, :password, :exit_predicate
  attr_accessor :latest_stdout, :all_stdout, :latest_stderr, :all_stderr, :latest_output_type, :channel

  def initialize(host, command, user = ENV['USER'], password = nil)
    @host = host
    @user = user
    @password = password
    @command = command
    @exit_predicate = ->(instance_of_this_class) { false }
    clear_buffers
  end


  def clear_buffers
    @latest_stdout = ''
    @all_stdout = ''
    @latest_stderr = ''
    @all_stderr = ''
  end


  # Sets a predicate that, when called with this reader instance, returns true
  # to close the channel and return, or false to permit the
  # channel to continue operating.
  #
  # Using this self value, any instance methods can be called; the most useful
  # will probably be latest_stdout, all_stdout, latest_stderr, and all_stderr.
  # There is also a latest_output_type that returns :stdout or :stderr to
  # indicate which type of output just occurred.
  #
  # For example, to exit when the string "exit" is sent to stdout:
  # reader.set_exit_predicate(->(reader) { /exit/ === reader.latest_stdout })
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
  # and the channel will be closed if the predicate returns true.
  #
  # @return self, to support chaining
  def run
    clear_buffers
    Net::SSH.start(host, user, password: password) do |ssh|

      # Open a new channel and configure a minimal set of callbacks, then run
      # the event loop until the channel finishes (closes).
      self.channel = ssh.open_channel do |ch|
        ch.exec(command) do |ch, success|
          raise "could not execute command" unless success

          # "on_data" is called when the process writes something to stdout
          ch.on_data do |c, data|
            self.latest_output_type = :stdout
            self.latest_stdout = data
            self.all_stdout << data
            $stdout.print data
            ch.close if exit_predicate.(self)
          end

          # "on_extended_data" is called when the process writes something to stderr
          ch.on_extended_data do |c, type, data|
            self.latest_output_type = :stderr
            self.latest_stderr = data
            self.all_stderr << data
            $stderr.print data
            ch.close if exit_predicate.(self)
          end

          ch.on_close { self.channel = nil; return self }
        end
      end

      channel.wait
      self.channel = nil
      self
    end
  end


  # The channel will automatically be closed if the predicate returns false
  # or if the command completes.  This method is provided for cases where
  # the predicate wants to raise an error; close should be called before raising the error.
  def close
    channel.close if channel
  end


  def to_s
    "host = #{host}, command = #{command}, user = #{user}" # password intentionally omitted
  end
end


# This is an eample of use of the class that will be run if the file is run explicitly
# i.e.: ruby ssh_output_reader.rb
# This should be moved somewhere else.
if $0 == __FILE__

  Thread.abort_on_exception = true
  # require 'pry'
  has_a_2 = ->(reader) do
    reader.latest_output_type == :stdout \
    && \
    /2/ === reader.latest_stdout
  end

  has_3_lines = ->(reader) { reader.all_stdout.split("\n").size >= 3 }

  def run_reader(r)
    puts "Starting reader: #{r}"
    r.run
    puts; puts "Stdout:\n" + (r.all_stdout.empty? ? '[Empty]' : r.all_stdout)
    puts; puts "Stderr:\n" + (r.all_stderr.empty? ? '[Empty]' : r.all_stderr)
    puts "Done\n#{'-' * 79}\n"
  end

  command = \
'echo 1
sleep 1
echo error output >& 2
echo 2
sleep 1
echo 3
sleep 1
echo 4'

  # TODO: Clean this up!

  # reader = SshOutputReader.new('localhost', command)
  # reader.run
  # puts "All reader stdout:\n" + reader.all_stdout

  run_reader(SshOutputReader.new('localhost', command)\
      .set_exit_predicate(has_a_2))

  # run_reader(SshOutputReader.new('localhost', command)\
  #     .set_exit_predicate(has_3_lines))

  # run_reader(SshOutputReader.new('localhost', command))
end
end
end
