require 'rspec'
require 'pronto'

RSpec.configure do |config|
  config.color_enabled = true
  config.filter_run(focus: true)
  config.run_all_when_everything_filtered = true
  config.treat_symbols_as_metadata_keys_with_true_values = true

  config.before(:each) do
    @lib_path = Pathname.new(File.expand_path('../../lib/', __FILE__))
  end
end
