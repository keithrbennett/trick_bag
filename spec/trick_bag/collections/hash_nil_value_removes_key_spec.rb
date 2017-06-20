require_relative '../../spec_helper'
require 'trick_bag/collections/hash_nil_value_removes_key'

module TrickBag
  module Collections

    describe HashNilValueRemovesKey do

      it "removes a key whose value was set to nil" do
        subject[:foo] = 'bar'
        expect(subject[:foo]).to eq('bar')
        subject[:foo] = nil
        expect(subject.keys.empty?).to eq(true)
      end

      it 'does not raise an error when setting a nonexistent key to nil' do
        subject[:non_existent_key] = nil
      end

      it 'does not remove a key whose value is set to a non-nil value.' do
        subject[:hello] = 'there'
        expect(subject[:hello]).to eq('there')
        subject[:hello] = 'again'
        expect(subject[:hello]).to eq('again')
      end
    end
  end
end

