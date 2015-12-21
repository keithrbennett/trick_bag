require_relative '../../spec_helper'
require_relative '../../../lib/trick_bag/formatters/binary_to_hex_and_ascii'


module TrickBag
module BinaryToHexAndAscii

  describe BinaryToHexAndAscii do

    include BinaryToHexAndAscii


    context '#one_to_four_bytes_as_hex' do

      specify '1 byte works' do
        expect(one_to_four_bytes_as_hex([1])).to eq('01')
      end

      specify '4 bytes works' do
        expect(one_to_four_bytes_as_hex([0, 16, 64, 255])).to eq('00 10 40 FF')
      end

    end


    context '#offset_string' do
      specify '0x8000 works' do
        expect(offset_string(0x8000)).to match(/8000/)
      end

    end


    context '#join_hex_sections' do
      specify 'is correctly formatted' do
        expect(join_hex_sections(%w(a b c))).to eq('a | b | c')
      end
    end


    context '#ascii_char' do

      test = ->(value, expected) do
        specify "Ascii char of #{value} should be #{expected}" do
          expect(ascii_char(value)).to eq(expected)
        end
      end
      test.('a'.ord, 'a')
      test.('*'.ord, '*')
      test.('_'.ord, '_')
      test.(27, '.')
      test.(127, '.')
      test.(255, '.')
    end


    context '#format' do

      specify '1 line works' do
        bytes = Array.new(15) { |i| i * 8 }
        expect(format(bytes)).to eq("0x   0  00 08 10 18 | 20 28 30 38 | 40 48 50 58 | 60 68 70     .... (08@HPX`hp\n")
      end

      specify '2 lines works' do
        bytes = Array.new(32) { |i| i * 7 }
        expect(format(bytes)).to eq( \
"0x   0  00 07 0E 15 | 1C 23 2A 31 | 38 3F 46 4D | 54 5B 62 69  .....#*18?FMT[bi
0x  10  70 77 7E 85 | 8C 93 9A A1 | A8 AF B6 BD | C4 CB D2 D9  pw~.............\n")
      end
    end
  end
end
end
