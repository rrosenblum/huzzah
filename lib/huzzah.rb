require 'active_support/all'
require 'watir-webdriver'
require_relative 'huzzah/dynamic_method_helper'
require_relative 'huzzah/role'
require_relative 'huzzah/site'
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


  class << self

    attr_accessor :path, :environment, :default_driver

    def configure(&block)
      yield self
      require_partials
    end

    def drivers
      @drivers ||= ActiveSupport::HashWithIndifferentAccess.new
    end

    def define_driver(name, &block)
      drivers[name] = block
    end

    def require_partials
      Dir["#{@path}/partials/*.rb"].each do |file|
        require file
      end
    end

  end

  Huzzah.define_driver(:firefox) do
    Watir::Browser.new :firefox
  end

  Huzzah.configure do |config|
    config.default_driver = :firefox
  end

end