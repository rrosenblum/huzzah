module Huzzah
  module Loader

    ##
    # Auto loads all required and optional entities.
    #
    def load_all_entities
      load_roles
      load_sites
      load_apps
      load_partials
      load_pages
      load_flows
      load_models
      load_factories
    end

    private

    ##
    # Path to application model.
    #
    def path
      Huzzah.configuration[:path]
    end

    ##
    # Loads all Sites.
    #
    def load_sites
      Dir["#{path}/sites/*.yml"].each do |file|
        name = File.basename(file, '.yml').to_sym
        Huzzah.add_site name, file
      end
    end

    ##
    # Loads all Roles. Optional.
    #
    def load_roles
      if Dir.exists?("#{path}/roles")
        Dir["#{path}/roles/*.yml"].each do |file|
          name = File.basename(file, '.yml').to_sym
          Huzzah.add_role name, file
        end
      end
    end

    ##
    # Loads all Apps.
    #
    def load_apps
      Dir.entries("#{path}/apps/").select do |entry|
        if File.directory? File.join("#{path}/apps/",entry) and !(entry =='.' || entry == '..')
          Huzzah.add_app entry
        end
      end
    end

    ##
    # Loads all Partial Pages.
    #
    def load_partials
      Huzzah.apps.each do |app_name|
        Dir["#{path}/apps/#{app_name}/partials/*.rb"].each do |file|
          page_name = "#{app_name.camelize}::#{File.basename(file, '.rb').camelize}"
          Huzzah.add_page page_name, file
        end
      end
    end

    ##
    # Loads all Pages.
    #
    def load_pages
      Huzzah.apps.each do |app_name|
        Dir["#{path}/apps/#{app_name}/pages/*.rb"].each do |file|
          page_name = "#{app_name.camelize}::#{File.basename(file, '.rb').camelize}"
          Huzzah.add_page page_name, file
        end
      end
    end

    ##
    # Loads all Flows. Optional.
    #
    def load_flows
      if Dir.exists?("#{path}/flows")
        Dir["#{path}/flows/*.rb"].each do |file|
          name = File.basename(file, '.rb').to_s
          Huzzah.add_flow name, file
        end
      end
    end

    ##
    # Loads all Models. Optional.
    #
    def load_models
      if Dir.exists?("#{path}/models")
        Dir["#{path}/models/*.rb"].each { |file| require file }
      end
    end

    ##
    # Loads all Factories. Optional.
    #
    def load_factories
      if Dir.exists?("#{path}/factories")
        Dir["#{path}/factories/*.rb"].each { |file| require file }
      end
    end

  end
end