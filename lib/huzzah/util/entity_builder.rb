# :nodoc:
module Huzzah
  module EntityBuilder
    include FileLoader

    # :nodoc:
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
          sites[__method__.to_sym].instance_eval(&block) if block_given?
          sites[__method__.to_sym]
        end
      end
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
        define_singleton_method(subclass.to_s.demodulize.underscore.to_sym) do |&block|
          page = subclass.new(@role_data, @browser)
          page.instance_eval(&block) if block_given?
          page
        end
      end
    end

  end
end
