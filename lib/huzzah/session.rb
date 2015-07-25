module Huzzah
  class Session

    attr_accessor :driver, :driver_type, :site, :site_data

    def initialize(driver_type=:web)
      @driver_type = driver_type
    end

    def load_site(name, navigate=false)
      @site = name
      @site_data = Huzzah.sites[@site]
      if navigate and @driver_type.eql? :web
        @driver.goto site_data.url
      end
    end

    ##
    # Launches a new browser for the user (unless one already exists). If the
    # Huzzah.config.remote flag is set to true, it will launch a remote browser
    # on the Selenium Grid. Otherwise, the browser will be launched on your
    # local machine.
    #
    def start
      unless @driver
        if @driver_type.eql? :web
          remote ? start_watir_remotely : start_watir_locally
        else
          start_appium_locally
        end
      end
    end

    ##
    # Clears any open dialogs and browser cookies. It then navigates the
    # browser to 'about:blank' to give you a clean starting point. Use this
    # method when you do not want to close the browser between test scenarios.
    #
    def reset!
      if @driver.is_a? Watir::Browser
        @driver.alert.close if @driver.alert.exists?
        @driver.cookies.clear
        @driver.goto("about:blank")
      end
    end

    ##
    # Closes the browser (web) or kills the mobile driver (appium).
    #
    def quit
      unless @driver.nil?
        if @driver.is_a? Watir::Browser
          @driver.close
        else
          @driver.driver_quit
        end
      end
      @driver = nil
    end

    private

    def remote
      Huzzah.config.remote
    end

    def grid_url
      Huzzah.config.grid_url
    end

    def browser_type
      Huzzah.config.browser_type
    end

    def capabilities
      Huzzah.config.capabilities
    end

    def mobile_capabilities
      Huzzah.config.mobile_capabilities
    end

    def start_watir_locally
      fail Huzzah::BrowserTypeNotDefinedError if browser_type.nil?
      @driver = Watir::Browser.new Huzzah.config.browser_type
    end

    def start_watir_remotely
      fail Huzzah::GridConfigNotDefinedError if grid_url.nil?
      @driver = Watir::Browser.new :remote, Huzzah.config.grid
    end

    def start_appium_locally
      $driver = Appium::Driver.new mobile_capabilities
      $driver.start_driver
      @driver = $driver
    end

  end
end


