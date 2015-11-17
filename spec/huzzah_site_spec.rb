require_relative 'support/spec_helper'

describe Huzzah::Site do

  before(:each) do
    Huzzah.configure do |config|
      config.path = "#{$PROJECT_ROOT}/spec/examples"
      config.environment = 'prod'
      config.default_driver = :firefox
    end
  end

  after(:each) do
    @role.browser.close if @role.browser
  end

  it "knows it's name" do
    @role = Huzzah::Role.new
    expect(@role.bing.site_name).to eql(:bing)
  end

  it 'automatically loads the config' do
    @role = Huzzah::Role.new
    expect(@role.google.config[:title]).to eql('Google')
  end

  it 'automatically assigns the role data' do
    @role = Huzzah::Role.new :standard_user
    expect(@role.bing.role_data[:full_name]).to eql('George Washington')
  end

  it 'knows the browser' do
    @role = Huzzah::Role.new
    expect(@role.google.browser).to be_a(Watir::Browser)
  end

  it 'automatically loads the pages for the site' do
    @role = Huzzah::Role.new
    expect(@role.google.home).to be_a(Huzzah::Page)
  end

end