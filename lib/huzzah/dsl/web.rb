module Huzzah
  module DSL
    module Web

      ##
      # Closes all open browsers for all user roles and resets
      # all user sessions
      #
      def close_all_browsers
        Huzzah.roles.each_value do |role|
          unless role.session.driver.nil?
            role.session.quit
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
      # Wrapper for Watir::Browser.cookies.clear
      #
      def clear_cookies
        browser.cookies.clear
      end

      ##
      # Wrapper for Watir::Browser.goto
      #
      def goto(url)
        browser.goto url
      end

      ##
      # Wrapper for Watir::Browser.html
      #
      def page_html
        browser.html
      end

      ##
      # Wrapper for Watir::Browser.ready_state
      #
      def ready_state
        browser.ready_state
      end

      ##
      # Wrapper for Watir::Browser.send_keys
      #
      def send_keys(*args)
        browser.send_keys *args
      end

      ##
      # Wrapper for Watir::Browser.text
      #
      def page_text
        browser.text
      end

      ##
      # Wrapper for Watir::Browser.title
      #
      def page_title
        browser.title
      end

      ##
      # Wrapper for Watir::Browser.url
      #
      def page_url
        browser.url
      end

      ##
      # Wrapper for Watir::Browser.refresh
      #
      def refresh
        browser.refresh
      end

      ##
      # Wrapper for Watir::Browser.wait_while
      #
      def wait_while(*args, &block)
        browser.wait_while *args, &block
      end

      ##
      # Wrapper for Watir::Browser.window
      #
      def window(*args, &block)
        browser.window *args, &block
      end

      ##
      # Wrapper for Watir::Browser.windows
      #
      def windows(*args)
        browser.windows *args
      end


      private

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


      private

      def browser
        Huzzah.active_role.session.driver
      end

    end
  end
end