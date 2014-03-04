require_relative '../../spec_helper'
require 'trick_bag/enumerables/compound_enumerable'

module TrickBag
module Enumerables

  describe CompoundEnumerable do

    context 'input validations' do

      specify 'an initialization error will be raised if no enumerables are specified' do
        expect(->{ CompoundEnumerable.array_enumerable() }).to raise_error
        expect(->{ CompoundEnumerable.hash_enumerable([:key]) }).to raise_error
      end

      specify 'an initialization error will be raised if mode is not :yields_arrays or :yields_hashes' do
        expect(->{ CompoundEnumerable.new(:bad_mode, [], [])}).to raise_error
      end

      specify 'an initialization error will be raised if key array size != enumerables size in :yields_hashes mode' do
        expect(->{ CompoundEnumerable.new(:yields_hashes, [:key1, :key2], [])}).to raise_error
        expect(->{ CompoundEnumerable.hash_enumerable([:key1, :key2], [])}).to raise_error
      end
    end



    context "as array" do

      context 'with 1 enumerable' do
        specify 'Gets its values then raises a StopIteration error' do
          array = [1, 2]
          e = CompoundEnumerable.array_enumerable(array).each
          expect(e.next).to eq(1)
          expect(e.next).to eq(2)
          expect(->{ e.next }).to raise_error(StopIteration)
        end
      end


      context 'with 2 enumerables' do
        specify 'offers correct values in the correct order' do
          outer = %w(A B)
          inner = [1, 2]
          e = CompoundEnumerable.array_enumerable(outer, inner).each
          expect(e.next).to eq(['A', 1])
          expect(e.next).to eq(['A', 2])
          expect(e.next).to eq(['B', 1])
          expect(e.next).to eq(['B', 2])
          expect(->{ e.next }).to raise_error(StopIteration)
        end
      end


      context 'with 3 enumerables' do
        specify 'offers correct values in the correct order' do
          domains = %w(aaa.com  zzz.com)
          qtypes = %w(A  NS)
          qclasses = %w(IN  CH)
          e = CompoundEnumerable.array_enumerable(domains, qtypes, qclasses).each

          expect(e.next).to eq(['aaa.com', 'A', 'IN'])
          expect(e.next).to eq(['aaa.com', 'A', 'CH'])
          expect(e.next).to eq(['aaa.com', 'NS', 'IN'])
          expect(e.next).to eq(['aaa.com', 'NS', 'CH'])
          expect(e.next).to eq(['zzz.com', 'A', 'IN'])
          expect(e.next).to eq(['zzz.com', 'A', 'CH'])
          expect(e.next).to eq(['zzz.com', 'NS', 'IN'])
          expect(e.next).to eq(['zzz.com', 'NS', 'CH'])
          expect(->{ e.next }).to raise_error(StopIteration)
        end
      end

      context 'is an Enumerable' do
        it "provides the 'take' method" do
          expect(->{ CompoundEnumerable.array_enumerable([1, 2, 3]).take(2)}).not_to raise_error
        end
      end
    end


    context "as hash" do

      context 'with 1 enumerable' do
        specify 'Gets its values then raises a StopIteration error' do
          array = [1, 2]
          e = CompoundEnumerable.hash_enumerable([:number], array).each
          expect(e.next).to eq({ number: 1 })
          expect(e.next).to eq({ number: 2 })
          expect(->{ e.next }).to raise_error(StopIteration)
        end
      end


      context 'with 2 enumerables' do
        specify 'offers correct values in the correct order' do
          outer = %w(A B)
          inner = [1, 2]
          e = CompoundEnumerable.hash_enumerable([:outer, :inner], outer, inner).each
          expect(e.next).to eq({ outer: 'A', inner: 1 })
          expect(e.next).to eq({ outer: 'A', inner: 2 })
          expect(e.next).to eq({ outer: 'B', inner: 1 })
          expect(e.next).to eq({ outer: 'B', inner: 2 })
          expect(->{ e.next }).to raise_error(StopIteration)
        end
      end


      context 'with 3 enumerables' do
        specify 'offers correct values in the correct order' do
          domains = %w(aaa.com  zzz.com)
          qtypes = %w(A  NS)
          qclasses = %w(IN  CH)
          keys = [:domain, :qtype, :qclass]
          e = CompoundEnumerable.hash_enumerable(keys, domains, qtypes, qclasses).each

          expect(e.next).to eq({ domain: 'aaa.com', qtype: 'A', qclass: 'IN' })
          expect(e.next).to eq({ domain: 'aaa.com', qtype: 'A', qclass: 'CH' })
          expect(e.next).to eq({ domain: 'aaa.com', qtype: 'NS', qclass: 'IN' })
          expect(e.next).to eq({ domain: 'aaa.com', qtype: 'NS', qclass: 'CH' })

          expect(e.next).to eq({ domain: 'zzz.com', qtype: 'A', qclass: 'IN' })
          expect(e.next).to eq({ domain: 'zzz.com', qtype: 'A', qclass: 'CH' })
          expect(e.next).to eq({ domain: 'zzz.com', qtype: 'NS', qclass: 'IN' })
          expect(e.next).to eq({ domain: 'zzz.com', qtype: 'NS', qclass: 'CH' })
          expect(->{ e.next }).to raise_error(StopIteration)
        end
      end

      context 'is an Enumerable' do
        it "provides the 'take' method" do
          expect(->{ CompoundEnumerable.hash_enumerable([:num], [1, 2, 3]).take(2)}).not_to raise_error

          values = CompoundEnumerable.hash_enumerable([:num], [1, 2, 3]).take(2)
          expect(values).to eq([{ num: 1 }, { num: 2 }])
        end
      end
    end
  end
end
end
