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
