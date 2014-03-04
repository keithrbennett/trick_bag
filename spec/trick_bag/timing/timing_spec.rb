require_relative '../../spec_helper'

require 'trick_bag/timing/timing'

module TrickBag

  describe Timing do

    it 'returns when the predicate returns true' do
      count = 0
      predicate = ->{ count += 1; count == 3 }
      Timing.retry_until_true_or_timeout(predicate, 0, 1, StringIO.new)
      expect(count).to eq(3)
    end
  end

end
