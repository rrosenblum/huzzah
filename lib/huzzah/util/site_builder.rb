# :nodoc:
module Huzzah
  module SiteBuilder

    private

    def sites
      @sites ||= {}
    end

    def site_names
      Huzzah::Page.subclasses.map(&:parent).uniq
    end

    def define_sites!
      site_names.each do |site|
        site_name = site.to_s.underscore.to_sym
        sites[site_name] = Huzzah::Site.new(site_name, @role_data, @browser)
      end
    end

    def generate_site_methods!
      define_sites!
      sites.each_key do |site|
        define_singleton_method(site) { |&block| return_site(__method__.to_sym, &block) }
      end
    end

    def return_site(site_name, &block)
      sites[site_name].instance_eval(&block) if block_given?
      sites[site_name]
    end

  end
end
