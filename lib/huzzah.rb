require 'active_support/all'
require 'ostruct'
require 'watir-webdriver'
require_relative 'core_ext/string'
require_relative 'core_ext/watir'
require_relative 'huzzah/config'
require_relative 'huzzah/dsl/framework'
require_relative 'huzzah/dsl/web'
require_relative 'huzzah/dsl'
require_relative 'huzzah/flow'
require_relative 'huzzah/method_generators'
require_relative 'huzzah/loader'
require_relative 'huzzah/page'
require_relative 'huzzah/role'
require_relative 'huzzah/session'
require_relative 'huzzah/site'

module Huzzah

  class UndefinedRoleError < StandardError; end
  class UnknownSiteError < StandardError; end
  class NoMethodError < StandardError; end
  class UnknownPageError < StandardError; end
  class DuplicateElementMethodError < StandardError; end
  class SiteNotVisitedError < StandardError; end
  class BrowserNotInitializedError < StandardError; end
  class FlowNameError < StandardError; end
  class PageNameError < StandardError; end
  class BrowserTypeNotDefinedError < StandardError; end
  class GridConfigNotDefinedError < StandardError; end
  class InvalidLetMethodError < StandardError; end
  class DuplicateMethodNameError < StandardError; end
  class RestrictedMethodNameError < StandardError; end

  class << self

    include Huzzah::MethodGenerators
    include Huzzah::Loader

    attr_accessor :config, :active_role

    ##
    # Instantiates the configuration. At a minimum you must
    # provide the path to your 'huzzah' directory, the environment
    # you wish to test against and the browser you want to use.
    # Once the configuration is set it will automatically load all
    # defined Roles, Sites, Apps, Pages, Partials, Flows, Models &
    # Factories.
    #
    def configure(&block)
      @config = Huzzah::Config.new(&block)
      load_all_entities
    end

    ##
    # Returns a hash of the current configuration.
    #
    # @return [Hash{String => String}] A hash of the current configuration.
    #
    def configuration
      @config.inspect
    end

    ##
    # Returns a hash of the known sites.
    #
    # @return [Hash{String => String}] A hash of the known sites.
    #
    def sites
      @sites ||= {}
    end

    ##
    # Instantiates a new Site and adds it to the sites Hash. Sites
    # are simply configuration information about the application
    # under test (e.g. urls, database connection info, etc).
    #
    def add_site(name, data)
      if sites.key? name
        fail DuplicateMethodNameError,
             "Site: #{name} is already defined!"
      end
      sites[name] = Huzzah::Site.new name, data, config.environment
    end

    ##
    # Returns an array of known apps.
    #
    # @return [Array] An array of known apps.
    #
    def apps
      @apps ||= []
    end

    ##
    # Generates a method for the app which takes the page name
    # as an argument. The argument can be passed as a Symbol or
    # a String.
    #
    # Example: App Google
    #   google(:home).search_for 'Huzzah'
    #
    def add_app(name)
      generate_app_method name
      apps << name
    end

    ##
    # Returns an array of known pages.
    #
    # @return [Array] An array of known pages.
    #
    def pages
      @pages ||= {}
    end

    ##
    # Validates that the generated method name for the Page is
    # unique, requires the Page and sets a key for the Page in the
    # pages Hash. The Page is instantiated upon first use.
    #
    def add_page(name, file)
      validate_method_name name
      require file
      pages[name] = nil
    end

    ##
    # Returns a hash of the known roles.
    #
    # @return [Hash{String => String}] A hash of the known roles.
    #
    def roles
      @roles ||= {}
    end

    ##
    # Adds a new user role and creates a new session for the user.
    #
    #    Huzzah.add_role :admin
    #
    def add_role(role_name, data = nil)
      name = role_name.to_sym
      generate_role_method name
      roles[name] = Huzzah::Role.new name, data, config.environment
      @active_role = roles[name]
    end

    ##
    # Add multiple user roles.
    #
    #    Huzzah.add_roles :buyer, :seller, :admin
    #
    def add_roles(*args)
      args.each { |role_name| add_role role_name }
    end

    ##
    # Returns a hash of the known flows.
    #
    # @return [Hash{String => String}] A hash of the known flows.
    #
    def flows
      @flows ||= {}
    end

    ##
    # Validates that the generated method name for the Flow is
    # unique, requires the Flow and sets a key for the Flow in the
    # flows Hash. The flow is instantiated immediately.
    #
    def add_flow(name, file)
      generate_flow_method name
      require file
      flows[name] = name.camelize.constantize.new
    end

    ##
    # Clears all existing sessions, sites, apps & pages
    #
    #    Huzzah.reset!
    #
    def reset!
      @roles = {}
      @sites = {}
      @flows = {}
      @apps = []
      @pages = {}
      reset_defined_methods
    end

    ##
    # Creates a new session for the current user.
    #     Huzzah.reset_current_session!
    #
    def reset_active_role!
      @active_role.reset!
    end
    alias_method :reset_current_session!, :reset_active_role!

    # Legacy Compatibility
    alias_method :current_role, :active_role

  end
end
