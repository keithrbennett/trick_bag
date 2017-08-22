require 'set'
require 'tmpdir'

require_relative '../../spec_helper'
require_relative '../../../lib/trick_bag/io/gitignore'

GI=TrickBag::Io::Gitignore

describe 'Test gitignore' do

  # Returns true on success, false on failure
  def test_a_pair(ignore_spec, expected_to_be_in_ignore_list, filename)
    success = :uninitialized
    Dir.mktmpdir do |tmpdir|
      Dir.chdir(tmpdir) do
        File.write('.gitignore', ignore_spec.join("\n"))
        Dir.mkdir('.hidden_dir') # for some but not all tests
        FileUtils.touch(filename)
        ignored_files = GI.list_ignored_files
        in_ignore_list = ignored_files.include?(filename)
        success = (in_ignore_list == expected_to_be_in_ignore_list)
      end
    end
    success
  end

  it 'should correctly handle a nonhidden file in the root directory' do

    test_inputs = [
        [[],             false],
        [['target'],     true],
        [['**/*arge*'],  true],
        [['*'],          true],
        [['*arge*'],     true],
    ]

    failures = test_inputs.select do |(ignore_spec, expected_result)|
      (test_a_pair(ignore_spec, expected_result, 'target') == false)
    end

    expect(failures).to eq([])
  end

  it 'should correctly handle a hidden file in the root directory' do

    test_inputs = [
        [[],             false],
        [['.target'],    true],
        [['**/*arge*'],  true],
        [['**/.targe*'], true],
        [['*'],          true],
        [['*arge*'],     true],
    ]

    failures = test_inputs.select do |(ignore_spec, expected_result)|
      (test_a_pair(ignore_spec, expected_result, '.target') == false)
    end

    expect(failures).to eq([])
  end

  it 'should correctly handle hidden files in subdirectories of hidden directories' do

    test_inputs = [
        [[],                  false],
        [['.hidden_dir'],     false],
        [['.hidden_dir/'],    true],
        [['hidden_dir/'],     false],
        [['.hidden_dir/.*'],  true],
        [['.hidden_dir/.hidden_file'],  true],
    ]

    failures = test_inputs.select do |(ignore_spec, expected_result)|
      (test_a_pair(ignore_spec, expected_result, '.hidden_dir/.hidden_file') == false)
    end

    expect(failures).to eq([])
  end

  it 'should take an Enumerable that is not an Array' do
    GI.list_ignored_files(Set.new(['target']))
  end
end