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
      @browser.goto(url)
    end
  end
end