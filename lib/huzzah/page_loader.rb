module Huzzah::PageLoader
  private
  def get_site_for(page)
    module_name = page.to_s.deconstantize.constantize
    module_name.const_get(page.to_s.deconstantize.constantize.to_s)
  end

  def add_to_site(page)
    get_site_for(page).class_eval do
      define_method(page.to_s.demodulize.underscore) { page.new }
    end
  end
end