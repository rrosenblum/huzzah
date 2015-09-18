module Huzzah
  class Site
    include FileLoader
    include PageBuilder

    attr_reader :site_name, :config, :role_data, :browser

    def initialize(role_data, browser)
      @role_data = role_data
      @browser = browser
      @site_name = self.class.name.demodulize.to_sym
      @config = load_config("#{Huzzah.path}/sites/#{@site_name}.yml")
      generate_page_methods!(role_data, @browser)
      visit
    end

    def visit
      @browser.goto(config[:url]) if @config
    end

  end
end