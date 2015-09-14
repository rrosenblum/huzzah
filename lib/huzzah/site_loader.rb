module Huzzah::SiteLoader
  private
  def add_sites!
    Huzzah::Site.subclasses.each do |site|
      define_singleton_method(site.to_s.demodulize.underscore.to_sym) { site.new }
    end
  end
end