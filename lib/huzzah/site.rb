module Huzzah
  class Site

    include Huzzah::DynamicMethodHelper

    attr_accessor :site_name, :config, :role_data, :browser

    def initialize(config, role_data)
      @site_name = File.basename config, '.yml'
      load_site_yaml config
      @role_data  = role_data
      define_pages
    end

    def visit
      @browser.goto config[:url]
    end

    private

    ##
    # Loads the site's config data for the environment variable set
    # in Huzzah.environment.
    #
    def load_site_yaml(config)
      env = Huzzah.environment
      @config = YAML.load_file(config)[env].symbolize_keys
    end

    def define_pages
      Dir["#{Huzzah.path}/pages/#{@site_name}/*.rb"].each do |file|
        require file
        page_name = File.basename(file, '.rb')
        validate_method_name page_name
        site_module = @site_name.camelize
        page_class = page_name.camelize
        self.class_eval do
          define_method(page_name) do
            "#{site_module}::#{page_class}".constantize.new @role_data, @browser
          end
        end
      end
    end

  end
end