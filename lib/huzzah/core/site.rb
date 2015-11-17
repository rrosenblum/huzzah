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

    def on(page)
      unless page.is_a?(Symbol) || page.is_a?(String)
        fail TypeError, 'You must pass a Symbol or String to the #on method'
      end
      send(page)
    end

    def visit
      return if @config[:url].nil?
      @browser.goto(@config[:url]) unless @browser.url.start_with?('http')
    end

  end
end
