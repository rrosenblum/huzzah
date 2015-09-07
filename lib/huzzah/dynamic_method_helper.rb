module Huzzah
  module DynamicMethodHelper

    ##
    # Validates that a dynamically defined method has
    # not been generated with the same name.
    #
    def validate_method_name(name)
      if dynamically_defined_methods.include? name
        fail Huzzah::DuplicateMethodNameError,
             "#{name} is already defined."
      else
        dynamically_defined_methods << name
      end
    end

    ##
    # List of dynamically defined methods
    #
    def dynamically_defined_methods
      @dynamically_defined_methods ||= []
    end

  end
end