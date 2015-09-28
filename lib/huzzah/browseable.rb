module Huzzah
  class Browseable
    include Browser
    extend Locator

    attr_accessor :role_data

    def initialize(role_data = nil, browser = nil)
      @role_data = role_data
      @browser = browser
    end

    def visit
      #Holy dirty code, batman!
      Watir::Wait.until(5) do
        @browser.goto(@config[:url]) unless @config[:url].nil?
        URI.parse(@browser.url).host.include?(URI.parse(url).host)
      end
      self
    end
  end
end