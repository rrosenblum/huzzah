require 'forwardable'

module Huzzah
  class Page < Huzzah::Base
    extend Locator
    extend PartialBuilder
    extend Forwardable

    def_delegators :browser, :p

  end
end
