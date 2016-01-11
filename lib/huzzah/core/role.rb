module Huzzah
  class Role < Huzzah::Base
    include DSL

    def initialize(name = nil, args = {})
      @role_data = load_role_data(name, args)
      generate_dsl_methods!
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
      unless site.is_a?(Symbol) || site.is_a?(String)
        fail TypeError, 'You must pass a Symbol or String to the #on method'
      end
      send(site)
    end

    ##
    # Handles initial navigation to a site. The 'site' argument can be either
    # a Symbol or a String.
    #
    # Returns self so that you can chain site navigation at Role instantiation:
    # Example:
    #   @role = Huzzah::Role.new(:google_user).visit(:google)
    #
    # @role.on(:google)
    # @role.on('google')
    #
    def visit(site)
      on(site).visit
      self
    end

    private

    ##
    # Merge and freeze role data from YAML and custom Hash argument
    #
    def load_role_data(name, args)
      if name.is_a?(Hash)
        args = name
        name = nil
      end
      @role_data = load_config("#{Huzzah.path}/roles/#{name}.yml")
      warn "No role data found for '#{name}'" if name and @role_data.empty?
      merge_role_args(role_data, args).freeze
    end

    ##
    # Merge role data from the custom Hash with the data from
    # the YAML file. Any data from the custom Hash overrides data
    # from the YAML file.
    def merge_role_args(role_data, args)
      unless args.is_a?(Hash)
        fail ArgumentError, "Expected a Hash, got #{args.first.class}"
      end
      role_data.merge!(args)
    end

  end
end
