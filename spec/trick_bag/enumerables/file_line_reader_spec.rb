require 'os'
require 'tempfile'

require_relative '../../spec_helper'
require 'trick_bag/enumerables/file_line_reader'

module TrickBag
module Enumerables

describe FileLineReader do

  TEST_DOMAINS = %w(abc.com cbs.com nbc.com)

  DOMAIN_FILE_CONTENT = \
"# Comment text followed by a blank line

abc.com
cbs.com

    # Another comment, but this time with whitespace before it
nbc.com
"

    before(:each) do
      @tempfile = Tempfile.new('file_domain_reader_spec')
      @tempfile.write DOMAIN_FILE_CONTENT
      @tempfile.close
    end

    after(:each) do
      @tempfile.unlink
    end

    let(:can_run_lsof?) { OS.posix? && system('which lsof > /dev/null') }

    subject { FileLineReader.new(@tempfile.path) }


    it "should create a temporary file" do
      expect(File.exist?(@tempfile.path)).to be_true
    end

    it "should produce an array" do
      expect(subject.to_a).to be_a(Array)
    end

    it "should produce a nonempty array" do
      expect(subject.to_a.empty?).to be_false
    end

    it "should produce a nonempty array containing 'abc.com'" do
      expect(subject.to_a.include?('abc.com')).to be_true
    end

    it "should produce an array without blank lines" do
      expect(subject.to_a.include?('')).to be_false
    end

    it "should produce an array without beginning comment characters" do
      expect(subject.to_a.detect { |s| /^#/ === s }).to be_nil
    end

    it "should produce an array containing TEST_DOMAINS" do
      expect(subject.to_a).to eq(TEST_DOMAINS)
    end

    it "should have a working 'each' function" do
      array = []
      subject.each { |name| array << name}
      expect(array).to eq(TEST_DOMAINS)
    end

    it "should respect a start_pos" do
      p = FileLineReader.new(@tempfile.path, 1)
      expect(p.to_a).to eq(TEST_DOMAINS[1..-1])
    end

    it "should respect a max_count" do
      p = FileLineReader.new(@tempfile.path, 0, 2)
      expect(p.to_a).to eq(TEST_DOMAINS[0..1])
    end

    it 'should be usable as an Enumerable' do
      e = subject.each
      expect(e).to be_an(Enumerable)
      expect(->{ 3.times { e.next} }).not_to raise_error
      expect(->{ e.next }).to raise_error(StopIteration)
      e.close
    end

    # If this test fails, it's probably the test before it that
    # failed to close its file.
    it 'closes the file even when its end is not reached' do

      unless can_run_lsof?
        pending "This test can only be run on a Posix-based OS having the 'lsof' command."
      end

      get_lsof_lines = -> do
        output = `lsof -p #{Process.pid} | grep file_domain_reader_spec`
        output.split("\n")
      end

      reader = FileLineReader.new(@tempfile.path, 0, 1)
      reader.each do |line|
        expect(get_lsof_lines.().size).to eq(1)
      end
      expect(get_lsof_lines.().size).to eq(0)
    end


    specify "calling the enumerator's close method multiple times will not raise an error" do
      enumerator = subject.each
      expect(-> { 3.times { enumerator.close } }).not_to raise_error
    end

    specify "start_pos returns the value passed to the constructor" do
      expect(FileLineReader.new(@tempfile.path, 10).start_pos).to eq(10)
    end

    specify "max_count returns the value passed to the constructor" do
      expect(FileLineReader.new(@tempfile.path, 10, 200).max_count).to eq(200)
    end

  end
end
end


