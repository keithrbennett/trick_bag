require_relative '../../spec_helper'

require 'trick_bag/io/temp_files'

module TrickBag::Io

describe TempFiles do

  it 'creates a readable file with the correct content' do
    TempFiles.file_containing('foo') do |filespec|
      expect(File.read(filespec)).to eq('foo')
    end
  end

  it 'deletes the file when done' do
    filespec = nil
    TempFiles.file_containing('foo') do |fspec|
      filespec = fspec
    end
    expect(File.exist?(filespec)).to eq(false)
  end

  it 'uses the prefix in the filespec' do
    prefix = 'jsiapewrqms'
    TempFiles.file_containing('', prefix) do |filespec|
      filename = File.split(filespec).last
      expect(filename.start_with?(prefix)).to eq(true)
    end
  end
end
end
