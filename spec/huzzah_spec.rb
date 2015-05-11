require 'spec_helper'

describe Huzzah do

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

  it "should return the configuration" do
    expect(Huzzah.configuration[:path]).to include '/huzzah/spec/sandbox/huzzah'
    expect(Huzzah.configuration[:browser_type]).to eql :firefox
    expect(Huzzah.configuration[:environment]).to eql 'dev'
  end

  it "should load site configs" do
    expect(Huzzah.sites.keys.sort).to eql [:dreamcars, :testsite]
    expect(Huzzah.sites[:testsite].url).to eql 'index.html'
  end

  it "should define a user role" do
    Huzzah.add_role :user
    Huzzah.add_role 'seller'
    expect(Huzzah.sessions.keys).to eql [:user, :seller]
  end

  it "should define multiple user roles" do
    Huzzah.add_roles :user, 'buyer', :seller, :admin
    expect(Huzzah.sessions.keys.sort).to eql [:admin, :buyer, :seller,:user]
  end

  it "should raise error if user role is already defined" do
    expect { Huzzah.add_roles :buyer, :seller, :buyer }.to raise_error Huzzah::RoleAlreadyDefinedError, 'buyer'
  end

  it "should know the current user role" do
    Huzzah.add_role :user
    expect(Huzzah.current_role).to eql :user
  end

  it "should switch the current user role" do
    Huzzah.add_roles :buyer, :seller
    as :buyer
    expect(Huzzah.current_role).to eql :buyer
  end

  it "should load partials" do
    expect(Huzzah.pages).to have_key 'Dreamcars::Header'
    expect(Huzzah.pages).to have_key 'Testapp::Header'
  end

  it "should load pages" do
    expect(Huzzah.pages).to have_key 'Dreamcars::HomePage'
    expect(Huzzah.pages).to have_key 'Testapp::HomePage'
  end

  it "should define DSL methods to return pages" do
    expect(Huzzah::DSL.instance_methods).to include :dreamcars
    expect(Huzzah::DSL.instance_methods).to include :testapp
  end

  it "allow for custom browser driver" do
    Huzzah.config.grid_url = 'http://my.gridhub.server:9000/wd/hub'
    Huzzah.config.remote = true
    Huzzah.config.chrome(:switches => ["%w[--ignore-certificate-errors]"],
                          :version => '21', :platform => 'linux')

    Huzzah.add_role :user
    as :user, visit: 'dreamcars'
    expect(page_title).to eql 'Home | MDC'
  end

end