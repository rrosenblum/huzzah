module Huzzah
  module DSL
    module Framework

      ##
      # Shortcut to get the browser for the current user session.
      #
      # @return [Watir::Browser] The browser instance for the current user session.
      #
      def browser
        Huzzah.active_role.driver
      end

      ##
      # Returns the name of the site that the current session is using.
      #
      # @return [String] The name of the site
      #
      def active_site
        Huzzah.active_role.session.site
      end
      alias_method :current_site, :active_site

      ##
      # Returns the name of the current user role.
      #
      # @return [String] The current user role
      #
      def active_role
        Huzzah.active_role.name
      end
      alias_method :current_role, :active_role

      ##
      # Switches between user roles.
      #
      #  as :user
      #
      # It is usually used in conjunction with visit: [site_name]
      #
      #  as :user, visit: 'google'
      #
      def as(role_name, site=nil, &block)
        name = role_name.to_sym
        unless Huzzah.roles.has_key? name
          fail Huzzah::UndefinedRoleError, "#{name}"
        end
        Huzzah.active_role = Huzzah.roles[name]
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
        site_name = parse_site_name site
        unless Huzzah.sites.has_key? site_name
          fail Huzzah::UnkownSiteError, "#{site_name}"
        end
        Huzzah.active_role.session.start
        Huzzah.active_role.session.load_site site_name, true
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
      def driver(type=:web)
        if type.eql? :web
          Huzzah.active_role.session.driver
        else # Appium Driver
          $driver.driver
        end
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
      # Loads the configuration data for a site (loaded from
      # the site's YAML file) without launching a browser.
      #
      def load_config(site)
        Huzzah.active_role.session.load_site site
      end

      ##
      # Returns the configuration data for the current site (loaded from
      # the site's YAML file).
      #
      # @return [OpenStruct] The site configuration
      #
      def site_config
        Huzzah.sites[active_site]
      end

      def user_context
        Huzzah.active_role.user_type
      end

      private

      def on(page_class, &block)
        if Huzzah.pages[page_class].nil?
          Huzzah.pages[page_class] = page_class.constantize.new
        end
        page = Huzzah.pages[page_class]
        if page.is_a? Huzzah::Page
          page.browser = Huzzah.active_role.session.driver
        end
        page.instance_eval(&block) if block_given?
        page
      end

      def site_for_current_role
        Huzzah.sessions[Huzzah.current_role].site
      end

      def parse_site_name(site)
        if site.is_a? Hash
          site.values.first.to_sym
        else
          site.to_sym
        end
      end

    end
  end
end