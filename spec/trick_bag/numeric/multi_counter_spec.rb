require_relative '../../spec_helper'

require 'trick_bag/numeric/multi_counter'

module TrickBag
module Numeric
  describe MultiCounter do

    subject { MultiCounter.new }

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
      results = %w(Open New Open Closed Open New Closed)
      results.each { |r| subject.increment(r) }
      expect(s˚ubject.total_count).to eq(7)
    end
  end
end
end

