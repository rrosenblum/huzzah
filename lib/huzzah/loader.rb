module Huzzah
  module Loader

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

    def path
      Huzzah.configuration[:path]
    end

    def load_sites
      Dir["#{path}/sites/*.yml"].each do |file|
        name = File.basename(file, '.yml').to_sym
        Huzzah.add_site name, file
      end
    end

    def load_roles
      if Dir.exists?("#{path}/roles")
        Dir["#{path}/roles/*.yml"].each do |file|
          name = File.basename(file, '.yml').to_sym
          Huzzah.add_role name, file
        end
      end
    end

    def load_apps
      Dir.entries("#{path}/apps/").select do |entry|
        if File.directory? File.join("#{path}/apps/",entry) and !(entry =='.' || entry == '..')
          Huzzah.add_app entry
        end
      end
    end

    def load_partials
      Huzzah.apps.each do |app_name|
        Dir["#{path}/apps/#{app_name}/partials/*.rb"].each do |file|
          page_name = "#{app_name.camelize}::#{File.basename(file, '.rb').camelize}"
          Huzzah.add_page page_name, file
        end
      end
    end

    def load_pages
      Huzzah.apps.each do |app_name|
        Dir["#{path}/apps/#{app_name}/pages/*.rb"].each do |file|
          page_name = "#{app_name.camelize}::#{File.basename(file, '.rb').camelize}"
          Huzzah.add_page page_name, file
        end
      end
    end

    def load_flows
      Dir["#{path}/flows/*.rb"].each do |file|
        name = File.basename(file, '.rb').to_s
        Huzzah.add_flow name, file
      end
    end

    def load_models
      if Dir.exists?("#{path}/models")
        Dir["#{path}/models/*.rb"].each { |file| require file }
      end
    end

    def load_factories
      if Dir.exists?("#{path}/factories")
        Dir["#{path}/factories/*.rb"].each { |file| require file }
      end
    end

  end
end