require_relative '../../spec_helper'

require 'trick_bag/numeric/bitmap'

module TrickBag
module Numeric


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


  context '.number_to_binary_string' do

    specify '256 => "\x01\00"' do
      expect(Bitmap.number_to_binary_string(256)).to eq("\x01\x00")
    end

    specify 'a negative number should result in an error' do
      expect { Bitmap.number_to_binary_string(-1) }.to raise_error(ArgumentError)
    end

    specify 'when requested, zero padding will left pad with zeros' do
      expect(Bitmap.number_to_binary_string(256, 8)).to eq("#{"\x00" * 6}\x01\x00")
    end
  end


  context '.number_to_value_array' do

    specify '9 => [8, 0, 0, 1]' do
      expect(Bitmap.number_to_value_array(9)).to eq([8, 0, 0, 1])
    end

    specify '256 => [256] + ([0] * 8)' do
      expect(Bitmap.number_to_value_array(256)).to eq([256] + [0] * 8)
    end

    specify 'a negative number should result in an error' do
      expect { Bitmap.number_to_value_array(-1) }.to raise_error(ArgumentError)
    end
  end

  context '.value_array_to_number' do

    specify '[8, 0, 0, 1] => 9' do
      expect(Bitmap.value_array_to_number([8, 0, 0, 1])).to eq(9)
    end

    specify '[] => nil' do
      expect(Bitmap.value_array_to_number([])).to eq(nil)
    end
  end

  context '.bit_array_to_number' do

    specify '[1, 0, 0, 1] => 9' do
      expect(Bitmap.bit_array_to_number([1, 0, 0, 1])).to eq(9)
    end

    specify '[] => nil' do
      expect(Bitmap.bit_array_to_number([])).to eq(nil)
    end
  end


  context '.number_to_bit_array' do

    specify '9 => [1, 0, 0, 1]' do
      expect(Bitmap.number_to_bit_array(9)).to eq([1, 0, 0, 1])
    end

    specify '256 => [1] + ([0] * 8)' do
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


  context '.number_to_set_bit_positions_array' do

    specify '9 => [0, 3]' do
      expect(Bitmap.number_to_set_bit_positions_array(9)).to eq([0, 3])
    end

    specify 'a negative number should result in an error' do
      expect { Bitmap.number_to_set_bit_positions_array(-1) }.to raise_error(ArgumentError)
    end
  end


  context '.set_bit_position_array_to_number' do

    specify '[0, 8] => 256' do
      expect(Bitmap.set_bit_position_array_to_number([0, 8])).to eq(257)
    end

    specify '[] => nil' do
      expect(Bitmap.set_bit_position_array_to_number([])).to eq(nil)
    end
  end


  context 'test factory methods' do

    specify 'from_number' do
      expect(Bitmap.from_number(256).number).to eq(256)
    end

    specify 'from_binary_string' do
      expect(Bitmap.from_binary_string("\x01\x00").number).to eq(256)
    end

    specify 'from_value_array' do
      expect(Bitmap.from_value_array([8, 0, 0, 1]).number).to eq(9)
    end

    specify 'from_bit_array' do
      expect(Bitmap.from_bit_array([1, 0, 0, 1]).number).to eq(9)
    end

    specify 'from_set_bit_position_array' do
      expect(Bitmap.from_set_bit_position_array([0, 3]).number).to eq(9)
    end
  end

  context 'test output methods' do

    specify 'to_binary_string' do
      bitmap = Bitmap.from_number(258)
      expect(bitmap.to_binary_string).to eq("\x01\x02")
    end

    specify 'to_value_array' do
      bitmap = Bitmap.from_number(258)
      # expect(bitmap.to_value_array).to eq([0, 2, 0, 0, 0, 0, 0, 0, 256])
      expect(bitmap.to_value_array).to eq([256, 0, 0, 0, 0, 0, 0, 2, 0])
    end

    specify 'to_bit_array' do
      bitmap = Bitmap.from_number(258)
      expect(bitmap.to_bit_array).to eq([1, 0, 0, 0, 0, 0, 0, 1, 0])
    end

    specify 'to_set_bit_position_array' do
      bitmap = Bitmap.from_number(258)
      expect(bitmap.to_set_bit_position_array).to eq([1, 8])
    end
  end

  end
end

