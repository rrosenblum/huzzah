require 'forwardable'

module Huzzah
  class Page
    extend Forwardable

    attr_accessor :role_data, :browser

    def initialize(role_data, browser)
      @role_data = role_data
      @browser = browser
    end

    ##
    # Waits up to 30 seconds for AJAX calls to complete.
    # Currently only works with jQuery.
    #
    def wait_for_ajax
      wait_until { execute_script('return jQuery.active').eql? 0 }
    end

    class << self

      ##
      # Defines a method with the given name that return a page element.
      #
      #   locator(:method_name) { block }
      #   locator(:login)  { button(id: 'login') }
      #
      def locator(method_name, &block)
        validate_method_name method_name

        define_method method_name.to_s do |*args|
          instance_exec(*args, &block)
        end
      end

      ##
      # Defines a method with the given name that returns an instance of
      # a partial page class.
      #
      #    partial :partial_name, Partial::Class
      #    partial :header, Google::Header
      #
      def partial(method_name, partial_class)
        validate_method_name method_name, false

        define_method method_name.to_s do
          partial = partial_class.new @role_data, @browser
          partial.instance_eval(&block) if block_given?
          partial
        end
      end

      ##
      # Returns an array of method names that have been created by the
      # let and partial methods.
      #
      def defined_methods
        @defined_methods ||= []
      end

      ##
      # Prevents duplicate dynamically defined methods.
      #
      def validate_method_name(name, restrict = true)
        if defined_methods.include? name
          fail Huzzah::DuplicateLocatorMethodError, name
        elsif restrict && Watir::Container.instance_methods.include?(name)
          fail Huzzah::RestrictedMethodNameError,
               %(You cannot use method names like '#{name}' from
                 the Watir::Container module in 'locator' statements)
        else
          defined_methods << name
        end
      end

    end

    ##
    # Handles calls to methods in the Watir::Browser class so you do not have
    # browser.method calls in your page object.
    #
    # For example you can just say:
    #    text_field(id: 'username')
    #        rather than
    #    browser.text_field(id: 'username')
    #
    def method_missing(method_name, *args, &block)
      if @browser.methods.include? method_name
        @browser.send method_name, *args, &block
      else
        fail Huzzah::NoMethodError,
             "Method '#{method_name}' undefined in #{self.class}"
      end
    end

    def_delegators :browser, :add_checker
    def_delegators :browser, :alert
    def_delegators :browser, :back
    def_delegators :browser, :cookies
    def_delegators :browser, :disable_checker
    def_delegators :browser, :execute_script
    def_delegators :browser, :exist?
    def_delegators :browser, :forward
    def_delegators :browser, :goto
    def_delegators :browser, :html
    def_delegators :browser, :name
    def_delegators :browser, :ready_state
    def_delegators :browser, :refresh
    def_delegators :browser, :run_checkers
    def_delegators :browser, :screenshot
    def_delegators :browser, :send_keys
    def_delegators :browser, :status
    def_delegators :browser, :text
    def_delegators :browser, :title
    def_delegators :browser, :without_checkers
    def_delegators :browser, :confirm
    def_delegators :browser, :prompt
    def_delegators :browser, :window
    def_delegators :browser, :windows
    def_delegators :browser, :p
    def_delegators :browser, :wait_while
    def_delegators :browser, :wait_until

  end
end
