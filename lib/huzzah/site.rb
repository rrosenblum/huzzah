module Huzzah
  class Site
    include PageBuilder

    attr_accessor :site_name, :config, :role_data, :browser

    def initialize(site_name, role_data)
      @site_name = site_name
      @role_data  = role_data
      load_site_yaml site_name
      generate_page_methods
    end

    def visit
      @browser.goto config[:url] if @config
    end


    private

    ##
    # Loads the site's config data for the environment variable set
    # in Huzzah.environment.
    #
    def load_site_yaml(site_name)
      name = site_name.to_s.underscore
      file = "#{Huzzah.path}/sites/#{name}.yml"
      if File.exists?(file)
        env = Huzzah.environment
        raw_data = YAML.load_file(file)[env].symbolize_keys
        @config = Hash[raw_data.map { |k, v| [k.to_sym, v] }]
      else
        @config = nil
      end
    end

  end
end