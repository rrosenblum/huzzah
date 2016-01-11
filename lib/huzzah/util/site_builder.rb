module Huzzah
  module SiteBuilder

    private

    def site_names
      Huzzah::Page.subclasses.map(&:parent).uniq
    end

    def define_sites!
      @sites ||= {}
      site_names.each do |site|
        site_name = site.to_s.underscore.to_sym
        @sites[site_name] = Huzzah::Site.new(site_name)
      end
    end

    def generate_site_methods!
      define_sites!
      @sites.each_key do |site|
        define_singleton_method(site) do |&block|
          return_site(__method__.to_sym, &block)
        end
      end
    end

    def return_site(site_name, &block)
      site = @sites[site_name]
      site.role_data = @role_data
      site.browser = @browser
      site.instance_eval(&block) if block_given?
      site
    end

  end
end
