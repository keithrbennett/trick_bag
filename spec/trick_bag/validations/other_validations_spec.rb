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
        expect(/manufacturer/ === error.message).to be_true
        expect(/:bar/ === error.message).to be_true
        expect(error.message).to eq("Invalid manufacturer 'foo'; must be one of: [:bar, :baz].")
      end
    end

    specify 'this gem contains all necessary gem dependency specifications' do
      require 'open3'
      result = test_gem_dependency_specs('trick_bag')
      exit_status = result[:exit_status]
      if exit_status  != 0
        fail "Exit status was #{exit_status}, output was:\n#{output}."
      end
    end
  end
end
