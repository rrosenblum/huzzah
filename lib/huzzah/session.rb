module Huzzah
  class Session

    attr_accessor :browser, :site

    ##
    # Launches a new browser for the user (unless one already exists). If the
    # Huzzah.config.remote flag is set to true, it will launch a remote browser
    # on the Selenium Grid. Otherwise, the browser will be launched on your
    # local machine.
    #
    def start
      unless @browser
        if Huzzah.config.remote
          raise Huzzah::GridConfigNotDefinedError if Huzzah.config.grid_url.nil?
          @browser = Watir::Browser.new :remote, Huzzah.config.grid
        else
          raise Huzzah::BrowserTypeNotDefinedError if Huzzah.config.browser_type.nil?
          @browser = Watir::Browser.new Huzzah.config.browser_type
        end
      end
    end

    ##
    # Clears any open dialogs and browser cookies. It then navigates the
    # browser to 'about:blank' to give you a clean starting point. Use this
    # method when you do not want to close the browser between test scenarios.
    #
    def reset!
      if @browser
        @browser.alert.close if @browser.alert.exists?
        @browser.cookies.clear
        @browser.goto("about:blank")
      end
    end

    ##
    # Closes the browser.
    #
    def quit
      @browser.close unless @browser.nil?
    end


  end
end


