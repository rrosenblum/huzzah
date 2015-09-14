module Huzzah
  class Site
    include PageLoader

    def initialize
      add_pages!
    end

  end
end