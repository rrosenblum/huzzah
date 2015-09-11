module Huzzah::SiteLoader
  private
  def add_to_role(site)
    Huzzah::Role.class_eval do
      define_method(site.to_s.demodulize.underscore) { site.new }
    end
  end
end