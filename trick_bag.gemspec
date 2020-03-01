# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'trick_bag/version'

Gem::Specification.new do |spec|
  spec.name          = "trick_bag"
  spec.version       = TrickBag::VERSION
  spec.authors       = ["Keith Bennett"]
  spec.email         = ["keithrbennett@gmail.com"]
  spec.description   = %q{Miscellaneous general useful tools for general purpose programming.}
  spec.summary       = %q{Miscellaneous general useful tools.}
  spec.homepage      = "https://github.com/keithrbennett/trick_bag"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "os", '~> 0'
  spec.add_dependency "diffy", '~> 3.0'


  if RUBY_VERSION.split('.').first.to_i >= 2
    spec.add_dependency 'net-ssh'
  else
    spec.add_dependency 'net-ssh', '= 2.9.2'
  end

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", ">= 12.3.3"
  spec.add_development_dependency "rspec", '~> 3.0'

  unless /java/ === RUBY_PLATFORM
    spec.add_development_dependency 'pry', '~> 0.10'
    spec.add_development_dependency 'pry-byebug', '~> 2.0' if RUBY_VERSION >= '2'
  end
end
