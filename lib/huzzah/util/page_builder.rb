module Huzzah
  module PageBuilder

    private

    def define_page_methods!
      Huzzah::Page.subclasses.each do |subclass|
        parent = subclass.parent.to_s.underscore.to_sym
        page_name = subclass.to_s.demodulize.underscore.to_sym
        next unless parent.eql?(@site_name)
        define_singleton_method(page_name) do |&block|
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
