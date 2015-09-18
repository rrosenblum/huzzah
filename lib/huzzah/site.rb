module Huzzah
  class Site
    include PageBuilder

    attr_reader :site_name, :config, :role_data, :browser

    def initialize(role_data, browser)
      @role_data = role_data
      @browser = browser
      @site_name = self.class.name.demodulize.to_sym
      @config = load_site_yaml
      generate_page_methods!(role_data, browser)
      visit
    end

    def visit
      @browser.goto(config[:url]) if @config
    end

    private

    ##
    # Loads the site's config data for the environment variable set
    # in Huzzah.environment.
    #
    def load_site_yaml
      file = "#{Huzzah.path}/sites/#{@site_name}.yml"
      return YAML.load_file(file)[Huzzah.environment].with_indifferent_access if File.exists?(file)
      nil
    end

  end
end