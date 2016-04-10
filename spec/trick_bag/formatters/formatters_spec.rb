require_relative '../../spec_helper'

require 'date'
require 'trick_bag/formatters/formatters'

module TrickBag

describe Formatters do

  context ".duration_to_s" do

    specify "it will not permit a non-number" do
      expect(->() { Formatters.duration_to_s([])}).to raise_error(ArgumentError)
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

    specify 'it returns false\n for false' do
      expect(Formatters.end_with_nl(false)).to eq("false\n")
    end

    specify "it converts a number and then adds a new line" do
      expect(Formatters.end_with_nl(3)).to eq("3\n")
    end
  end


  context ".replace_with_timestamp" do

    let(:a_date) { DateTime.new(2000, 1, 2, 15, 44, 37) }

    specify "returns the correct string" do
      s = Formatters.replace_with_timestamp('*', '*', a_date)
      expect(s).to eq('2000-01-02_15-44-37')
      #regex = /^\d\d\d\d-\d\d-\d\d-\d\d-\d\d-\d\d$/
      #puts s
      #expect(regex === s).to eq(true)
      #
      #
    end
  end


  context ".dos2unix" do

    specify "strings not containing line endings remain unchanged" do
      strings = ['', 'abc', ' ']
      expect(strings.map { |s| Formatters.dos2unix(s) }).to eq(strings)
    end

    specify "CR characters are stripped" do
      expect(Formatters.dos2unix("foo\r\nbar\r\n")).to eq("foo\nbar\n")
    end

    specify "a bad strategy will result in a raised error" do
      expect(->() { Formatters.dos2unix('', :not_a_strategy) }).to raise_error(ArgumentError)
    end
  end

  context ".dos2unix!" do

    context ':remove_all_cr' do
      specify "strings not containing line endings remain unchanged" do
        expect(Formatters.dos2unix('', :remove_all_cr)).to    eq('')
        expect(Formatters.dos2unix(' ', :remove_all_cr)).to   eq(' ')
        expect(Formatters.dos2unix('abc', :remove_all_cr)).to eq('abc')
      end

      specify "CR characters are stripped" do
        s = "foo\r\nbar\r\n"
        Formatters.dos2unix!(s, :remove_all_cr)
        expect(s).to eq("foo\nbar\n")
      end
    end

    context 'remove_cr_in_crlf' do

      specify "strings not containing line endings remain unchanged" do
        expect(Formatters.dos2unix('', :remove_cr_in_crlf)).to    eq('')
        expect(Formatters.dos2unix(' ', :remove_cr_in_crlf)).to   eq(' ')
        expect(Formatters.dos2unix('abc', :remove_cr_in_crlf)).to eq('abc')
      end

      specify "cr is replaced only in crlf" do
        s = "\rfoo\r\nbar\r\n\r"
        expect(Formatters.dos2unix(s, :remove_cr_in_crlf)).to eq("\rfoo\nbar\n\r")

      end
    end


    context 'array_diff' do
      specify 'text is correct' do
        a1 = [1, 2, 3]
        a2 = [   2, 3, 4]
        actual_text = Formatters.array_diff(a1, a2)
        expected_text = "-1\n 2\n 3\n+4\n"
        expect(actual_text).to eq(expected_text)
      end
    end


    context 'string_to_verbose_char_list' do

      let(:result) { Formatters.string_to_verbose_char_list("a1.").split("\n") }

      specify 'first line should have header text' do
        required_words = %w(Index  Decimal  Hex  Binary  Character)
        expect(required_words.all? { |word| result[0].include?(word) }).to eq(true)
      end

      specify 'second line should have only lines' do
        non_blank_or_hyphens = result[1].chars.reject { |char| [' ', '-'].include?(char) }
        expect(non_blank_or_hyphens).to be_empty
      end

      specify 'third line should include some required text' do
        #   0          97         61 x          110 0001 b       a
        expect(result[2]).to match(/^\s*\d*\s* 97 \s* 61 x \s* 110 0001 b\s*a\s*$/)
      end

      specify 'empty string returns header with 3rd line saying (string is empty)' do
        output = Formatters.string_to_verbose_char_list('')
        expect(output).to include('(String is empty)')
      end
    end


    context '.thousands_separated' do

      specify 'no separators for <= 3 digit numbers' do
        expect(Formatters.thousands_separated(123)).to eq('123')
        expect(Formatters.thousands_separated(12)).to eq('12')
        expect(Formatters.thousands_separated(1)).to eq('1')
      end

      specify 'separators are in the right places' do
        expect(Formatters.thousands_separated(1_234)).to eq('1,234')
        expect(Formatters.thousands_separated(12_345)).to eq('12,345')
        expect(Formatters.thousands_separated(123_456)).to eq('123,456')
        expect(Formatters.thousands_separated(1_234_567)).to eq('1,234,567')
      end

      specify 'custom separators work properly' do
        expect(Formatters.thousands_separated(1_234_567, '.')).to eq('1.234.567')
      end
    end
  end

end
end
