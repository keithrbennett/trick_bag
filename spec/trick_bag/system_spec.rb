require_relative '../spec_helper'

require 'trick_bag/system'

module TrickBag
module System

  posix_only_test = -> do
    describe 'System' do

      context "#command_available" do
        specify 'which ls returns true' do
          expect(System.command_available?('ls')).to be_true
        end

        specify 'which fsdfiuowqpfeqpxumwfuqiufqpiufpqwmiurqpruiiqwmxrqupruxmqowiruqmpmu returns false' do
          expect(System.command_available?('fsdfiuowqpfeqpxumwfuqiufqpiufpqwmiurqpruiiqwmxrqupruxmqowiruqmpmu')).to be_false
        end
      end


      context ".lsof" do
        specify "returns ruby lines" do
          lines = System.lsof
          has_ruby_line = lines.any? { |line| /ruby/ === line }
          expect(has_ruby_line).to be_true
        end
      end
    end
  end

  posix_only_test.() if OS.posix?

end
end
