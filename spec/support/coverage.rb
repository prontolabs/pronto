if ENV['COVERAGE']
  require 'simplecov'

  SimpleCov.command_name "rspec_#{Process.pid}"
  SimpleCov.start do
    add_filter '/spec/'
  end
end
