module Huzzah
  module DSL
    include FileLoader
    include SiteBuilder
    include FlowBuilder

    # :nodoc:
    def generate_dsl_methods!
      load_files!
      generate_site_methods!
      generate_flow_methods!
    end

  end
end