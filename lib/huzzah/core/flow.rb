module Huzzah
  class Flow < Huzzah::Base
    include DSL

    def initialize
      generate_site_methods!
      generate_flow_methods!
    end

  end
end
