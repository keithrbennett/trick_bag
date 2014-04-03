require_relative '../../spec_helper.rb'

require 'trick_bag/validations/hash_validations'

module TrickBag

describe Validations do

  include Validations

  context '.missing_hash_entries' do

    it 'should return a correct list of missing keys' do
      h = { a: 1, c: 1, e: 1}
      keys_to_test = [:e, :d, :c, :b, :a]
      expect(missing_hash_entries(h, keys_to_test)).to eq([:d, :b])
    end


    it 'should return an empty array for no missing keys' do
      h = { a: 1, c: 1, e: 1}
      keys_to_test = [:e, :c, :a]
      expect(missing_hash_entries(h, keys_to_test)).to eq([])
    end
  end


  context '.missing_hash_entries_as_string' do

    it 'should return a correct string listing missing keys' do
      h = { a: 1, c: 1, e: 1}
      keys_to_test = [:e, :d, :c, :b, :a]
      expect(missing_hash_entries_as_string(h, keys_to_test)).to eq("[:d, :b]")
    end


    it 'should return nil instead of a string for no missing keys' do
      h = { a: 1, c: 1, e: 1}
      keys_to_test = [:e, :c, :a]
      expect(missing_hash_entries_as_string(h, keys_to_test)).to be_nil
    end
  end


  context '.raise_on_missing_keys'do

    it 'should raise an exception whose message includes the missing keys' do
      my_hash = {}
      missing_keys = [:foo, :bar]
      begin
        raise_on_missing_keys(my_hash, missing_keys)
        fail "An exception should have been raised."
      rescue => e
        message = e.to_s
        missing_keys.each do |key|
          expect(message).to include(key.to_s)
        end
      end
    end

    it 'should not raise an exception when all keys are present' do
      my_hash = { foo: 1, bar: 2, baz: 3}
      expect(->() { raise_on_missing_keys(my_hash, :foo, :baz) }).not_to raise_error
    end
  end
end
end

