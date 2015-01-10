require_relative '../../spec_helper'

require 'trick_bag/numeric/bitmap'

module TrickBag
module Numeric

  describe Bitmap do

    specify 'the constructor should not permit being explicitly called outside the class' do
      expect(-> { Bitmap.new }).to raise_error
      # expect { Bitmap.new }.to raise_error
    end

  end




end
end

