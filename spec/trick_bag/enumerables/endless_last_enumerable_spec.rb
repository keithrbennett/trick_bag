require_relative '../../spec_helper'

require 'trick_bag/enumerables/endless_last_enumerable'

module TrickBag::Enumerables

  describe EndlessLastEnumerable do

    it "should instantiate with an array" do
      expect(->{ EndlessLastEnumerable.new([1]) }).not_to raise_error
    end

    it "should return the 3rd element on the 3rd call to next" do
      array = (0..10).to_a
      e = EndlessLastEnumerable.new(array).each
      2.times { e.next }
      expect(e.next).to eq(2)
    end


    it "should return the last value in the array when the iteration number >= the array size" do
      array = (0..10).to_a
      e = EndlessLastEnumerable.new(array).each
      10.times { e.next }
      2.times { expect(e.next).to eq(10) }
    end


    it "should return the original array and then repeat the last" do
      array = (0..7).to_a
      e = EndlessLastEnumerable.new(array).each
      expect(e.take(20)).to eq(array + ([7] * 12))
    end


    it "should return == for 2 instances created with the same array" do
      array = (0..10).to_a
      e1 = EndlessLastEnumerable.new(array)
      e2 = EndlessLastEnumerable.new(array)
      expect(e1).to eq(e2)
    end


    it "should return != for 2 instances created with arrays that are not equal" do
      e1 = EndlessLastEnumerable.new([1])
      e2 = EndlessLastEnumerable.new([2, 1])
      expect(e1).not_to eq(e2)
    end

    it 'returns an Enumerator when each is called without a block' do
      expect(EndlessLastEnumerable.new([1]).each).to be_a(Enumerator)
    end

    context 'initializing with non-Array enumerables' do
      specify 'it does not raise an error when initialized with a set' do
        set = Set.new([1, 2])
        expect(->() { EndlessLastEnumerable.new(set) }).not_to raise_error
      end

      specify 'it behaves correctly when initialized with a set' do
        set = Set.new([1, 2])
        expect(EndlessLastEnumerable.new(set).take(4)).to eq([1,2,2,2])
      end
    end
  end

end
