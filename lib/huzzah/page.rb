require 'forwardable'

module Huzzah
  class Page
    extend Forwardable

    attr_accessor :browser


    def framed_element(type, locator)
      find_element_in_all_frames browser, type, locator
    end

    ##
    # Checks to see if the current page contains the given text.
    #
    # @return [Boolean]
    #
    def has_text?(text)
      browser.text.include? text
    end
    alias_method :page_has_text?, :has_text?

    ##
    # Waits up to 30 seconds for AJAX calls to complete.
    # Currently only works with jQuery.
    #
    def wait_for_ajax
      browser.wait_until { browser.execute_script("return jQuery.active") == 0 }
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
          self.instance_exec *args, &block
        end
      end
      alias_method :let, :locator

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
          if Huzzah.pages[partial_class.to_s].nil?
            Huzzah.pages[partial_class.to_s] = partial_class.new
          end
          partial = Huzzah.pages[partial_class.to_s]
          partial.browser = Huzzah.active_role.session.driver
          partial.instance_eval(&block) if block_given?
          partial
        end
      end

      ##
      # Returns an array of method names that have been created by the
      # let and partial methods.
      #
      def defined_methods
        @defined_methods ||= Array.new
      end

      ##
      # Prevents duplicate dynamically defined methods.
      #
      def validate_method_name(name, restrict=true)
        if defined_methods.include? name
          fail Huzzah::DuplicateElementMethodError, name
        elsif restrict and Watir::Container.instance_methods.include? name
          fail Huzzah::RestrictedMethodNameError,
               "You cannot use method names like '#{name}' from the Watir::Container module in 'let' statements"
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
      fail Huzzah::BrowserNotInitializedError if @browser.nil?

      if method_name.to_s.start_with? '_'
        warn "DEPRECATION WARNING: You no longer nee to proceed locator methods with an underscore. Just call #{method_name.to_s[1..-1]} instead of #{method_name}"
        find_element_in_all_frames(@browser, method_name[1..-1].to_sym, *args, &block)
      elsif @browser.methods.include? method_name
        find_element_in_all_frames(@browser, method_name.to_sym, *args, &block)
      else
        fail Huzzah::NoMethodError, "Method '#{method_name}' undefined in #{self.class}"
      end
    end

    ##
    # Recursively searches all frames and iframes on the page for your object.
    #
    def find_element_in_all_frames(browser, method_name, args, &block)
      begin
        element = browser.send(method_name, args, &block)
        return element if element.exists? # Single Elements
      rescue
        return element unless element.nil? # Element Collections
      end

      if browser.frames.size > 0
        browser.frames.each do |frame|
          result = find_element_in_all_frames(frame, method_name, args, &block)
          return result if result
        end
      end

      if browser.iframes.size > 0
        browser.iframes.each do |frame|
          result = find_element_in_all_frames(frame, method_name, args, &block)
          return result if result
        end
      end
      element
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

  end
end