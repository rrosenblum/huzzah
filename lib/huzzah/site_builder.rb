module Huzzah::SiteBuilder

  attr_accessor :sites

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
    @browser = Huzzah.drivers[@driver].call
  end


  private

  def generate_site_methods(site_names)
    @sites = {}
    site_names.each do |site_name|
      method_name = site_name.to_s.underscore
      Huzzah::Role.class_eval do
        define_method(method_name) do
          site_name = __method__.capitalize
          return @sites[site_name] if @sites.key? site_name
          @sites[site_name] = Huzzah::Site.new site_name, @role_data
          if @sites[site_name].config
            instantiate_browser site_name
          else
            pass_browser_to_site site_name
          end
          @sites[site_name]
        end
      end
    end
  end

  def instantiate_browser(site_name)
    launch_browser if @browser.nil?
    @sites[site_name].browser = @browser
    @sites[site_name].visit
  end

  def pass_browser_to_site(site_name)
    @sites[site_name].browser = @browser if @browser
  end
end