# :nodoc:
module Huzzah
  module EntityBuilder
    include FileLoader

    def generate_dsl_methods!
      load_files!
      generate_site_methods!
      generate_flow_methods!
    end

    private

    def sites
      @sites ||= {}
    end

    def define_sites!
      Huzzah::Page.subclasses.map(&:parent).uniq.each do |site|
        site_name = site.to_s.underscore.to_sym
        sites[site_name] = Huzzah::Site.new(site_name, @role_data, @browser)
      end
    end

    def generate_site_methods!
      define_sites!
      sites.each_key do |site|
        define_singleton_method(site) do |&block|
          return_site(__method__.to_sym, &block)
        end
      end
    end

    def return_site(site_name, &block)
      site = @sites[site_name]
      site.instance_eval(&block) if block_given?
      site
    end

    def generate_flow_methods!
      Huzzah::Flow.subclasses.each do |subclass|
        define_singleton_method(subclass.to_s.demodulize.underscore) do
          subclass.new(@role_data, @browser)
        end
      end
    end

    def generate_page_methods!
      Huzzah::Page.subclasses.each do |subclass|
        next unless subclass.parent.to_s.underscore.to_sym.eql?(@site_name)
        site_name = subclass.to_s.demodulize.underscore.to_sym
        define_singleton_method(site_name) do |&block|
          return_page(subclass, &block)
        end
      end
    end

    def return_page(subclass, &block)
      page = subclass.new
      page.role_data = @role_data
      page.browser = @browser
      page.instance_eval(&block) if block_given?
      page
    end
  end
end
