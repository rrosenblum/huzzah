module Huzzah
  class Role
    include FileLoader
    include SiteBuilder

    attr_accessor :role_data, :driver, :browser

    def initialize(name = nil, *args)
      @role_data = ActiveSupport::HashWithIndifferentAccess.new
      load_role_data name, args
      load_files!
      generate_site_methods(@role_data)
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

  end
end