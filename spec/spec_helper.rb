$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'bundler'
Bundler.require :default

require 'coveralls'
Coveralls.wear!

RSpec.configure do |config|
  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.run_all_when_everything_filtered = true

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  # After each test spec rollback configuration to its default state
  config.after(:each) do
    Elasticonf.config.reset_config!
  end
end
