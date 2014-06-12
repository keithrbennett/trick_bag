require 'trick_bag/numeric/start_and_max'

module TrickBag
module Numeric


  describe StartAndMax do

    let(:n) { 111 } # arbitrary number

    context '#start_position_reached?' do
      it 'considers first element to be included when no start position and max are specified' do
        expect(StartAndMax.new.start_position_reached?(0)).to eq(true)
      end

      it 'considers first element to be included when start position == n' do
        expect(StartAndMax.new(n).start_position_reached?(n)).to eq(true)
      end

      it 'considers first element to be included when start position < n' do
        expect(StartAndMax.new(n).start_position_reached?(n + 1)).to eq(true)
      end

      it 'considers first element NOT to be included when start position is specified but n < start' do
        expect(StartAndMax.new(n).start_position_reached?(n - 1)).to eq(false)
      end
    end

    context '#max_count_reached?' do
      it 'returns false for a very large number when max is not specified' do
        expect(StartAndMax.new.max_count_reached?(10 ** 100)).to eq(false)
      end

      it 'returns true when when n == max' do
        expect(StartAndMax.new(0, n).max_count_reached?(n)).to eq(true)
      end

      it 'returns false when when n < max' do
        expect(StartAndMax.new(0, n).max_count_reached?(n - 1)).to eq(false)
      end

      it 'returns true when when n > max' do
        expect(StartAndMax.new(0, n).max_count_reached?(n + 1)).to eq(true)
      end
    end
  end


end
end
