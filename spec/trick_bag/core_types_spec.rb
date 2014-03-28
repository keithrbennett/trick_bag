require_relative '../spec_helper'
require 'trick_bag/core_types'

module TrickBag

  describe CoreTypes do

    include CoreTypes

    specify 'deleting nonexistent keys should produce no error and return the original hash' do
      h = { a: 1, b: 2 }
      expect(clone_hash_except(h, [:x, :z])).to eq(h)
    end


    specify 'deleting keys is successful' do
      h = { a: 1, b: 2, c: 3, d: 4 }
      keys_to_delete =  [:b, :d]
      new_h = clone_hash_except(h, keys_to_delete)
      keys_to_delete.each do |key|
        expect(new_h.has_key?(key)).to be_false
      end
    end


    specify 'original hash is unchanged even when keys are deleted' do
      h = { a: 1, b: 2, c: 3, d: 4 }
      h_sav = h.clone
      keys_to_delete =  [:b, :d]
      _ = clone_hash_except(h, keys_to_delete)
      expect(h).to eq(h_sav)
    end
  end
end

