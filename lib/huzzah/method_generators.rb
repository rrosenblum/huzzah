module Huzzah
  module MethodGenerators

    def generate_app_method(name)
      validate_method_name name
      Huzzah::DSL.class_eval do
        define_method(name) do |*args, &block|
          if Huzzah.active_role.session.driver.nil?
            fail Huzzah::SiteNotVisitedError
          end
          module_name = "#{__method__.to_s.camelize}"
          page_name = "#{args.first.to_s.camelize}"
          page_class = "#{module_name}::#{page_name}"
          unless Huzzah.pages.has_key? page_class
            fail Huzzah::UnknownPageError, page_class
          end
          on page_class, &block
        end
      end
    end

    def generate_role_method(name)
      validate_method_name name
      Huzzah::DSL.class_eval do
        define_method(name) do
          Huzzah.roles[__method__]
        end
      end
    end

    def generate_flow_method(name)
      validate_method_name name
      Huzzah::DSL.class_eval do
        define_method(name) do
          Huzzah.flows[name.to_s]
        end
      end
    end

    def defined_methods
      @defined_methods ||= []
    end

    def reset_defined_methods
      @defined_methods = []
    end

    private

    def validate_method_name(name)
      if defined_methods.include? name.to_sym
        fail Huzzah::DuplicateMethodNameError,
             "#{name} is already defined!"
      else
        defined_methods << name
      end
    end

  end
end