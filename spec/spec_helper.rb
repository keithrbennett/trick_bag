require 'rspec'

$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    # disable the `should` syntax; it's deprecated and will later be removed
    c.syntax = :expect
  end
end
