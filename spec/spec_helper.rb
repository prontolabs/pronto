require 'support/coverage'

require 'rspec'
require 'rspec/its'

require 'pronto'

RSpec.configure do |config|
  config.order = :random
  Kernel.srand config.seed

  config.expect_with(:rspec) { |c| c.syntax = :should }
  config.mock_with(:rspec) { |c| c.syntax = :should }
end

def load_fixture(fixture_name)
  path = File.join(%w[spec fixtures], fixture_name)
  File.read(path).strip
end
