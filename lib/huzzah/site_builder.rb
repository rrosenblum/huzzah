module Huzzah::SiteBuilder
  ##
  # Launches a browser for the role. It uses the default driver
  # unless a driver is specified in the role's YAML file.
  #
  def launch_browser
    if @role_data.key? :driver
      @driver = @role_data[:driver]
    else
      @driver = Huzzah.default_driver
    end
    unless Huzzah.drivers.key? @driver
      fail Huzzah::DriverNotDefinedError, "Driver '#{@driver}' is not defined."
    end
    @browser ||= Huzzah.drivers[@driver].call
  end


  private

  def define_sites!
    get_site_names.each do |site|
      next if site_defined?(site)
      site.deconstantize.constantize.const_set(site.demodulize, Class.new(Huzzah::Site))
    end
  end

  def get_site_names
    Huzzah::Page.subclasses.map(&:to_s).map(&:deconstantize).flat_map { |m| "#{m}::#{m}" }.uniq
  end

  def site_defined?(site)
    return true if site.constantize rescue NameError
    false
  end

  def generate_site_methods(role_data)
    define_sites!
    Huzzah::Site.subclasses.each do |site|
      define_singleton_method(site.to_s.demodulize.underscore.to_sym) { site.new(role_data, launch_browser) }
    end
  end
end