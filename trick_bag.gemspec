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

  spec.add_dependency "os", '~> 1.1'
  spec.add_dependency "diffy", '~> 3.0'


  spec.add_dependency 'net-ssh'

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", '~> 3.11'

  unless /java/ === RUBY_PLATFORM
    spec.add_development_dependency 'pry', '~> 0.13'
    spec.add_development_dependency 'pry-byebug', '~> 3.9'
  end
end
