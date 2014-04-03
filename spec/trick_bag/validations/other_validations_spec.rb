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
  end
end
