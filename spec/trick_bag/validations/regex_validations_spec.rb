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


    context '#match_hash' do

      expected_hash =  { /a/ => %w(apple  mango), /m/ => ['mango'], /z/ => [] }

      it 'should return a correct hash' do
        strings = %w(apple  mango)
        actual = match_hash(regexes, strings)
        expect(actual).to eq(expected_hash)
      end

      it 'should return the correct array of NONmatches' do
        expect(regexes_without_matches(expected_hash)).to eq([/z/])
      end

      it 'should return the correct array of matches' do
        expect(regexes_with_matches(expected_hash)).to eq([/a/, /m/])
      end

    end
  end
end

