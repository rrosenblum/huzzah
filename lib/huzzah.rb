require 'pry'
require 'active_support/all'
require 'yaml'
require_relative 'huzzah/file_loader'
require_relative 'huzzah/browser'
require_relative 'huzzah/locator'
require_relative 'huzzah/browseable'
require_relative 'huzzah/site_builder'
require_relative 'huzzah/page_builder'
require_relative 'huzzah/partial_loader'
require_relative 'huzzah/flow_builder'
require_relative 'huzzah/role'
require_relative 'huzzah/site'
require_relative 'huzzah/partial'
require_relative 'huzzah/flow'
require_relative 'huzzah/page'
require_relative 'huzzah/cucumber_dsl'

module Huzzah

  class DriverNotDefinedError < StandardError; end
  class DuplicateMethodNameError < StandardError; end
  class DuplicateLocatorMethodError < StandardError; end
  class RestrictedMethodNameError < StandardError; end
  class NoMethodError < StandardError; end
  class RoleNotDefinedError < StandardError; end
  class NotARoleError < StandardError; end
  class UndefinedSiteError < StandardError; end
  class UndefinedPageError < StandardError; end

  class << self

    attr_accessor :path, :environment, :default_driver
    attr_accessor :sites

    def configure
      yield self if block_given?
    end

    def drivers
      @drivers ||= ActiveSupport::HashWithIndifferentAccess.new
    end

    def define_driver(name, &block)
      drivers[name] = block
    end

  end

  Huzzah.define_driver(:firefox) do
    Watir::Browser.new :firefox
  end

  Huzzah.default_driver = :firefox

end