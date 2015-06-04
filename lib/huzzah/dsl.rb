module Huzzah
  module DSL

    ##
    # Shortcut to get the browser for the current user session.
    #
    # @return [Watir::Browser] The browser instance for the current user session.
    #
    def browser
      Huzzah.current_session.browser
    end

    ##
    # Returns the name of the site that the current session is using.
    #
    # @return [String] The name of the site
    #
    def current_site
      Huzzah.current_session.site
    end

    ##
    # Returns the name of the current user role.
    #
    # @return [String] The current user role
    #
    def current_role
      Huzzah.current_role
    end

    ##
    # Switches between user roles.
    #
    #  as :user
    #
    # It is usually used in conjunction with visit: [site_name]
    #
    #  as :user, visit: 'dreamcars'
    #
    def as(role_name, site = nil, &block)
      name = role_name.to_sym
      raise Huzzah::UndefinedRoleError, "#{name}" unless Huzzah.sessions.has_key? name
      Huzzah.current_role = name
      Huzzah.current_session = Huzzah.sessions[name]
      visit site unless site.nil?
      yield if block_given?
    end

    ##
    # Launches a browser (if applicable) and navigates the user
    # to the given site. The url used is pulled from the site's
    # YAML config file and defaults to the environment that you
    # specify when you call Huzzah.configure.
    #
    def visit(site)
      site_name = site.kind_of?(Hash) ? site.values.first.to_sym : site.to_sym
      raise Huzzah::UnkownSiteError, "#{site_name}" unless Huzzah.sites.has_key? site_name
      initialize_browser site_name
      Huzzah.current_session.site = site_name
    end

    ##
    # Closes all open browsers for all user roles and resets
    # all user sessions
    #
    def close_all_browsers
      Huzzah.sessions.each_pair do |role, session|
        unless session.nil?
          session.quit
          Huzzah.sessions[role] = Huzzah::Session.new
        end
      end
    end

    ##
    # Switches focus back to the main browser.
    #
    def switch_to_main_browser
      windows.first.use
    end

    ##
    # Switches focus to a popup window. The default is to use a
    # portion of the new window's title property, but you can
    # also use the url property.
    #  switch_to_window 'Contact Us'
    #  switch_to_window title: 'Contact Us'
    #  switch_to_window url: 'contact_us'
    #
    #
    def switch_to_window(locator, timeout=60)
      wait_until(timeout) { windows.size > 1 }
      if locator.kind_of? Hash
        if locator.has_key? :url
          return find_window_by_url locator[:url]
        else
          return find_window_by_title locator[:title]
        end
      else
        find_window_by_title locator
      end
    end

    ##
    # Waits up to 30 seconds for AJAX calls to complete.
    # Currently only works with jQuery.
    #
    def wait_for_ajax
      wait_until { execute_script("return jQuery.active") == 0 }
    end

    ##
    # Returns the underlying Selenium driver
    #
    def driver
      Huzzah.current_session.browser.driver
    end

    ##
    # Closes the browser for the current user role and opens
    # a new session, but does not launch a new browser. A new
    # browser will be launched when the visit method is called.
    #
    def close
      Huzzah.reset_current_session!
    end

    ##
    # Wrapper for Watir::Browser.cookies.clear
    #
    def clear_cookies
      Huzzah.current_session.browser.cookies.clear
    end

    ##
    # Wrapper for Watir::Browser.execute_script
    #
    def execute_script(script, *args)
      Huzzah.current_session.browser.execute_script script, *args
    end

    ##
    # Wrapper for Watir::Browser.goto
    #
    def goto(url)
      Huzzah.current_session.browser.goto url
    end

    ##
    # Wrapper for Watir::Browser.html
    #
    def page_html
      Huzzah.current_session.browser.html
    end

    ##
    # Wrapper for Watir::Browser.ready_state
    #
    def ready_state
      Huzzah.current_session.browser.ready_state
    end

    ##
    # Wrapper for Watir::Browser.send_keys
    #
    def send_keys(*args)
      Huzzah.current_session.browser.send_keys *args
    end

    ##
    # Wrapper for Watir::Browser.text
    #
    def page_text
      Huzzah.current_session.browser.text
    end

    ##
    # Wrapper for Watir::Browser.title
    #
    def page_title
      Huzzah.current_session.browser.title
    end

    ##
    # Wrapper for Watir::Browser.url
    #
    def page_url
      Huzzah.current_session.browser.url
    end

    ##
    # Wrapper for Watir::Browser.refresh
    #
    def refresh
      Huzzah.current_session.browser.refresh
    end

    ##
    # Wrapper for Watir::Browser.wait_until
    #
    def wait_until(*args, &block)
      Huzzah.current_session.browser.wait_until *args, &block
    end

    ##
    # Wrapper for Watir::Browser.wait_while
    #
    def wait_while(*args, &block)
      Huzzah.current_session.browser.wait_while *args, &block
    end

    ##
    # Wrapper for Watir::Browser.window
    #
    def window(*args, &block)
      Huzzah.current_session.browser.window *args, &block
    end

    ##
    # Wrapper for Watir::Browser.windows
    #
    def windows(*args)
      Huzzah.current_session.browser.windows *args
    end

    ##
    # Loads the configuration data for a site (loaded from
    # the site's YAML file) without launching a browser.
    #
    def load_config(site)
      Huzzah.current_session.site = site.to_sym
    end

    ##
    # Returns the configuration data for the current site (loaded from
    # the site's YAML file).
    #
    # @return [OpenStruct] The site configuration
    #
    def site_config
      Huzzah.sites[current_site]
    end

    private

    def on(page_class, &block)
      if Huzzah.pages[page_class].nil?
        Huzzah.pages[page_class] = page_class.constantize.new
      end
      page = Huzzah.pages[page_class]
      page.browser = Huzzah.current_session.browser
      page.instance_eval(&block) if block_given?
      page
    end

    def site_for_current_role
      Huzzah.sessions[Huzzah.current_role].site
    end

    def initialize_browser(site_name)
      Huzzah.current_session.start
      Huzzah.current_session.browser.goto Huzzah.sites[site_name].url
    end

    def find_window_by_url(url)
      windows.each do |popup|
        popup.use
        break if popup.url.include? url
      end
      browser
    end

    def find_window_by_title(title)
      windows.each do |popup|
        popup.use
        break if popup.title.include? title
      end
      browser
    end


  end
end