require_relative '../../spec_helper'

require 'trick_bag/numeric/bitmap'

module TrickBag
module Numeric


describe Bitmap do


  specify 'the constructor should not permit being explicitly called outside the class' do
    expect(-> { Bitmap.new }).to raise_error
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
      expect(Bitmap.from_bit_array([1, 1, 0, 1]).number).to eq(13)
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


  context 'binary operators' do
    specify '3 & 2 => 2' do
      expect(Bitmap.from_number(3) & 2).to eq(2)
    end

    specify '3 | 2 => 3' do
      expect(Bitmap.from_number(3) | 2).to eq(3)
    end

    specify '3 ^ 2 => 1' do
      expect(Bitmap.from_number(3) ^ 2).to eq(1)
    end

  end

  context 'hash, ==' do
    specify 'instances created with the same value are ==' do
      expect(Bitmap.from_number(1234)).to eq(Bitmap.from_number(1234))
    end

    specify 'instances created with different values are !=' do
      expect(Bitmap.from_number(1234)).to_not eq(Bitmap.from_number(5678))
    end

    specify 'instances created with the same value have the same hash' do
      expect(Bitmap.from_number(1234).hash).to eq(Bitmap.from_number(1234).hash)
    end
  end
end
end
end


