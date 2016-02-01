require 'active_support/all'
require 'yaml'

require_relative 'huzzah/util/file_loader'
require_relative 'huzzah/util/site_builder'
require_relative 'huzzah/util/page_builder'
require_relative 'huzzah/util/partial_builder'
require_relative 'huzzah/util/flow_builder'
require_relative 'huzzah/dsl/dsl'
require_relative 'huzzah/dsl/cucumber_dsl'
require_relative 'huzzah/core/browser'
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

    def site_config(site_name)
      load_config("#{Huzzah.path}/sites/#{site_name}.yml")
    end

  end

  Huzzah.define_driver(:firefox) do
    Watir::Browser.new(:firefox)
  end

  Huzzah.default_driver = :firefox

end