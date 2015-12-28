require_relative '../../spec_helper.rb'

require 'trick_bag/validations/other_validations'

module TrickBag

  describe Validations do

    include Validations

    specify "*no* error is raised if the value is included" do
      expect(->{raise_on_invalid_value('foo', ['foo']) }).not_to raise_error
    end

    specify "an error *is* raised if the value is not included" do
      expect(->{raise_on_invalid_value('foo', []) }).to raise_error
    end

    specify "the error message is correct" do
      begin
        raise_on_invalid_value('foo', [:bar, :baz], 'manufacturer')
        fail "Should have raised an error"
      rescue => error
        expect(error.message).to match(/manufacturer/)
        expect(error.message).to match(/:bar/)
        expect(error.message).to eq("Invalid manufacturer 'foo'; must be one of: [:bar, :baz].")
      end
    end

    specify 'this gem contains all necessary gem dependency specifications' do

      if /java/.match(RUBY_PLATFORM)
        STDERR.puts "Running in JRuby; bypassing test of Validations.test_gem_dependency_specs, not supported."
        expect(-> { test_gem_dependency_specs('trick_bag') }).to raise_error
      else
        require 'open3'
        result = test_gem_dependency_specs('trick_bag')
        exit_status = result[:exit_status]
        if exit_status  != 0
          fail "Exit status was #{exit_status}, output was:\n#{result[:output]}."
        end
      end
    end
  end
end
