require_relative '../../spec_helper'
require 'trick_bag/operators/operators'

module TrickBag

  describe Operators do
    context "multi_eq" do

      specify "that calling with no params raises an error" do
        expect(->{ Operators.multi_eq() }).to raise_error
      end

      specify "that calling with no params raises an error" do
        expect(->{ Operators.multi_eq(1) }).to raise_error
      end

      test_for = ->(true_or_false, *values) do
        specify "that #{values.map(&:to_s).join(', ')} returns #{true_or_false}}" do
        expect(Operators.multi_eq(*values)).to eq(true_or_false)
        end
      end

      test_for.(true, 12, 12)
      test_for.(false, 0, 12)
      test_for.(true, :foo, :foo, :foo)
      test_for.(false, :bar, :foo, :foo)
      test_for.(false, :foo, :bar, :foo)
      test_for.(false, :foo, :foo, :bar)
      test_for.(true, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7)
      test_for.(false, 7, 7, 7, 7, 7, 9999, 7, 7, 7, 7, 7)
    end
  end
end
