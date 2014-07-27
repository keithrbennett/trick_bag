require_relative '../../spec_helper'
require 'trick_bag/enumerables/buffered_enumerable'

module TrickBag
module Enumerables

  describe BufferedEnumerable do

    context 'when created with lambdas' do
      # Returns an object that returns chunks of incrementing integers.
      let(:fetcher) do
        object = 0
        ->(array, chunk_size) do
          chunk_size.times do
            object += 1
            array << object
          end
        end
      end

      specify 'the values and number of fetches are correct' do
        chunk_fetch_calls = 0
        object_count = 0

        fetch_notifier = ->(fetched_objects) do
          chunk_fetch_calls += 1
          object_count += fetched_objects.size
        end

        e = BufferedEnumerable.create_with_lambdas(4, fetcher, fetch_notifier).to_enum
        (1..10).each { |n| expect(e.next).to eq(n) }
        expect(chunk_fetch_calls).to eq(3)
        expect(object_count).to eq(12)
      end

      specify 'create_with_lambdas can be called without specifying a fetch_notifier' do
        be = nil
        f1 = -> { be = BufferedEnumerable.create_with_lambdas(4, fetcher).to_enum }
        expect(f1).not_to raise_error
        f2 = -> { (1..10).each { be.next } }
        expect(f2).not_to raise_error
      end
    end


    context "when instantiating a subclass" do
      specify 'the values and number of fetches are correct' do
        create_test_class = ->() do
          class BufferedEnumerableSubclass < BufferedEnumerable

            attr_accessor :chunk_fetch_calls, :object_count

            def initialize(chunk_size)
              super
              @chunk_fetch_calls = 0
              @object_count = 0
            end

            def fetch_notify
              @chunk_fetch_calls += 1
              @object_count += data.size
            end

            def fetch
              @object ||= 0
              chunk_size.times do
                @object += 1
                self.data << @object
              end
            end
          end
        end

        create_test_class.()
        enumerable = BufferedEnumerableSubclass.new(4)
        enumerator = enumerable.each

        (1..10).each do |n|
          expect(enumerator.next).to eq(n)
        end
        expect(enumerator).to be_a(Enumerator)
        expect(enumerable.chunk_fetch_calls).to eq(3)
        expect(enumerable.object_count).to eq(12)
        ::TrickBag::Meta::Classes.undef_class(:BufferedEnumerableSubclass, TrickBag)
      end
    end


    context "an Array implementation" do

      create_array_subclass = -> do
        class ArrayBufferedEnumerable < BufferedEnumerable

          def initialize(chunk_size, array)
            super(chunk_size)
            @inner_enumerable = array
          end

          def fetch
            num_times = [chunk_size, @inner_enumerable.size].min
            num_times.times { @data << @inner_enumerable.shift }
          end
        end
      end

      it 'should fulfill its basic functions' do
        create_array_subclass.()
        enumerable = ArrayBufferedEnumerable.new(4, (0..5).to_a)
        enumerator = enumerable.each

        (0..5).to_a.each do |n|
          expect(enumerator.next).to eq(n)
        end
        expect(->{ enumerator.next }).to raise_error(StopIteration)
        expect(enumerable.chunk_count).to eq(2)

        ::TrickBag::Meta::Classes.undef_class(:ArrayBufferedEnumerable, TrickBag)

      end
    end
  end
end
end
