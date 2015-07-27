module Huzzah
  module MethodGenerators

    ##
    # Adds a method to the Huzzah::DSL for each
    # app directory. The method name is based on
    # the directory name. The defined method takes
    # a single argument (the page name) as a String
    # or Symbol.
    #
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

    ##
    # Adds a method to the Huzzah::DSL for each defined Role.
    # Roles can be defined in yml files or by calling the Huzzah.add_role
    # or Huzzah.add_roles methods.
    def generate_role_method(name)
      validate_method_name name
      Huzzah::DSL.class_eval do
        define_method(name) do
          Huzzah.roles[__method__]
        end
      end
    end

    ##
    # Adds a method to the Huzzah::DSL for each defined Flow.
    # The method name is based off of the file name (minus the .rb)
    # and takes no arguments.
    #
    def generate_flow_method(name)
      validate_method_name name
      Huzzah::DSL.class_eval do
        define_method(name) do
          Huzzah.flows[name.to_s]
        end
      end
    end

    ##
    # Array of all methods that have been dynamically
    # defined in the Huzzah::DSL.
    #
    def defined_methods
      @defined_methods ||= []
    end

    ##
    # Clears out all defined methods.
    #
    def reset_defined_methods
      @defined_methods = []
    end


    private

    ##
    # Ensures that there is no duplication of
    # dynamically defined Huzzah::DSL methods.
    #
    def validate_method_name(name)
      if defined_methods.include? name.to_sym
        fail Huzzah::DuplicateMethodNameError,
             "'#{name}' is already defined!"
      else
        defined_methods << name
      end
    end

  end
end