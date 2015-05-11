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
      load_roles
      load_sites
      load_apps
      load_partials
      load_pages
      load_flows
      load_models
      load_factories
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
    end

    ##
    # Sets the desired capabilities for the Firefox browser. Used when running
    # tests remotely on the Selenium Grid.
    #
    def firefox(options = {})
      @capabilities = Selenium::WebDriver::Remote::Capabilities.firefox options
    end

    ##
    # Sets the desired capabilities for the Internet Explorer browser. Used when running
    # tests remotely on the Selenium Grid.
    #
    def internet_explorer(options = {})
      @capabilities = Selenium::WebDriver::Remote::Capabilities.internet_explorer options
    end

    ##
    # Returns the current configuration.
    #
    # @return [Hash] The current configuration.
    def inspect
      { path: @path, environment: @environment, browser_type: @browser_type,
        grid_url: @grid_url, remote: @remote, capabilities: @capabilities }
    end


    private

    def load_sites
      Dir["#{@path}/sites/*.yml"].each do |file|
        site_name = File.basename(file, '.yml').to_sym
        config = YAML::load_file file
        Huzzah.sites[site_name] = OpenStruct.new config[@environment]
      end
    end

    def load_roles
      if Dir.exists?("#{@path}/roles")
        Dir["#{@path}/roles/*.yml"].each do |file|
          role_name = File.basename(file, '.yml').to_sym
          role_config = YAML::load_file file

          Huzzah.add_role role_name
          Huzzah.roles[role_name] = OpenStruct.new role_config[@environment]

          Huzzah::DSL.class_eval do
            define_method(role_name) do
              Huzzah.roles[__method__]
            end
          end
        end
      end
    end

    def load_apps
      Dir.entries("#{@path}/apps/").select do |entry|
        if File.directory? File.join("#{path}/apps/",entry) and !(entry =='.' || entry == '..')
          Huzzah.apps << entry
        end
      end
      add_dsl_methods
    end

    def add_dsl_methods
      Huzzah.apps.each do |app_name|
        Huzzah::DSL.class_eval do
          define_method(app_name) do |*args, &block|
            raise Huzzah::SiteNotVisitedError if Huzzah.current_session.browser.nil?
            module_name = "#{__method__.to_s.camelize}"
            page_name = "#{args.first.to_s.camelize}"
            page_class = "#{module_name}::#{page_name}"
            raise Huzzah::UnknownPageError, page_class unless Huzzah.pages.has_key? page_class
            on page_class, &block
          end
        end
      end
    end

    def load_partials
      Huzzah.apps.each do |app_name|
        Dir["#{@path}/apps/#{app_name}/partials/*.rb"].each do |file|
          page_name = "#{app_name.camelize}::#{File.basename(file, '.rb').camelize}"
          add_page page_name, file
        end
      end
    end

    def load_pages
      Huzzah.apps.each do |app_name|
        Dir["#{@path}/apps/#{app_name}/pages/*.rb"].each do |file|
          page_name = "#{app_name.camelize}::#{File.basename(file, '.rb').camelize}"
          add_page page_name, file
        end
      end
    end

    def load_flows
      Dir["#{@path}/flows/*.rb"].each do |file|
        require file
        file_name = File.basename(file, '.rb').to_s
        if Huzzah.apps.include? file_name
          raise Huzzah::FlowNameError, "Flow #{file_name} conflicts with App #{file_name}"
        else
          Huzzah.flows[file_name.to_s] = file_name.camelize.constantize.new
        end
        Huzzah::DSL.class_eval do
          define_method(file_name) do
            Huzzah.flows[file_name.to_s]
          end
        end
      end
    end

    def load_models
      if Dir.exists?("#{@path}/models")
        Dir["#{@path}/models/*.rb"].each {|file| require file }
      end
    end

    def load_factories
      if Dir.exists?("#{@path}/factories")
        Dir["#{@path}/factories/*.rb"].each {|file| require file }
      end
    end

    private

    def add_page(page_name, file)
      raise Huzzah::PageNameError, "Duplicate page name: #{page_name}" if Huzzah.pages.has_key? page_name
      require file
      Huzzah.pages[page_name] = nil
    end


  end
end