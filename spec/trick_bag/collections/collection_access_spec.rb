require_relative '../../spec_helper'
require 'trick_bag/collections/collection_access'


module TrickBag
module CollectionAccess


describe CollectionAccess do

  context '#access' do

    it 'works with a single key' do
      h = { 'a' => 123 }
      expect(CollectionAccess.access(h, 'a')).to eq(123)
    end

    it 'works with 2 keys' do
      h = { 'a' => { 'b' => 234 }}
      expect(CollectionAccess.access(h, 'a.b')).to eq(234)
    end

    it 'works with 3 keys' do
      h = { 'a' => { 'bb' => { 'ccc' => 345 }}}
      expect(CollectionAccess.access(h, 'a.bb.ccc')).to eq(345)
    end

    it 'works with spaces as separators' do
      h = { 'a' => { 'bb' => { 'ccc' => 345 }}}
      expect(CollectionAccess.access(h, 'a bb ccc', ' ')).to eq(345)

    end

    it 'works with spaces as separators with multiple spaces' do
      h = { 'a' => { 'bb' => { 'ccc' => 345 }}}
      expect(CollectionAccess.access(h, 'a      bb ccc', ' ')).to eq(345)
    end

    it 'works with numeric array subscripts 1 deep' do
      a = ['a', 'b']
      expect(CollectionAccess.access(a, '1')).to eq('b')
    end

    it 'works with a hash containing an array' do
      h = { 'h' => ['a', 'b'] }
      expect(CollectionAccess.access(h, 'h.1')).to eq('b')
    end

    it 'raises an error when accessing an invalid key' do
      h = { 'h' => ['a', 'b'] }
      expect(-> { CollectionAccess.access(h, 'x.1.2') }).to raise_error
    end
  end


  context '#accessor' do

    it 'works with a hash containing an array' do
      h = { 'h' => ['a', 'b'] }
      accessor = CollectionAccess.accessor(h)
      expect(accessor['h.1']).to eq('b')
    end

  end


end


end
end
