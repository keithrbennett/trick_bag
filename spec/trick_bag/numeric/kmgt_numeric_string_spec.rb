require_relative '../../spec_helper'

require 'trick_bag/numeric/kmgt_numeric_string'

module TrickBag
module Numeric
module KmgtNumericString

end
  describe KmgtNumericString do

    include KmgtNumericString

    context '.to_number' do

      specify 'ArgumentError should be raised on invalid inputs' do
        expect { to_number('') }.to raise_error(ArgumentError)
        expect { to_number('_') }.to raise_error(ArgumentError)
        expect { to_number('-') }.to raise_error(ArgumentError)
        expect { to_number('a') }.to raise_error(ArgumentError)
        expect { to_number('A') }.to raise_error(ArgumentError)
        expect { to_number('1a') }.to raise_error(ArgumentError)
        expect { to_number('1A') }.to raise_error(ArgumentError)
        expect { to_number('1.2') }.to raise_error(ArgumentError)
      end

      specify 'suffixes work correctly' do
        expect(to_number('10k')).to eq(10 * 1000)
        expect(to_number('10K')).to eq(10 * 1024)
        expect(to_number('10m')).to eq(10 * (1000 ** 2))
        expect(to_number('10M')).to eq(10 * (1024 ** 2))
        expect(to_number('10g')).to eq(10 * (1000 ** 3))
        expect(to_number('10G')).to eq(10 * (1024 ** 3))
        expect(to_number('10t')).to eq(10 * (1000 ** 4))
        expect(to_number('10T')).to eq(10 * (1024 ** 4))
      end

      specify 'negative numbers work too' do
        expect(to_number('-10k')).to eq(-10 * 1000)
        expect(to_number('-10')).to eq(-10)
      end
    end


    context '.is_range_string' do

      specify 'invalid range strings should return false' do
        expect(range_string?('')).to eq(false)
        expect(range_string?('10')).to eq(false)
        expect(range_string?('10K')).to eq(false)
        expect(range_string?('..')).to eq(false)
        expect(range_string?('2..')).to eq(false)
        expect(range_string?('..3')).to eq(false)
      end

      specify 'valid range strings should return true' do
        expect(range_string?('1..-1')).to eq(true)
        expect(range_string?('-1..1')).to eq(true)
        expect(range_string?('10K..10M')).to eq(true)
      end
    end


    context '.to_range' do

      specify 'descending ranges are supported' do
        expect(to_range('9..3')).to eq((9..3))
      end

      specify 'ascending ranges are supported' do
        expect(to_range('3k..4k')).to eq((3000..4000))
      end
    end

    context '.to_number_or_range' do

      specify 'correct determination of number vs. range' do
        expect(to_number_or_range('12k')).to eq(12_000)
        expect(to_number_or_range('12k..24k')).to eq(12_000..24_000)
      end
    end
    end
end
end