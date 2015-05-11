require 'spec_helper'

describe Huzzah, 'DSL' do

  include Huzzah::DSL

  before(:each) do
    Huzzah.reset!
    Huzzah.configure do |config|
      config.path = "#{$PROJECT_ROOT}/sandbox/huzzah"
      config.browser_type = :firefox
      config.environment = 'dev'
    end
  end

  after(:each) do
    close_all_browsers
  end

  it "should visit a site" do
    Huzzah.add_roles :buyer, :seller
    as :buyer
    visit 'dreamcars'
    expect(page_url).to eql 'http://dreamcars-manheim.rhcloud.com/home'
  end

  it "should switch the current user role and optionally visit a site" do
    Huzzah.add_roles :user, :buyer, :seller
    as :user, on: 'dreamcars'
    expect(page_url).to eql 'http://dreamcars-manheim.rhcloud.com/home'
  end

  it "should raise error if user role is not defined" do
    expect { as :buyer }.to raise_error Huzzah::UndefinedRoleError, 'buyer'
  end

  it "should handle switching browser windows" do
    Huzzah.add_role :user
    as(:user, on: 'dreamcars') do
      dreamcars(:header).contact_us
      switch_to_window 'Contact Us'
    end
    expect(page_title).to eql 'Contact Us | MDC'
  end

  it "should handle switching back to main window" do
    Huzzah.add_role :user
    as(:user, on: 'dreamcars') do
      dreamcars(:header).contact_us
      switch_to_window 'Contact Us'
      switch_to_main_browser
    end
    expect(page_title).to eql 'Home | MDC'
  end

  it "should load a site config" do
    Huzzah.add_role :user
    load_config :dreamcars
    expect(site_config.url).to eql 'http://dreamcars-manheim.rhcloud.com'
  end


end