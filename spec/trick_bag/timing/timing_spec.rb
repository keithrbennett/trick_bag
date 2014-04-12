require_relative '../../spec_helper'

require 'trick_bag/timing/timing'

module TrickBag

  describe Timing do

    context '.retry_until_true_or_timeout' do
      it 'returns when the predicate returns true' do
        count = 0
        predicate = ->{ count += 1; count == 3 }
        Timing.retry_until_true_or_timeout(predicate, 0, 1, StringIO.new)
        expect(count).to eq(3)
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
