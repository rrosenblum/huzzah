module Huzzah
  class Browseable
    include Browser
    extend Locator

    attr_accessor :role_data

    def initialize(role_data = nil, browser = nil)
      @role_data = role_data
      @browser = browser
    end

    def visit(url)
      #Holy dirty code, batman!
      Watir::Wait.until(5) do
        @browser.goto(url)
        URI.parse(@browser.url).host.include?(URI.parse(url).host)
      end
    end
  end
end