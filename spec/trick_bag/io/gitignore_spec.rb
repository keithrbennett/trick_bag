require 'set'
require 'tmpdir'

require_relative '../../spec_helper'
require_relative '../../../lib/trick_bag/io/gitignore'

GI=TrickBag::Io::Gitignore

describe TrickBag::Io::Gitignore do
  shared_examples_for 'testing a pair' do |ignore_spec, expected_result, filename|
    let(:ignored_files)  { GI.list_ignored_files }
    let(:in_ignore_list) { ignored_files.include?(filename) }
    let(:error_message) do
      "filename: '#{filename}', ignore_spec: #{ignore_spec}, expected result: #{expected_result}, got: #{in_ignore_list}, ignored files: #{ignored_files}"
    end

    around do |example|
      Dir.mktmpdir do |tmpdir|
        Dir.chdir(tmpdir) do
          File.write('.gitignore', ignore_spec.join("\n"))
          Dir.mkdir('a_dir')        # for some but not all tests
          Dir.mkdir('.hidden_dir')  # for some but not all tests
          FileUtils.touch(filename) # for some but not all tests
          example.run
        end
      end
    end

    it { expect(in_ignore_list).to eq(expected_result), error_message }
  end

  context 'handling a nonhidden file in the root directory', :aggregate_failures do
    test_inputs = [
        [[],             false],
        [['target'],     true],
        [['**/*arge*'],  true],
        [['*'],          true],
        [['*arge*'],     true],
    ]

    test_inputs.each do |(ignore_spec, expected_result)|
      context do # without a context block the way that rspec expands the examples causes the parameters to overwrite each other
        include_examples 'testing a pair', ignore_spec, expected_result, 'target'
      end
    end
  end

  context 'handling a hidden file in the root directory', :aggregate_failures do
    test_inputs = [
        [[],             false],
        [['.target'],    true],
        [['**/*arge*'],  true],
        [['**/.targe*'], true],
        [['*'],          true],
        [['*arge*'],     true],
    ]

    test_inputs.each do |(ignore_spec, expected_result)|
      context do # without a context block the way that rspec expands the examples causes the parameters to overwrite each other
        include_examples 'testing a pair', ignore_spec, expected_result, '.target'
      end
    end
  end

  context 'handling hidden files in subdirectories of hidden directories', :aggregate_failures do
    test_inputs = [
        [[],                  false],
        [['.hidden_dir'],     false],
        [['.hidden_dir/'],    true],
        [['hidden_dir/'],     false],
        [['.hidden_dir/.*'],  true],
        [['.hidden_dir/.hidden_file'],  true],
    ]

    test_inputs.each do |(ignore_spec, expected_result)|
      context do # without a context block the way that rspec expands the examples causes the parameters to overwrite each other
        include_examples 'testing a pair', ignore_spec, expected_result, '.hidden_dir/.hidden_file'
      end
    end
  end

  it 'should take an Enumerable that is not an Array' do
    GI.list_ignored_files(Set.new(['target']))
  end

  context 'directories should not be included', :aggregate_failures do
    context { include_examples 'testing a pair', ['*'], false, 'a_dir' }
    context { include_examples 'testing a pair', ['*'], false, '.hidden_dir' }
  end

  context 'includes should be all files not in ignore list', :aggregate_failures do
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

    around do |example|
      Dir.mktmpdir do |tmpdir|
        Dir.chdir(tmpdir) do
          %w(a_dir  .hidden_dir  x/y/z).each { |dirspec| FileUtils.mkdir_p(dirspec) }
          %w(root  a_dir/sub  .hidden_dir/.hidden_file  x/y/z/deep).each { |f| FileUtils.touch(f) }
          File.write('.gitignore', ignore_spec.join("\n"))
          example.run
        end
      end
    end

    test_inputs.each do |ignore_spec|
      context do
        let(:ignore_spec)    { ignore_spec }
        let(:ignored_files)  { GI.list_ignored_files(ignore_spec).sort }
        let(:included_files) { GI.list_included_files(ignore_spec).sort }
        let(:intersection)   { included_files & ignored_files }
        let(:union)          { included_files | ignored_files }
        let(:all_files) do
          Dir.glob('**/*', File::FNM_DOTMATCH).reject do |filespec|
            File.directory?(filespec)
          end.sort
        end

        it { expect(intersection).to eq([]), "expected no overlap between ignored and included for #{ignore_spec}, got #{intersection}" }
        it { expect(union.sort).to eq(all_files), "expected ignored and included to contain all files for #{ignore_spec}, got #{union}" }
      end
    end
  end
end
