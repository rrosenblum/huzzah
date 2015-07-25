module Huzzah
  module DSL
    module Mobile

      ##
      # Search existing web views for a unique piece of text
      # and switch context to that web view.
      #
      def switch_to_webview(text, timeout=30)
        search_time = timeout
        located = false
        while timeout > 0 do
          begin
            $driver.driver.window_handles.each_index do |index|
              $driver.driver.switch_to.window($driver.driver.window_handles[index])
              if get_source.include? text
                located = true
                break
              else
                sleep 0.5
                timeout = timeout - 0.5
              end
            end
            break if located
          rescue Selenium::WebDriver::Error::UnknownError
            puts 'Selenium::WebDriver::Error::UnknownError'
          end
        end
        fail "WebView: #{text} failed to load for #{search_time} seconds." unless located
      end

      def server_url
        $driver.server_url
      end

      def restart
        $driver.restart
      end

      def driver_quit
        $driver.driver_quit
      end

      def no_wait
        $driver.no_wait
      end

      def set_wait(timeout=nil)
        $driver.set_wait timeout
      end

      def exists(pre_check = 0, post_check = @default_wait, &search_block)
        $driver.exists pre_check, post_check, &search_block
      end

      def find_elements(*args)
        $driver.find_elements *args
      end

      def find_element(*args)
        $driver.find_element *args
      end

      def set_location(opts = {})
        $driver.set_location opts
      end

      def source
        $driver.source
      end

      def get_source
        $driver.get_source
      end

    end
  end
end