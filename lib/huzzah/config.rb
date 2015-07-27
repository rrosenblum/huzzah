module Huzzah
  class Config

    attr_accessor :path, :environment, :browser_type
    attr_accessor :grid_url, :remote, :capabilities

    ##
    # Initializes the configuration and autoloads all sites, apps,
    # partials, pages, flows, models and factories.
    #
    def initialize
      @remote = false
      yield self
    end

    ##
    # Returns the current Selenium Grid configuration.
    #
    # @return [Hash] The current Selenium Grid configuration.
    #
    def grid
      { :url => @grid_url, :desired_capabilities => @capabilities }
    end

    ##
    # Sets the desired capabilities for the Chrome browser. Used when running
    # tests remotely on the Selenium Grid.
    #
    def chrome(options = {})
      @capabilities = Selenium::WebDriver::Remote::Capabilities.chrome options
      @remote = true
    end

    ##
    # Sets the desired capabilities for the Firefox browser. Used when running
    # tests remotely on the Selenium Grid.
    #
    def firefox(options = {})
      @capabilities = Selenium::WebDriver::Remote::Capabilities.firefox options
      @remote = true
    end

    ##
    # Sets the desired capabilities for the Internet Explorer browser. Used when running
    # tests remotely on the Selenium Grid.
    #
    def internet_explorer(options = {})
      @capabilities = Selenium::WebDriver::Remote::Capabilities.internet_explorer options
      @remote = true
    end

    ##
    # Returns the current configuration.
    #
    # @return [Hash] The current configuration.
    def inspect
      { path: @path, environment: @environment, browser_type: @browser_type,
        grid_url: @grid_url, remote: @remote, capabilities: @capabilities }
    end

  end
end