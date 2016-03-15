# :nodoc:
module Huzzah
  module PageBuilder

    private

    def define_page_methods!
      Huzzah::Page.subclasses.each do |subclass|
        next unless subclass.parent.to_s.underscore.to_sym.eql?(@site_name)
        define_singleton_method(subclass.to_s.demodulize.underscore.to_sym) do |&block|
          return_page(subclass, &block)
        end
      end
    end

    def return_page(subclass, &block)
      page = subclass.new(@role_data, @browser)
      page.instance_eval(&block) if block_given?
      page
    end

  end
end
