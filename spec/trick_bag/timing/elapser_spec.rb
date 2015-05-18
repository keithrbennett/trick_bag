require_relative '../../spec_helper'

require 'trick_bag/timing/elapser'

module TrickBag
  module Timing

    describe Elapser do

      def test_number(number)
        e = Elapser.new(number)
        expect(e.class).to eq(Elapser)
        expect(e.seconds).to eq(number)
        expect(e.end_time - Time.now).to be_within(2.0).of(number)
      end


      context 'instantiation' do

        it 'can take an integer' do
          test_number(30)
        end

        it 'can take a float' do
          test_number(30.0)
        end

        it 'can take an end time' do
          now = Time.now
          e = Elapser.new(now + 30)
          expect(e.class).to eq(Elapser)
          expect(e.seconds).to be_within(0.1).of(30)
          expect(e.end_time - Time.now).to be_within(0.1).of(30)
        end

        specify 'an invalid parameter type raises an error' do
          expect { Elapser.new(nil) }.to raise_error(ArgumentError)
          expect { Elapser.new('30') }.to raise_error(ArgumentError)
        end
      end


      context '#elapsed?' do

        specify 'elapsed? returns true if seconds is negative' do
          expect(Elapser.new(-1).elapsed?).to eq(true)
        end

        specify 'elapsed? returns false if seconds is positive' do
          expect(Elapser.new(100).elapsed?).to eq(false)
        end
      end


      context '.from' do
        specify 'calling with an Elapsed instance returns that instance' do
          e = Elapser.new(30)
          expect(Elapser.from(e)).to equal(e)
        end

        specify 'calling with a number or time works correctly' do
          now = Time.now
          secs = 45

          expect(Elapser.from(secs).seconds - (Elapser.new(secs).seconds)).to be_within(1).of(0)
          expect(Elapser.from(secs).end_time - (Elapser.new(secs).end_time)).to be_within(1).of(0)

          expect(Elapser.from(now).seconds - (Elapser.new(now).seconds)).to be_within(1).of(0)
          expect(Elapser.from(now).end_time - (Elapser.new(now).end_time)).to be_within(1).of(0)
        end


      end


      context '.never' do

        specify 'never_elapser is intialized correctly' do
          expect(Elapser.never_elapser.elapsed?).to eq(false)
          expect(Elapser.never_elapser.never_elapse).to eq(true)

          expect(Elapser.from(:never).elapsed?).to eq(false)
          expect(Elapser.from(:never).never_elapse).to eq(true)
        end
      end
    end
  end
end

