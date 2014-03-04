require_relative '../../spec_helper'

require 'trick_bag/numeric/totals'

module TrickBag
module Numeric

  describe Totals do

    it "calculates correct fraction of total" do
      expect(Totals.map_fraction_of_total([2, 4, 6, 8])).to eq([0.1, 0.2, 0.3, 0.4])
    end

    it "calculates correct percent of total" do
      expect(Totals.map_percent_of_total([2, 4, 6, 8])).to eq([10, 20, 30, 40])
    end

    it "returns an empty array when handed an empty array" do
      expect(Totals.map_percent_of_total([])).to eq([])
      expect(Totals.map_fraction_of_total([])).to eq([])
    end

    it 'produces a correct % of total hash' do
      orig_hash = { foo: 100, bar: 200, baz: 300, razz: 400 }
      percent_hash = Totals.percent_of_total_hash(orig_hash)
      expected_hash = { foo: 10.0, bar: 20.0, baz: 30.0, razz: 40.0 }
      expect(percent_hash).to eq(expected_hash)
    end

    it 'produces a correct fraction of total hash' do
      orig_hash = { foo: 100, bar: 200, baz: 300, razz: 400 }
      percent_hash = Totals.fraction_of_total_hash(orig_hash)
      expected_hash = { foo: 0.1, bar: 0.2, baz: 0.3, razz: 0.4 }
      expect(percent_hash).to eq(expected_hash)
    end
  end
end
end
