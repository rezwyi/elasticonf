$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'bundler'
Bundler.require :default

require 'coveralls'
Coveralls.wear!

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true

  # After each test spec rollback configuration to its default state
  config.after(:each) { Elasticonf.config.reset_config! }
end
