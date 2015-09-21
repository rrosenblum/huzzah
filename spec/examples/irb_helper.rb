$PROJECT_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '../..'))

require 'watir-webdriver'
require 'pry'
require 'huzzah'

Huzzah.configure do |config|
  config.path = "#{$PROJECT_ROOT}/spec/examples"
  config.environment = 'prod'
end

user1 = Huzzah::Role.new(:standard_user)
user2 = Huzzah::Role.new(:standard_user)

binding.pry

user1.browser.close rescue NoMethodError
user2.browser.close rescue NoMethodError