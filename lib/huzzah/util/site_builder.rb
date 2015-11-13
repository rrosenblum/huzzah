module Huzzah
  module SiteBuilder
    include Browser

    private

    def define_sites!
      get_site_names.each do |site|
        next if site_defined?(site)
        site.deconstantize.constantize.const_set(site.demodulize, Class.new(Huzzah::Site))
      end
    end

    def get_site_names
      Huzzah::Page.subclasses.map(&:to_s).map(&:deconstantize).flat_map { |m| "#{m}::#{m}" }.uniq
    end

    def site_defined?(site)
      return true if site.constantize rescue NameError
      false
    end

    def generate_site_methods!(role_data)
      define_sites!
      @sites ||= {}
      Huzzah::Site.subclasses.each do |site|
        define_singleton_method(site.to_s.demodulize.underscore.to_sym) do
          return @sites[site] unless @sites[site].nil? or browser_closed?
          begin
            @sites[site] = site.new(role_data, launch_browser)
          rescue Errno::ECONNREFUSED
            reset_browser
            @sites = {}
            retry
          end
        end
      end
    end

  end
end