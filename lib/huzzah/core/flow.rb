module Huzzah
  class Flow < Huzzah::Base
    include DSL

    def initialize(role_data, browser)
      @role_data = role_data
      @browser = browser
      generate_site_methods!
      generate_flow_methods!
    end

  end
end
