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
      visit(@config[:url]) if @browser.url.eql? 'about:blank' and !@config[:url].nil?
    end

    def on(page)
      unless page.is_a? Symbol or page.is_a? String
        fail TypeError, 'You must pass a Symbol or String to the #on method'
      end
      send(page)
    end

  end
end