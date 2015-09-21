module Huzzah
  class Site < Browseable
    include FileLoader
    include PageBuilder

    attr_reader :site_name, :config, :role_data

    def initialize(role_data, browser)
      super(role_data, browser)
      @site_name = self.class.name.demodulize.to_sym
      @config = load_config("#{Huzzah.path}/sites/#{@site_name}.yml")
      generate_page_methods!(role_data, @browser)
      visit(config[:url]) unless @config[:url].nil?
    end

  end
end