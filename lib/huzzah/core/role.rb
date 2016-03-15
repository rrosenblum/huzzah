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
    # a Symbol or a String. Mainly intended to be used with Cucumber.
    #
    # @role.on(:google)
    # @role.on('google')
    #
    def on(site)
      fail TypeError, 'Argument must be a Symbol or a String' unless site.is_a?(Symbol) || site.is_a?(String)
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
    # Merge and freeze role data from YAML and optional Hash arguments.
    #
    def load_role_data(name, args)
      args, name = name, nil if name.is_a?(Hash)
      @role_data = load_config("#{Huzzah.path}/roles/#{name}.yml")
      warn "No role data found for '#{name}'" if name && @role_data.empty?
      fail ArgumentError, "Expected a Hash, got #{args.class}" unless args.is_a?(Hash)
      role_data.merge!(args).freeze
    end
    
  end
end
