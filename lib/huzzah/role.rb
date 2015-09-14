module Huzzah
  class Role
    include FileLoader
    include SiteLoader
    attr_reader :role_data

    def initialize(role = nil)
      @role_data = load_yaml("#{Huzzah.config_path}/roles/#{role.to_s}.yml").with_indifferent_access.freeze
      load_files!
      add_sites!
    end

  end
end