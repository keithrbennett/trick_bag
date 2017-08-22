require 'set'
require 'tmpdir'

require_relative '../../spec_helper'
require_relative '../../../lib/trick_bag/io/gitignore'

GI=TrickBag::Io::Gitignore

describe TrickBag::Io::Gitignore do

  # Pass this a block to perform in the test directory.
  def create_and_populate_test_directory(ignore_spec)
    Dir.mktmpdir do |tmpdir|
      Dir.chdir(tmpdir) do
        %w(a_dir  .hidden_dir  x/y/z).each { |dirspec| FileUtils.mkdir_p(dirspec) }
        %w(root  a_dir/sub  .hidden_dir/.hidden_file  x/y/z/deep).each { |f| FileUtils.touch(f) }
        File.write('.gitignore', ignore_spec.join("\n"))
        yield
      end
    end
  end


  # Returns true on success, false on failure
  def test_a_pair(ignore_spec, expected_to_be_in_ignore_list, filename)
    success = :uninitialized
    Dir.mktmpdir do |tmpdir|
      Dir.chdir(tmpdir) do
        File.write('.gitignore', ignore_spec.join("\n"))
        Dir.mkdir('a_dir')       # for some but not all tests
        Dir.mkdir('.hidden_dir') # for some but not all tests
        FileUtils.touch(filename)      # for some but not all tests
        ignored_files = GI.list_ignored_files
        in_ignore_list = ignored_files.include?(filename)
        success = (in_ignore_list == expected_to_be_in_ignore_list)
      end
    end
    success
  end


  def test_included_and_ignored(ignore_spec)

    all_files = Dir.glob('**/*', File::FNM_DOTMATCH).reject do |filespec|
      File.directory?(filespec)
    end.sort
    ignored_files = GI.list_ignored_files(ignore_spec).sort
    included_files = GI.list_included_files(ignore_spec).sort

    expect(included_files & ignored_files).to eq([])
    expect((included_files | ignored_files).sort).to eq(all_files)
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

  it 'should not include directories' do
    expect(test_a_pair(['*'], false, 'a_dir')).to       eq(true)
    expect(test_a_pair(['*'], false, '.hidden_dir')).to eq(true)
  end

  specify 'includes should be all files not in ignore list', :aggregate_failures do
    test_inputs = [
        [],
        ['*'],
        ['**/*'],
        ['x/y/z'],
        ['x/y/z/*'],
        ['x/y/z/**/*'],
        ['x/y/z/**/deep'],
        ['.hidden_dir'],
        ['.hidden_dir/'],
        ['hidden_dir/'],
        ['.hidden_dir/.*'],
        ['.hidden_dir/.hidden_file'],
    ]
    test_inputs.select do |ignore_spec|
      create_and_populate_test_directory(ignore_spec) do
        test_included_and_ignored(ignore_spec)
      end
    end
  end
end