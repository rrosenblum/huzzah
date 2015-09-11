module Huzzah
  class Page
    extend PartialLoader
    extend Locator
    extend PageLoader

    def self.inherited(page)
      add_to_site(page)
    end

  end
end