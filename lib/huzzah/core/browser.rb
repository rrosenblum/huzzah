module Huzzah
  module Browser
    attr_accessor :browser, :driver

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
      @driver = @role_data.key?(:driver) ? @role_data[:driver] : Huzzah.default_driver
      fail Huzzah::DriverNotDefinedError, "Driver '#{@driver}' is not defined." unless Huzzah.drivers.key?(@driver)
      @browser ||= Huzzah.drivers[@driver].call
    end

  end
end
