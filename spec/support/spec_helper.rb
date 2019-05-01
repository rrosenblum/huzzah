$PROJECT_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '../..'))

require 'watir'
require 'pry'
require 'simplecov'

SimpleCov.start do
  add_filter('/spec/')
end
require 'huzzah'
Huzzah.define_driver(:firefox_headless) do
  Watir::Browser.new(:firefox, headless: true)
end

RSpec.configure do |config|
  # These two settings work together to allow you to limit a spec run
  # to individual examples or groups you care about by tagging them with
  # `:focus` metadata. When nothing is tagged with `:focus`, all examples
  # get run.
  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  config.example_status_persistence_file_path = 'spec/examples.txt'
  config.disable_monkey_patching!

  config.order = :random
  Kernel.srand config.seed

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
    expectations.syntax = :expect # Disable `should`
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect # Disable `should_receive` and `stub`
    mocks.verify_partial_doubles = true
  end
end
