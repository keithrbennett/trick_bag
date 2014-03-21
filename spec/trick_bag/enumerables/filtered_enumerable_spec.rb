require_relative '../../spec_helper'
require 'trick_bag/enumerables/filtered_enumerable'

module TrickBag
module Enumerables

  describe FilteredEnumerable do

    let (:even_filter) { ->(n) { n.even? } }
    specify 'with no filter it behaves as a regular enumberable' do
      e = FilteredEnumerable.new([1,2,3])
      expect(e.to_a).to eq([1, 2, 3])
    end

    specify 'an even number filter works correctly when filter passed to constructor' do
      e = FilteredEnumerable.new((1..10).to_a, even_filter)
      expect(e.to_a).to eq([2, 4, 6, 8, 10])
    end

    specify 'an even number filter works correctly when filter passed after creation' do
      e = FilteredEnumerable.new((1..10).to_a)
      e.filter = even_filter
      expect(e.to_a).to eq([2, 4, 6, 8, 10])
    end

    specify 'works as an enumerator' do
      e = FilteredEnumerable.new((1..5).to_a, even_filter)
      enumerator = e.each
      expect(enumerator.next).to eq(2)
      expect(enumerator.next).to eq(4)
      expect(-> { enumerator.next }).to raise_error(StopIteration)
    end

    it 'returns an Enumerator when each is called without a block' do
      expect(FilteredEnumerable.new([]).each).to be_a(Enumerator)
    end

  end
end
end
