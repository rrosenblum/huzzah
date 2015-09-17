module Huzzah
  class Page
    extend PartialLoader
    extend Locator
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