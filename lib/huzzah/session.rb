module Huzzah
  class Session

    attr_accessor :driver, :driver_type, :site, :site_data

    ##
    # Create a new Session and default the driver type to
    # :web (in preparation for mobile support)
    #
    def initialize(driver_type = :web)
      @driver_type = driver_type
    end

    ##
    # Launches a new browser for the user (unless one already exists). If the
    # Huzzah.config.remote flag is set to true, it will launch a remote browser
    # on the Selenium Grid. Otherwise, the browser will be launched on your
    # local machine.
    #
    def start
      return if @driver
      remote ? start_watir_remotely : start_watir_locally
    end

    ##
    # Loads the Site information. If navigate is true, it will url for the
    # environment specified in Huzzah::Config.environment.
    #
    def load_site(name, navigate = false)
      @site = name
      @site_data = Huzzah.sites[@site.to_sym]
      return unless @driver_type.eql? :web
      @driver.goto site_data.url if navigate
    end

    ##
    # Clears any open dialogs and browser cookies. It then navigates the
    # browser to 'about:blank' to give you a clean starting point. Use this
    # method when you do not want to close the browser between test scenarios.
    #
    def reset!
      fail unless @driver.is_a? Watir::Browser
      @driver.alert.close if @driver.alert.exists?
      @driver.cookies.clear
      @driver.goto 'about:blank'
    end

    ##
    # Closes the browser.
    #
    def quit
      @driver.close unless @driver.nil?
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

    # def capabilities
    #   Huzzah.config.capabilities
    # end

    def start_watir_locally
      fail Huzzah::BrowserTypeNotDefinedError if browser_type.nil?
      @driver = Watir::Browser.new Huzzah.config.browser_type
    end

    def start_watir_remotely
      fail Huzzah::GridConfigNotDefinedError if grid_url.nil?
      @driver = Watir::Browser.new :remote, Huzzah.config.grid
    end

  end
end
