$PROJECT_ROOT = File.expand_path(File.join(File.dirname(__FILE__)))

require 'watir-webdriver'
require 'pry'
require 'simplecov'
require 'factory_girl'

SimpleCov.start
require 'huzzah'

def configure_test_site
  Huzzah.reset!
  Huzzah.configure do |config|
    config.path = "#{$PROJECT_ROOT}/examples/test_site"
    config.browser_type = :firefox
    config.environment = 'local'
  end
  Huzzah.sites[:test_site].url = "file://#{$PROJECT_ROOT}/html/index.html"
end

def configure_google
  Huzzah.reset!
  Huzzah.configure do |config|
    config.path = "#{$PROJECT_ROOT}/examples/google"
    config.browser_type = :firefox
    config.environment = 'prod'
  end
end
