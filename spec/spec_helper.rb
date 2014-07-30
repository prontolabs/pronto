require 'rspec'
require 'rspec/its'
require 'pry'
require 'ostruct'

require 'pronto'

RSpec.configure do |config|
  config.expect_with(:rspec) { |c| c.syntax = :should }
  config.mock_with(:rspec) { |c| c.syntax = :should }
end

def repository
  Pronto::Git::Repository.new('.')
end

def load_fixture(fixture_name)
  path = File.join(%w(spec support files), fixture_name)
  File.read(path).strip
end
