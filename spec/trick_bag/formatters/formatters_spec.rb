require_relative '../../spec_helper'

require 'trick_bag/formatters/formatters'

module TrickBag

describe Formatters do

  context ".duration_to_s" do

    specify "it will not permit a non-number" do
      expect(->() { Formatters.duration_to_s([])}).to raise_error
    end

    expect_output_for_input = ->(expected_output, input) do
      description = "it returns '#{expected_output}' for an input of #{input}"
      specify description do
        expect(Formatters.duration_to_s(input)).to eq(expected_output)
      end
    end

    # Positive numbers
    expect_output_for_input.('1 s',                    1)
    expect_output_for_input.('1 m, 0 s',              60)
    expect_output_for_input.('3 m, 37 s',              3 * 60 + 37)
    expect_output_for_input.('1 h, 0 m, 0 s',         60 * 60)
    expect_output_for_input.('1 d, 0 h, 0 m, 0 s',    24 * 60 * 60)

    # Negative numbers
    expect_output_for_input.('-1 s',                    -1)
    expect_output_for_input.('-1 m, 0 s',              -60)
    expect_output_for_input.('-3 m, 37 s',             -(3 * 60 + 37))
    expect_output_for_input.('-1 h, 0 m, 0 s',         -60 * 60)
    expect_output_for_input.('-1 d, 0 h, 0 m, 0 s',    -24 * 60 * 60)

    # Zero
    expect_output_for_input.('0 s',                    0)

  end


  context ".end_with_nl" do

    specify "it returns an empty string for an empty string" do
      expect(Formatters.end_with_nl('')).to eq('')
    end

    specify "it leaves a single new line unchanged" do
      expect(Formatters.end_with_nl("\n")).to eq("\n")
    end

    specify "it returns an empty string for nil because nil.to_s == ''" do
      expect(Formatters.end_with_nl(nil)).to eq('')
    end

    specify "it converts a number and then adds a new line" do
      expect(Formatters.end_with_nl(3)).to eq("3\n")
    end
  end
end
end
