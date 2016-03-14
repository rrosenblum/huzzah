$PROJECT_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '../..'))

require 'watir-webdriver'
require 'pry'
require 'simplecov'

SimpleCov.start do
  add_filter('/spec/')
end
require 'huzzah'