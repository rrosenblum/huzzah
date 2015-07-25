module Huzzah
  class MobilePage

    include Huzzah::DSL::Mobile
    include Huzzah::DSL::Shared

    ##
    # Select the specified value from the select list
    #
    def select(value, list)
      select_list = Selenium::WebDriver::Support::Select.new list
      select_list.select_by :text, value
    end

    ##
    # Defines a method with the given name that return a page element, act upon
    # a page element or perform some other action.
    #
    #   let(:method_name) { block }
    #
    def self.let(method_name, &block)
      validate_method_name method_name

      define_method method_name.to_s do |*args|
        self.instance_exec *args, &block
      end
    end

    ##
    # Defines a method with the given name that returns an instance of
    # a partial page class.
    #
    #    partial :partial_name, Partial::Class
    #    partial :header, Google::Header
    #
    def self.partial(method_name, partial_class)
      validate_method_name method_name

      define_method method_name.to_s do
        if Huzzah.pages[partial_class.to_s].nil?
          Huzzah.pages[partial_class.to_s] = partial_class.new
        end
        partial = Huzzah.pages[partial_class.to_s]
        partial.instance_eval(&block) if block_given?
        partial
      end
    end

    class << self

      ##
      # Returns an array of method names that have been created by the
      # let and partial methods.
      #
      def defined_methods
        @defined_methods ||= Array.new
      end

      ##
      # Ensures that the let and partial methods do not attempt to create
      # duplicate methods.
      #
      def validate_method_name(name)
        if defined_methods.include? name
          raise Huzzah::DuplicateElementMethodError, name
        end
        defined_methods << name
      end

    end

    def method_missing(method_name, *args, &block)
      fail Huzzah::DriverNotInitializedError if $driver.nil?
      if Appium.respond_to? method_name
        Appium.send method_name, *args, &block
      else
        fail Huzzah::NoMethodError, "#{method_name} undefined in #{self.class}"
      end

    end

  end
end