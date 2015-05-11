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

    ##
    # Defines a method with the given name that return a page element, act upon
    # a page element or perform some other action.
    #
    #   let(:method_name) { block }
    #   let(:login) { button(id: 'login').click }
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
    #    partial :header, Sapphire::Header
    #
    def self.partial(method_name, partial_class)
      validate_method_name method_name

      define_method method_name.to_s do
        partial = partial_class.new
        partial.browser = Huzzah.current_session.browser
        yield partial if block_given?
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
      raise Huzzah::BrowserNotInitializedError if @browser.nil?

      if method_name.to_s.start_with? '_'
        warn "DEPRECATION WARNING: You no longer nee to proceed locator methods with an underscore. Just call #{method_name.to_s[1..-1]} instead of #{method_name}"
        find_element_in_all_frames(@browser, method_name[1..-1].to_sym, *args, &block)
      elsif @browser.methods.include? method_name
        find_element_in_all_frames(@browser, method_name.to_sym, *args, &block)
      else
        raise Huzzah::NoMethodError, "#{method_name} undefined in #{self.class}"
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

    # Send #p methods call to the browser, not Kernel
    def_delegators :browser, :p

  end
end