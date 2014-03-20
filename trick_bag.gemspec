# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'trick_bag/version'

Gem::Specification.new do |spec|
  spec.name          = "trick_bag"
  spec.version       = TrickBag::VERSION
  spec.authors       = ["Keith Bennett"]
  spec.email         = ["keithrbennett@gmail.com"]
  spec.description   = %q{Miscellaneous general useful tools.}
  spec.summary       = spec.description
  spec.homepage      = "https://github.com/keithrbennett/trick_bag"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "os"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
end
