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
      unless page.is_a? Symbol or page.is_a? String
        fail TypeError, 'You must pass a Symbol or String to the #on method'
      end
      send(page)
    end

    def visit
      if @browser.url.eql? 'about:blank' and !@config[:url].nil?
        @browser.goto(@config[:url])
      end
    end

  end
end