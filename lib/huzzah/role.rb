module Huzzah
  class Role

    include Huzzah::DynamicMethodHelper

    attr_accessor :role_data, :driver, :browser, :sites

    def initialize(name = nil, *args)
      @role_data = ActiveSupport::HashWithIndifferentAccess.new
      @sites = ActiveSupport::HashWithIndifferentAccess.new
      load_role_data name, args
      define_sites
      launch_browser
    end

    ##
    # Dynamically switches the site. The 'site' argument can be either
    # a Symbol or a String.
    #
    # @role.on(:google)
    # @role.on('google')
    #
    def on(site)
      send(site)
    end


    private

    ##
    # Merge and freeze role data from YAML and custom Hash argument
    #
    def load_role_data(name, args = nil)
      load_role_yaml name if name
      merge_role_args args unless args.empty?
      @role_data.freeze
    end

    ##
    # Load YAML file for role if it exists. Warn user if YAML file
    # does not exist. There is no need to pass a role name if there
    # is no corresponding YAML file.
    #
    def load_role_yaml(name)
      name = name.to_s
      file = "#{Huzzah.path}/roles/#{name}.yml"
      if File.exists?(file)
        env = Huzzah.environment
        raw_data = YAML.load_file(file)[env]
        @role_data = Hash[raw_data.map { |k, v| [k.to_sym, v] }]
      else
        warn "No YAML file found for role '#{name}'"
      end
    end

    ##
    # Merge role data from the custom Hash with the data from
    # the YAML file. Any data from the custom Hash overrides data
    # from the YAML file.
    def merge_role_args(args)
      unless args.first.is_a? Hash
        fail ArgumentError, "Expected a Hash, got #{args.first.class}"
      end
      @role_data.merge! args.first
    end

    ##
    # Define all sites based on the YAML files found under the
    # 'sites' directory. Site instances are maintained in a Hash
    # and a method is dynamically generated that passes the browser
    # to the site.
    #
    # When the site is initialized, the name of the site and the
    # role data is passed as arguments
    #
    def define_sites
      Dir["#{Huzzah.path}/sites/*.yml"].each do |config|
        name = File.basename(config, '.yml').to_sym
        validate_method_name name
        @sites[name] = Huzzah::Site.new config, @role_data
        self.class_eval do
          define_method(name) do
            site = @sites[__method__]
            site.browser = @browser
            site
          end
        end
      end
    end

    ##
    # Launches a browser for the role. It uses the default driver
    # unless a driver is specified in the role's YAML file.
    #
    def launch_browser
      if @role_data.key? :driver
        @driver = @role_data[:driver]
      else
        @driver = Huzzah.default_driver
      end
      unless Huzzah.drivers.key? @driver
        fail Huzzah::DriverNotDefinedError, "Driver '#{@driver}' is not defined."
      end
      @browser = Huzzah.drivers[@driver].call
    end

  end
end