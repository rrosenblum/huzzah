require 'pry'
require 'active_support/all'
require 'yaml'
require_relative 'huzzah/file_loader'
require_relative 'huzzah/locator'
require_relative 'huzzah/site_loader'
require_relative 'huzzah/page_loader'
require_relative 'huzzah/partial_loader'
require_relative 'huzzah/role'
require_relative 'huzzah/site'
require_relative 'huzzah/partial'
require_relative 'huzzah/page'

module Huzzah
  class << self
    attr_accessor :config_path, :environment
  end
end