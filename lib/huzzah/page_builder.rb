module Huzzah::PageBuilder

  private

  def generate_page_methods
    pages = Object.const_get(@site_name).constants
    pages.each do |page|
      site_module = @site_name.to_s
      method_name = page.to_s.underscore
      Huzzah::Site.class_eval do
        define_method(method_name) do
          "#{site_module}::#{page.to_s}".constantize.new @role_data, @browser
        end
      end
    end
  end

end