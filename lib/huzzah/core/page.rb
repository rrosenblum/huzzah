require 'forwardable'

module Huzzah
  class Page < Huzzah::Base
    extend Locator
    extend PartialBuilder
    extend Forwardable

    def initialize(role_data, browser)
      @role_date = role_data
      @browser = browser
    end

    def_delegators :browser, :p

  end
end
