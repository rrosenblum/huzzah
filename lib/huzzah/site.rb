module Huzzah
  class Site
    extend Huzzah::SiteLoader

    def self.inherited(site)
      add_to_role(site)
    end

  end
end