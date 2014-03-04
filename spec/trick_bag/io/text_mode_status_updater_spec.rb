require_relative '../../spec_helper'
require 'trick_bag/io/text_mode_status_updater'

module TrickBag
module Io
  describe TextModeStatusUpdater do

    it 'instantiates without error' do
      expect(->{ TextModeStatusUpdater.new(->{ '' }) }).not_to raise_error
    end

    it 'creates a TextModeStatusUpdater' do
      expect(TextModeStatusUpdater.new(->{ '' })).to be_a(TextModeStatusUpdater)
    end

    specify 'the output string contains the content provided by the passed lambda' do
      string_io = StringIO.new
      updater = TextModeStatusUpdater.new(->{ 'status' }, string_io, true)
      updater.print
      expect(string_io.string).to match(/status/)
    end
  end
end
end
