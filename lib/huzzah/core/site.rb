module Huzzah
  class Site < Huzzah::Base
    include FileLoader
    include PageBuilder

    attr_reader :site_name, :config

    def initialize(site_name)
      @site_name = site_name
      @config = load_config("#{Huzzah.path}/sites/#{@site_name}.yml")
      define_page_methods!
    end

    ##
    # Dynamically switches the page. The 'page' argument can be either
    # a Symbol or a String. Mainly intended to be used with Cucumber.
    #
    # @role.google.on(:home_page)
    # @role.google.on('home_page')
    #
    def on(page)
      unless page.is_a?(Symbol) || page.is_a?(String)
        fail TypeError, 'You must pass a Symbol or String to the #on method'
      end
      send(page)
    end

    ##
    # Handles initial navigation to the site. The site must have a YAML config
    # file with a 'url' key defined.
    #
    # @role.google.visit
    #
    def visit
      return if @config[:url].nil?
      @browser.goto(@config[:url])
    end

  end
end
