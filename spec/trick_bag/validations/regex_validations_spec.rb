require_relative '../../spec_helper.rb'

require 'trick_bag/validations/regex_validations'

module TrickBag

  describe Validations do

    include Validations

    let(:regexes) { [/a/, /m/, /z/] }

    context '#matches_any_regex?' do

      it 'should return true on any match' do
        expect(matches_any_regex?(regexes, 'a')).to eq(true)
      end

      it 'should return false on no match' do
        expect(matches_any_regex?(regexes, 'b')).to eq(false)
      end

    end


    context '#matches_all_regexes?' do

      it 'should return true on match all' do
        expect(matches_all_regexes?(regexes, 'amz')).to eq(true)
      end

      it 'should return false on no match or match some' do
        expect(matches_all_regexes?(regexes, 'b')).to eq(false)
        expect(matches_all_regexes?(regexes, 'am')).to eq(false)
      end

    end


    context '#matches_no_regexes?' do

      it 'should return true on match' do
        expect(matches_no_regexes?(regexes, 'bny')).to eq(true)
      end

      it 'should return false on any or all matches' do
        expect(matches_no_regexes?(regexes, 'a')).to eq(false)
        expect(matches_no_regexes?(regexes, 'amz')).to eq(false)
      end

    end
  end
end

