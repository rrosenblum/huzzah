require 'spec_helper'

describe Huzzah, 'Session' do

  after(:each) do
    @session.driver.close unless @session.driver.nil?
    Huzzah.reset!
  end

  it 'defaults to :web driver_type' do
    @session = Huzzah::Session.new
    expect(@session.driver_type).to eql :web
  end

  it 'starts a browser locally' do
    configure_google
    @session = Huzzah::Session.new
    @session.start
    expect(@session.driver).to be_kind_of Watir::Browser
  end

  it 'starts a browser remotely' do
    Huzzah.configure do |config|
      config.path = "#{$PROJECT_ROOT}/examples/google"
      config.grid_url = File.readlines('grid.txt').first
      config.chrome(:version => '21', :platform => 'linux')
      config.environment = 'prod'
    end
    @session = Huzzah::Session.new
    @session.start
    expect(@session.driver).to be_kind_of Watir::Browser
  end

  it 'creates a clean slate in the browser' do
    configure_google
    @session = Huzzah::Session.new
    @session.start
    @session.reset!
    expect(@session.driver.url).to eql 'about:blank'
  end

  it 'closes the browser' do
    configure_google
    @session = Huzzah::Session.new
    @session.start
    @session.quit
    expect(@session.driver).not_to be_exists
  end

  it 'loads site data and navigates to the site url' do
    configure_google
    @session = Huzzah::Session.new
    @session.start
    @session.load_site :google, true
    expect(@session.site).to eql :google
    expect(@session.driver.url).to include 'google.com'
  end

  it 'loads site data without navigating to the site url' do
    configure_google
    @session = Huzzah::Session.new
    @session.start
    @session.load_site :google
    expect(@session.site).to eql :google
    expect(@session.site_data.url).to eql 'http://www.google.com'
  end


end