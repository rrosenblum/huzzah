require 'active_support/all'
require 'ostruct'
require 'watir-webdriver'
require_relative 'core_ext/string'
require_relative 'core_ext/watir'
require_relative 'huzzah/dsl'
require_relative 'huzzah/flow'
require_relative 'huzzah/page'
require_relative 'huzzah/session'
require_relative 'huzzah/config'

module Huzzah

  class RoleAlreadyDefinedError < StandardError; end
  class UndefinedRoleError < StandardError; end
  class UnknownSiteError < StandardError; end
  class NoMethodError < StandardError; end
  class UnknownPageError < StandardError; end
  class DuplicateElementMethodError < StandardError; end
  class DuplicateValueMethodError < StandardError; end
  class SiteNotVisitedError < StandardError; end
  class BrowserNotInitializedError < StandardError; end
  class FlowNameError < StandardError; end
  class PageNameError < StandardError; end
  class BrowserTypeNotDefinedError < StandardError; end
  class GridConfigNotDefinedError < StandardError; end
  class InvalidLetMethodError < StandardError; end

  class << self

    attr_accessor :config, :current_role, :current_session


    def configure(&block)
      @config = Huzzah::Config.new &block
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
    # Returns a hash of the known roles.
    #
    # @return [Hash{Symbol => OpenStruct}] A hash of the known roles.
    #
    def roles
      @roles ||= {}
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
    # Returns an array of known pages.
    #
    # @return [Array] An array of known pages.
    #
    def pages
      @pages ||= {}
    end

    ##
    # Returns a hash of the known sessions.
    #
    # @return [Hash{String => String}] A hash of the known sessions.
    #
    def sessions
      @sessions ||= {}
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
    # Adds a new user role and creates a new session for the user.
    #
    #    Huzzah.add_role :admin
    #
    def add_role(role_name)
      name = role_name.to_sym
      raise Huzzah::RoleAlreadyDefinedError, "#{name}" if sessions.has_key? name
      sessions[name] = Huzzah::Session.new
      @current_role = name
      @current_session = sessions[name]
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
    # Clears all existing sessions, sites, apps & pages
    #
    #    Huzzah.reset!
    #
    def reset!
      @sessions = {}
      @sites = {}
      @apps = []
      @pages = {}
      @flows = {}
      @roles = {}
    end

    ##
    # Creates a new session for the current user.
    #     Huzzah.reset_current_session!
    #
    #
    def reset_current_session!
      @current_session.quit
      sessions[@current_role] = Huzzah::Session.new
      @current_session = sessions[@current_role]
    end


  end
end
