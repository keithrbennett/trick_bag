require_relative '../../spec_helper.rb'

require 'trick_bag/validations/hash_validations'

module TrickBag
module Validations
  describe HashValidations do

  include HashValidations

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


  it 'should return a correct string listing missing keys' do
    h = { a: 1, c: 1, e: 1}
    keys_to_test = [:e, :d, :c, :b, :a]
    expect(missing_hash_entries_as_string(h, keys_to_test)).to eq('d, b')
  end


  it 'should return nil instead of a string for no missing keys' do
    h = { a: 1, c: 1, e: 1}
    keys_to_test = [:e, :c, :a]
    expect(missing_hash_entries_as_string(h, keys_to_test)).to be_nil
  end
end
end
end
