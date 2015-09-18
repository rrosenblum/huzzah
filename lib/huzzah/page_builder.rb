module Huzzah::PageBuilder
  private
  def generate_page_methods!(role_data, browser)
    pages = Huzzah::Page.subclasses.select { |page| page.to_s.deconstantize == self.class.to_s.demodulize }
    pages.each { |page| define_singleton_method(page.to_s.demodulize.underscore.to_sym) { page.new(role_data, browser) } }
  end
end