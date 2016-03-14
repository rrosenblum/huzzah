require 'support/spec_helper'

describe Huzzah::Page do

  before(:each) do
    Huzzah.configure do |config|
      config.path = "#{$PROJECT_ROOT}/spec/examples"
      config.environment = 'prod'
      config.default_driver = :firefox
    end
  end

  after(:each) do
    @role.browser.close if @role && @role.browser
  end

  it 'returns a instance of a page' do
    @role = Huzzah::Role.new
    expect(@role.search_flow).to be_a(Huzzah::Flow)
  end

  it 'executes actions across sites' do
    @role = Huzzah::Role.new
    @role.search_flow.google_to_bing
    expect(@role.browser.title).to include('Bing')
  end

end