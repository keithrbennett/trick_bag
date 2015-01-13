require_relative '../../spec_helper'

require 'trick_bag/numeric/bitmap'

module TrickBag
module Numeric


  raw_string = ->(s) { s.force_encoding(Encoding::ASCII_8BIT) }

  describe Bitmap do


    specify 'the constructor should not permit being explicitly called outside the class' do
      expect(-> { Bitmap.new }).to raise_error
    end


    context '.binary_string_to_number' do

      it 'computes byte values correctly' do
        expect(Bitmap.binary_string_to_number("\xFF")).to eq(255)
        expect(Bitmap.binary_string_to_number("\x0D")).to eq(13)
      end

      it 'considers the left-most byte most significant' do
        expect(Bitmap.binary_string_to_number("\x01\x00")).to eq(256)
      end

      # Unspecified encoding results in UTF-8 anyway, but this makes it explicit:
      it 'correctly handles non-ASCII_8BIT strings' do
        expect(Bitmap.binary_string_to_number("\x01\x00".force_encoding(Encoding::UTF_8))).to eq(256)
      end
    end
  end


  context '.number_to_value_array' do

    specify 'a single bit set whose value == 9 results in [8, 0, 0, 1]' do
      expect(Bitmap.number_to_value_array(9)).to eq([8, 0, 0, 1])
    end

    specify 'a single bit set whose value == 256 results in [256] + [0] * 8' do
      expect(Bitmap.number_to_value_array(256)).to eq([256] + [0] * 8)
    end

    specify 'a negative number should result in an error' do
      expect { Bitmap.number_to_value_array(-1) }.to raise_error(ArgumentError)
    end
  end

  context '.number_to_bit_array' do

    specify 'a single bit set whose value == 9 results in [1, 0, 0, 1]' do
      expect(Bitmap.number_to_bit_array(9)).to eq([1, 0, 0, 1])
    end

    specify 'a single bit set whose value == 256 results in [1] + [0] * 8' do
      expect(Bitmap.number_to_bit_array(256)).to eq([1] + [0] * 8)
    end

    specify 'a negative number should result in an error' do
      expect { Bitmap.number_to_bit_array(-1) }.to raise_error(ArgumentError)
    end
  end


  context '.binary_string_to_bit_value_array' do
    it 'computes byte values correctly' do
      expect(Bitmap.binary_string_to_bit_value_array("\xFF")).to eq([1] * 8)
      expect(Bitmap.binary_string_to_bit_value_array("\x0D")).to eq([1,1,0,1])
    end

    it 'considers the left-most byte most significant' do
      expect(Bitmap.binary_string_to_bit_value_array("\x01\x00")).to eq([1] + [0] * 8)
    end

    # Unspecified encoding results in UTF-8 anyway, but this makes it explicit:
    it 'correctly handles non-ASCII_8BIT strings' do
      expect(Bitmap.binary_string_to_bit_value_array("\x01\x00".force_encoding(Encoding::UTF_8))).to eq([1] + [0] * 8)
    end
  end


  context '.number_to_binary_string' do

    specify '256 converted to a binary string is "\x01\00"' do
      expect(Bitmap.number_to_binary_string(256)).to eq("\x01\x00")
    end

    specify 'a negative number should result in an error' do
      expect { Bitmap.number_to_binary_string(-1) }.to raise_error(ArgumentError)
    end

  end

  describe '.number_to_set_bit_positions_array' do

    specify "9's set bit positions should be [0, 3]" do
      expect(Bitmap.number_to_set_bit_positions_array(9)).to eq([0, 3])
    end

    specify 'a negative number should result in an error' do
      expect { Bitmap.number_to_set_bit_positions_array(-1) }.to raise_error(ArgumentError)
    end
  end

  end
end

