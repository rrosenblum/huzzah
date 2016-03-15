require 'active_support/all'
require 'yaml'

require_relative 'huzzah/util/file_loader'
require_relative 'huzzah/util/site_builder'
require_relative 'huzzah/util/page_builder'
require_relative 'huzzah/util/partial_builder'
require_relative 'huzzah/util/flow_builder'
require_relative 'huzzah/dsl/dsl'
require_relative 'huzzah/dsl/cucumber_dsl'
require_relative 'huzzah/core/locator'
require_relative 'huzzah/core/base'
require_relative 'huzzah/core/role'
require_relative 'huzzah/core/flow'
require_relative 'huzzah/core/site'
require_relative 'huzzah/core/page'

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
    include FileLoader

    attr_accessor :path, :environment, :default_driver

    ##
    # Set the path, environment & default driver.
    #
    # Huzzah.configure do |config|
    #   config.path = <path to your huzzah directory>
    #   config.environment = 'qa'
    #   config.default_driver = 'grid_firefox'
    # end
    #
    def configure
      yield self if block_given?
    end

    ##
    # Returns a has of all user defined watir-webdriver drivers.
    #
    def drivers
      @drivers ||= ActiveSupport::HashWithIndifferentAccess.new
    end

    ##
    # Defines a custom watir-webdriver driver.
    #
    # Example:
    # Huzzah.define_driver(:chrome) do
    #   Watir::Browser.new(:chrome)
    # end
    #
    # You can configure the driver any way you wish, but the block
    # must return a new Watir::Browser instance.
    #
    def define_driver(name, &block)
      drivers[name] = block
    end

    # Retrieve the configuration data for a site. Under normal circumstances, the
    # site config is available after a Huzzah::Role is instantiated. This method
    # provides a way to access the site config before a Huzzah::Role is instantiated.
    #
    def site_config(site_name)
      load_config("#{Huzzah.path}/sites/#{site_name}.yml")
    end

  end

  Huzzah.define_driver(:firefox) do
    Watir::Browser.new(:firefox)
  end

  Huzzah.default_driver = :firefox

end