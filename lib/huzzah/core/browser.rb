module Huzzah
  module Browser
    attr_accessor :browser, :driver

    ##
    # Waits up to 30 seconds for AJAX calls to complete.
    # Currently only works with jQuery.
    #
    def wait_for_ajax
      wait_until { execute_script('return jQuery.active').eql? 0 }
    end

    private

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
      return @browser.send(method_name, *args, &block) if @browser.respond_to?(method_name, false)
      super
    end

    ##
    # Launches a browser for the role. It uses the default driver
    # unless a driver is specified in the role's YAML file.
    #
    def launch_browser
      if @role_data.key? :driver
        @driver = @role_data[:driver]
      else
        @driver = Huzzah.default_driver
      end
      unless Huzzah.drivers.key? @driver
        fail Huzzah::DriverNotDefinedError,
             "Driver '#{@driver}' is not defined."
      end
      @browser ||= Huzzah.drivers[@driver].call
    end

    def browser_closed?
      @browser.instance_variable_get('@closed')
    end

    def reset_browser
      @browser = nil
    end

  end
end