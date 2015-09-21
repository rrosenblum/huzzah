module Huzzah
  class Page < Browseable
    extend PartialLoader

    def initialize(role_data, browser)
      super(role_data, browser)
    end

  end
end