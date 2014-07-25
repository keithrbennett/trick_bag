require_relative '../../spec_helper'

require 'trick_bag/numeric/multi_counter'

module TrickBag
module Numeric
  describe MultiCounter do

    subject { MultiCounter.new }

    let(:sample_data) { %w(Open New Open Closed Open New Closed Open Open Open) }

    it "should instantiate" do
      expect(-> { subject }).not_to raise_error
    end

    it "should increment a class name and return 1" do
      subject.increment('String')
      expect(subject['String']).to eq(1)
    end

    it "should provide a list of keys" do
      keys = %w(foo bar baz)
      keys.each { |key| subject.increment(key) }
      expect(subject.keys.sort).to eq(keys.sort)
    end

    specify 'total_count is correct' do
      sample_data.each { |datum| subject.increment(datum) }
      expect(subject.total_count).to eq(10)
    end

    specify 'creating from an array works correctly' do
      m_counter = MultiCounter.from_enumerable(sample_data)
      expect(m_counter.total_count).to eq(10)
      expect(m_counter['Open']).to eq(6)
    end

    specify 'percent_of_total_hash is correctly calculated' do
      ptotal_hash = MultiCounter.from_enumerable(sample_data).percent_of_total_hash
      expect(ptotal_hash['Open']).to eq(60.0)
      expect(ptotal_hash['Closed']).to eq(20.0)
      expect(ptotal_hash['New']).to eq(20.0)
    end

    specify 'fraction_of_total_hash is correctly calculated' do
      ptotal_hash = MultiCounter.from_enumerable(sample_data).fraction_of_total_hash
      expect(ptotal_hash['Open']).to eq(0.6)
      expect(ptotal_hash['Closed']).to eq(0.2)
      expect(ptotal_hash['New']).to eq(0.2)
    end
  end
end
end

