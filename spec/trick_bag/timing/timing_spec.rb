require_relative '../../spec_helper'

require 'trick_bag/timing/timing'

module TrickBag

  describe Timing do

    context '.retry_until_true_or_timeout' do

      it 'returns true when the predicate returns true' do
        count = 0
        predicate = ->{ count += 1; count == 3 }
        return_value = Timing.retry_until_true_or_timeout(0, 1, StringIO.new, predicate)
        expect(return_value).to be(true)
        expect(count).to eq(3)
      end

      it 'returns true when the code block returns true' do
        expect(Timing.retry_until_true_or_timeout(0, 1, StringIO.new) { true }).to eq(true)
      end

      it 'returns false when the predicate fails to return true and a timeout occurs' do
        predicate = -> { false }
        return_value = Timing.retry_until_true_or_timeout(0, 0.1, StringIO.new, predicate)
        expect(return_value).to be(false)
      end

      it 'returns false when the code block fails to return true and a timeout occurs' do
        expect(Timing.retry_until_true_or_timeout(0, 0.1, StringIO.new) { false }).to eq(false)
      end

      # Method signature has changed from:
      # (predicate, sleep_interval, timeout_secs, output_stream = $stdout)
      # to:
      # (sleep_interval, timeout_secs, output_stream = $stdout, predicate = nil)
      #
      # Test to see that when old signature is used, a descriptive error is raised.
      #
      # This test (and the error raising functionality it tests) should probably
      # be removed once this gem goes to version 1.0.
      it 'raises an ArgumentError when a predicate is passed as the first parameter' do
        predicate = -> { false }
        expect { Timing.retry_until_true_or_timeout(predicate, 0, 0.1, StringIO.new) } \
            .to raise_error(ArgumentError)
      end

      it 'raises an ArgumentError when both a predicate lambda and code block are specified' do
        predicate = -> { false }
        expect do
          Timing.retry_until_true_or_timeout(0, 0.1, StringIO.new, predicate) { true }
        end.to raise_error(ArgumentError)
      end
    end


    context '.benchmark' do
      it "returns the passed expression's return value" do
        expect(Timing.benchmark('', '') { 123 }).to eq(123)
      end

      it 'includes the label in the output string' do
        label = 'foo'
        output_string = ''
        Timing.benchmark(label, output_string) {}
        expect(output_string).to include(label)
      end
    end
  end

end
