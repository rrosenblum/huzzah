module Huzzah
  module DSL
    module Shared

      # This module contains methods that work with both
      # watir-webdriver and Appium. The framework will
      # select the appropriate driver at execution time.

      # #
      # Take a screenshot. Appium requires a path. Watir-WebDriver does not.
      #
      def screenshot(path=nil)
        if user_context.eql? :web
          driver.screenshot
        else
          driver.screenshot path
        end
      end

      def execute_script(script, *args)
        driver.execute_script script, *args
      end

      def wait_until(timeout=30, &block)
        if user_context.eql? :web
          driver.wait_until timeout, &block
        else
          $driver.wait_true timeout, &block
        end
      end




      private

      def driver
        Huzzah.active_role.session.driver
      end

      def user_context
        Huzzah.active_role.user_type
      end

    end
  end
end